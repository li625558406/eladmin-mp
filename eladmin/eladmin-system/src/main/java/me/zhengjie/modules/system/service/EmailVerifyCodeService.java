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
package me.zhengjie.modules.system.service;

import com.baomidou.mybatisplus.extension.service.IService;
import me.zhengjie.modules.system.domain.EmailVerifyCode;

/**
 * 邮箱验证码Service
 * @author KONUS AI
 * @date 2026-02-02
 */
public interface EmailVerifyCodeService extends IService<EmailVerifyCode> {

    /**
     * 发送验证码
     * @param email 邮箱地址
     * @param type 验证码类型
     * @return 是否发送成功
     */
    boolean sendVerifyCode(String email, String type);

    /**
     * 验证验证码
     * @param email 邮箱地址
     * @param code 验证码
     * @param type 验证码类型
     * @return 是否验证成功
     */
    boolean verifyCode(String email, String code, String type);

    /**
     * 清理过期验证码
     */
    void cleanExpiredCodes();
}
