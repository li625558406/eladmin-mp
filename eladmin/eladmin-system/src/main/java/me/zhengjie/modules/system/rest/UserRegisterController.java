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
package me.zhengjie.modules.system.rest;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.RequiredArgsConstructor;
import me.zhengjie.annotation.rest.AnonymousPostMapping;
import me.zhengjie.config.properties.RsaProperties;
import me.zhengjie.exception.BadRequestException;
import me.zhengjie.modules.system.domain.User;
import me.zhengjie.modules.system.domain.dto.UserRegisterDto;
import me.zhengjie.modules.system.service.EmailVerifyCodeService;
import me.zhengjie.modules.system.service.UserService;
import me.zhengjie.utils.RsaUtils;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 用户注册Controller
 * @author KONUS AI
 * @date 2026-02-02
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/users")
@Api(tags = "系统：用户注册接口")
public class UserRegisterController {

    private final UserService userService;
    private final EmailVerifyCodeService emailVerifyCodeService;
    private final PasswordEncoder passwordEncoder;

    @ApiOperation("用户注册")
    @AnonymousPostMapping("/register")
    public ResponseEntity<Object> register(@Validated @RequestBody UserRegisterDto registerDto) throws Exception {
        // 验证邮箱验证码
        boolean codeValid = emailVerifyCodeService.verifyCode(
            registerDto.getEmail(), 
            registerDto.getCode(), 
            "register"
        );
        
        if (!codeValid) {
            throw new BadRequestException("验证码错误或已过期");
        }

        // 密码解密
        String password = RsaUtils.decryptByPrivateKey(RsaProperties.privateKey, registerDto.getPassword());
        String confirmPassword = RsaUtils.decryptByPrivateKey(RsaProperties.privateKey, registerDto.getConfirmPassword());
        if (!password.equals(confirmPassword)) {
            throw new BadRequestException("两次密码输入不一致");
        }
        
        // 密码长度验证
        if (password.length() < 6) {
            throw new BadRequestException("密码长度不能少于6位");
        }

        // 密码加密
        String encryptPassword = passwordEncoder.encode(password);

        // 注册用户
        User user = userService.register(
            registerDto.getUsername(),
            registerDto.getEmail(),
            encryptPassword,
            registerDto.getAvatarPath()
        );

        Map<String, Object> result = new HashMap<>(3);
        result.put("success", true);
        result.put("message", "注册成功");
        result.put("username", user.getUsername());

        return new ResponseEntity<>(result, HttpStatus.OK);
    }
}
