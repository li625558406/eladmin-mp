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
import me.zhengjie.modules.system.service.EmailVerifyCodeService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 邮箱验证码Controller
 * @author KONUS AI
 * @date 2026-02-02
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/email-code")
@Api(tags = "系统：邮箱验证码接口")
public class EmailVerifyCodeController {

    private final EmailVerifyCodeService emailVerifyCodeService;

    @ApiOperation("发送验证码")
    @AnonymousPostMapping("/send")
    public ResponseEntity<Object> sendVerifyCode(@RequestParam String email, @RequestParam String type) {
        boolean success = emailVerifyCodeService.sendVerifyCode(email, type);
        
        Map<String, Object> result = new HashMap<>(2);
        result.put("success", success);
        result.put("message", success ? "验证码发送成功，请查收邮件" : "验证码发送失败");
        
        return ResponseEntity.ok(result);
    }

    @ApiOperation("验证验证码")
    @AnonymousPostMapping("/verify")
    public ResponseEntity<Object> verifyCode(@RequestParam String email, 
                                            @RequestParam String code, 
                                            @RequestParam String type) {
        boolean valid = emailVerifyCodeService.verifyCode(email, code, type);
        
        Map<String, Object> result = new HashMap<>(2);
        result.put("valid", valid);
        result.put("message", valid ? "验证码正确" : "验证码错误或已过期");
        
        return ResponseEntity.ok(result);
    }
}
