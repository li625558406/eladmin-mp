/*
 *  Copyright 2019-2025 Zheng Jie
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */
package me.zhengjie.modules.system.service.impl;

import cn.hutool.core.util.RandomUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import me.zhengjie.exception.BadRequestException;
import me.zhengjie.modules.system.domain.EmailVerifyCode;
import me.zhengjie.modules.system.mapper.EmailVerifyCodeMapper;
import me.zhengjie.modules.system.service.EmailVerifyCodeService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.mail.internet.MimeMessage;
import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 * 邮箱验证码Service实现
 * @author KONUS AI
 * @date 2026-02-02
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class EmailVerifyCodeServiceImpl extends ServiceImpl<EmailVerifyCodeMapper, EmailVerifyCode> implements EmailVerifyCodeService {

    private final JavaMailSender mailSender;
    private final EmailVerifyCodeMapper emailVerifyCodeMapper;

    @Value("${spring.mail.username}")
    private String from;

    @Value("${code.expiration:300}")
    private Integer expiration;

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean sendVerifyCode(String email, String type) {
        // 验证邮箱格式
        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            throw new BadRequestException("邮箱格式不正确");
        }

        // 检查是否在1分钟内发送过验证码
        Date oneMinuteAgo = new Date(System.currentTimeMillis() - 60 * 1000);
        LambdaQueryWrapper<EmailVerifyCode> checkWrapper = new LambdaQueryWrapper<>();
        checkWrapper.eq(EmailVerifyCode::getEmail, email)
                .eq(EmailVerifyCode::getType, type)
                .gt(EmailVerifyCode::getCreateTime, oneMinuteAgo);
        
        long recentCount = count(checkWrapper);
        if (recentCount > 0) {
            throw new BadRequestException("验证码发送过于频繁，请1分钟后再试");
        }

        // 生成6位随机数字验证码
        String code = RandomUtil.randomNumbers(6);

        // 计算过期时间
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.SECOND, expiration);
        Date expireTime = calendar.getTime();

        // 保存验证码到数据库
        EmailVerifyCode verifyCode = new EmailVerifyCode();
        verifyCode.setEmail(email);
        verifyCode.setCode(code);
        verifyCode.setType(type);
        verifyCode.setExpireTime(expireTime);
        verifyCode.setUsed(false);
        verifyCode.setCreateTime(new Date());
        save(verifyCode);

        // 发送邮件
        try {
            MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            
            helper.setFrom(from);
            helper.setTo(email);
            
            String typeText = getTypeText(type);
            helper.setSubject("KONUS AI - " + typeText + "验证码");
            
            // 格式化时间
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            String currentTime = sdf.format(new Date());
            
            // HTML邮件内容
            String htmlContent = buildEmailHtml(typeText, code, expiration / 60, currentTime);
            helper.setText(htmlContent, true);
            
            mailSender.send(mimeMessage);
            
            log.info("验证码邮件发送成功: email={}, type={}, code={}", email, type, code);
            return true;
        } catch (Exception e) {
            log.error("验证码邮件发送失败: email={}, type={}", email, type, e);
            throw new BadRequestException("验证码发送失败，请稍后重试");
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public boolean verifyCode(String email, String code, String type) {
        // 查询最近的未使用的验证码
        LambdaQueryWrapper<EmailVerifyCode> wrapper = new LambdaQueryWrapper<>();
        wrapper.eq(EmailVerifyCode::getEmail, email)
                .eq(EmailVerifyCode::getCode, code)
                .eq(EmailVerifyCode::getType, type)
                .eq(EmailVerifyCode::getUsed, false)
                .gt(EmailVerifyCode::getExpireTime, new Date())
                .orderByDesc(EmailVerifyCode::getCreateTime)
                .last("LIMIT 1");

        EmailVerifyCode verifyCode = getOne(wrapper);
        
        if (verifyCode == null) {
            return false;
        }

        // 标记为已使用
        verifyCode.setUsed(true);
        verifyCode.setUsedTime(new Date());
        updateById(verifyCode);

        log.info("验证码验证成功: email={}, type={}", email, type);
        return true;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public void cleanExpiredCodes() {
        // 清理7天前的验证码记录
        Calendar calendar = Calendar.getInstance();
        calendar.add(Calendar.DAY_OF_MONTH, -7);
        Timestamp sevenDaysAgo = new Timestamp(calendar.getTimeInMillis());
        
        emailVerifyCodeMapper.deleteExpiredCodes(sevenDaysAgo);
        log.info("清理过期验证码完成");
    }

    /**
     * 获取类型文本
     */
    private String getTypeText(String type) {
        switch (type) {
            case "register":
                return "注册";
            case "login":
                return "登录";
            case "reset":
                return "重置密码";
            default:
                return "验证";
        }
    }

    /**
     * 构建HTML邮件内容 - 高级清新风格
     */
    private String buildEmailHtml(String typeText, String code, int validMinutes, String currentTime) {
        return "<!DOCTYPE html>" +
            "<html>" +
            "<head>" +
            "    <meta charset='UTF-8'>" +
            "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
            "    <link href='https://fonts.googleapis.com/css2?family=JetBrains+Mono:wght@400;700&family=Outfit:wght@300;500;700&display=swap' rel='stylesheet'>" +
            "</head>" +
            "<body style='margin: 0; padding: 0; background: linear-gradient(135deg, #E0E7FF 0%, #F3E8FF 50%, #FCE7F3 100%); font-family: \"Outfit\", -apple-system, sans-serif;'>" +
            "    <table width='100%' cellpadding='0' cellspacing='0' style='background: linear-gradient(135deg, #E0E7FF 0%, #F3E8FF 50%, #FCE7F3 100%); padding: 30px 20px;'>" +
            "        <tr>" +
            "            <td align='center'>" +
            "                <!-- Main Container -->" +
            "                <table width='550' cellpadding='0' cellspacing='0' style='background: rgba(255, 255, 255, 0.9); backdrop-filter: blur(20px); border-radius: 20px; box-shadow: 0 20px 40px rgba(45, 91, 255, 0.15), 0 0 0 1px rgba(255, 255, 255, 0.8); overflow: hidden; position: relative;'>" +
            "                    " +
            "                    <!-- Decorative Background Pattern -->" +
            "                    <tr>" +
            "                        <td style='position: absolute; width: 100%; height: 100%; background: radial-gradient(circle at 15% 30%, rgba(224, 231, 255, 0.4) 0%, transparent 40%), radial-gradient(circle at 85% 70%, rgba(252, 231, 243, 0.3) 0%, transparent 40%);'></td>" +
            "                    </tr>" +
            "                    " +
            "                    <!-- Header with Brand -->" +
            "                    <tr>" +
            "                        <td style='padding: 35px 40px 25px; position: relative; z-index: 1;'>" +
            "                            <!-- Logo Area -->" +
            "                            <table width='100%' cellpadding='0' cellspacing='0'>" +
            "                                <tr>" +
            "                                    <td>" +
            "                                        <div style='display: inline-block; padding: 10px 24px; background: linear-gradient(135deg, rgba(45, 91, 255, 0.1) 0%, rgba(78, 127, 255, 0.05) 100%); border: 1.5px solid rgba(45, 91, 255, 0.2); border-radius: 12px; backdrop-filter: blur(10px);'>" +
            "                                            <h1 style='margin: 0; color: #2D5BFF; font-size: 22px; font-weight: 700; letter-spacing: 2px; font-family: \"JetBrains Mono\", monospace;'>KONUS<span style='color: #FF6B9D;'>·</span>AI</h1>" +
            "                                        </div>" +
            "                                    </td>" +
            "                                </tr>" +
            "                            </table>" +
            "                            " +
            "                            <!-- Title -->" +
            "                            <h2 style='margin: 28px 0 10px 0; color: #1a1a2e; font-size: 26px; font-weight: 700; line-height: 1.2;'>" + typeText + "验证码</h2>" +
            "                            <p style='margin: 0; color: #64748B; font-size: 14px; font-weight: 300; line-height: 1.5;'>请使用以下验证码完成您的<span style='color: #2D5BFF; font-weight: 500;'>" + typeText + "</span>操作</p>" +
            "                        </td>" +
            "                    </tr>" +
            "                    " +
            "                    <!-- Verification Code Section -->" +
            "                    <tr>" +
            "                        <td style='padding: 0 40px 35px; position: relative; z-index: 1;'>" +
            "                            <!-- Code Container -->" +
            "                            <div style='background: linear-gradient(135deg, rgba(224, 231, 255, 0.6) 0%, rgba(243, 232, 255, 0.4) 100%); border: 2px solid rgba(45, 91, 255, 0.15); border-radius: 16px; padding: 30px 25px; text-align: center; position: relative; overflow: hidden; box-shadow: 0 8px 30px rgba(45, 91, 255, 0.08);'>" +
            "                                <!-- Subtle Glow -->" +
            "                                <div style='position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 250px; height: 250px; background: radial-gradient(circle, rgba(45, 91, 255, 0.1) 0%, transparent 70%); filter: blur(50px);'></div>" +
            "                                " +
            "                                <!-- Code Label -->" +
            "                                <p style='margin: 0 0 18px 0; color: #64748B; font-size: 12px; font-weight: 600; letter-spacing: 1.5px; text-transform: uppercase;'>验证码 / Verification Code</p>" +
            "                                " +
            "                                <!-- The Code -->" +
            "                                <div style='position: relative; display: inline-block; padding: 18px 32px; background: rgba(255, 255, 255, 0.8); border-radius: 14px; box-shadow: 0 6px 24px rgba(45, 91, 255, 0.12), inset 0 1px 0 rgba(255, 255, 255, 1);'>" +
            "                                    <p style='margin: 0; color: #2D5BFF; font-size: 42px; font-weight: 700; letter-spacing: 12px; font-family: \"JetBrains Mono\", monospace; text-shadow: 0 2px 10px rgba(45, 91, 255, 0.2);'>" + code + "</p>" +
            "                                </div>" +
            "                                " +
            "                                <!-- Validity Info -->" +
            "                                <div style='margin-top: 24px; padding-top: 24px; border-top: 1px solid rgba(45, 91, 255, 0.1);'>" +
            "                                    <table width='100%' cellpadding='0' cellspacing='0'>" +
            "                                        <tr>" +
            "                                            <td width='50%' style='text-align: center; padding: 8px;'>" +
            "                                                <div style='color: #94A3B8; font-size: 11px; font-weight: 600; margin-bottom: 6px;'>有效期</div>" +
            "                                                <div style='color: #2D5BFF; font-size: 18px; font-weight: 700; font-family: \"JetBrains Mono\", monospace;'>" + validMinutes + "<span style='font-size: 13px; color: #64748B; font-weight: 500; margin-left: 3px;'>分钟</span></div>" +
            "                                            </td>" +
            "                                            <td width='50%' style='text-align: center; padding: 8px; border-left: 1px solid rgba(45, 91, 255, 0.1);'>" +
            "                                                <div style='color: #94A3B8; font-size: 11px; font-weight: 600; margin-bottom: 6px;'>操作类型</div>" +
            "                                                <div style='color: #1a1a2e; font-size: 14px; font-weight: 600;'>" + typeText + "</div>" +
            "                                            </td>" +
            "                                        </tr>" +
            "                                    </table>" +
            "                                </div>" +
            "                            </div>" +
            "                            " +
            "                            <!-- Security Notice -->" +
            "                            <div style='margin-top: 24px; padding: 18px 20px; background: linear-gradient(135deg, rgba(252, 231, 243, 0.6) 0%, rgba(243, 232, 255, 0.4) 100%); border: 1.5px solid rgba(255, 107, 157, 0.2); border-radius: 14px; box-shadow: 0 4px 16px rgba(255, 107, 157, 0.08);'>" +
            "                                <table width='100%' cellpadding='0' cellspacing='0'>" +
            "                                    <tr>" +
            "                                        <td width='40' style='vertical-align: top;'>" +
            "                                            <div style='width: 32px; height: 32px; background: linear-gradient(135deg, rgba(255, 107, 157, 0.15) 0%, rgba(255, 107, 157, 0.08) 100%); border: 1.5px solid rgba(255, 107, 157, 0.25); border-radius: 10px; display: flex; align-items: center; justify-content: center; font-size: 16px;'>🔒</div>" +
            "                                        </td>" +
            "                                        <td style='padding-left: 14px; vertical-align: top;'>" +
            "                                            <p style='margin: 0 0 6px 0; color: #1a1a2e; font-size: 13px; font-weight: 600;'>安全提醒</p>" +
            "                                            <p style='margin: 0; color: #64748B; font-size: 12px; line-height: 1.6;'>请勿向任何人透露此验证码。KONUS AI 官方不会主动索要您的验证码。</p>" +
            "                                        </td>" +
            "                                    </tr>" +
            "                                </table>" +
            "                            </div>" +
            "                        </td>" +
            "                    </tr>" +
            "                    " +
            "                    <!-- Footer -->" +
            "                    <tr>" +
            "                        <td style='padding: 28px 40px; border-top: 1px solid rgba(45, 91, 255, 0.08); position: relative; z-index: 1;'>" +
            "                            <table width='100%' cellpadding='0' cellspacing='0'>" +
            "                                <tr>" +
            "                                    <td style='text-align: center;'>" +
            "                                        <p style='margin: 0 0 8px 0; color: #94A3B8; font-size: 11px; font-weight: 500;'>发送时间：" + currentTime + "</p>" +
            "                                        <p style='margin: 0; color: #CBD5E1; font-size: 10px; font-weight: 500; letter-spacing: 0.5px;'>© 2026 KONUS AI · 开启您的智能管理之旅</p>" +
            "                                    </td>" +
            "                                </tr>" +
            "                            </table>" +
            "                        </td>" +
            "                    </tr>" +
            "                </table>" +
            "            </td>" +
            "        </tr>" +
            "    </table>" +
            "</body>" +
            "</html>";
    }
}
