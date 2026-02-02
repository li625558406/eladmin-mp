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
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
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
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(from);
            message.setTo(email);
            
            String typeText = getTypeText(type);
            message.setSubject("KONUS AI - " + typeText + "验证码");
            
            String content = String.format(
                "您好！\n\n" +
                "您正在进行%s操作，验证码为：%s\n\n" +
                "验证码有效期为%d分钟，请尽快使用。\n\n" +
                "如非本人操作，请忽略此邮件。\n\n" +
                "KONUS AI\n" +
                "%s",
                typeText, code, expiration / 60, new Date()
            );
            
            message.setText(content);
            mailSender.send(message);
            
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
}
