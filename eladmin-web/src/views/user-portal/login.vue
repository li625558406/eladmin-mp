<template>
  <div class="auth-container">
    <!-- 装饰性背景元素 -->
    <div class="bg-decoration">
      <div class="shape shape-1" />
      <div class="shape shape-2" />
      <div class="shape shape-3" />
      <div class="grain-overlay" />
    </div>

    <!-- 主内容区 -->
    <div class="auth-content">
      <!-- 左侧品牌区 -->
      <div class="brand-section">
        <div class="brand-content">
          <div class="logo-wrapper">
            <img src="@/assets/images/logo.png" alt="KONUS AI" class="brand-logo">
          </div>
          <h1 class="brand-title">KONUS AI</h1>
          <p class="brand-tagline">开启您的智能管理之旅</p>

          <!-- 装饰性引用 -->
          <div class="quote-section">
            <div class="quote-mark">"</div>
            <p class="quote-text">
              简单、高效、智能的企业级管理系统
            </p>
          </div>

          <!-- 特性标签 -->
          <div class="features-tags">
            <span class="tag">安全可靠</span>
            <span class="tag">快速响应</span>
            <span class="tag">易于使用</span>
          </div>
        </div>
      </div>

      <!-- 右侧表单区 -->
      <div class="form-section">
        <!-- 标签切换 - 固定在顶部 -->
        <div class="tab-switch">
          <button
            :class="['tab-btn', { active: isLogin }]"
            @click="switchToLogin"
          >
            <span>登录</span>
          </button>
          <button
            :class="['tab-btn', { active: !isLogin }]"
            @click="switchToRegister"
          >
            <span>注册</span>
          </button>
          <div class="tab-indicator" :style="indicatorStyle" />
        </div>

        <!-- 表单内容区域 - 可滚动 -->
        <div class="form-content-wrapper">
          <!-- 登录表单 -->
          <transition name="form-fade" mode="out-in">
            <div v-if="isLogin" key="login" class="form-container">
              <h2 class="form-title">欢迎回来</h2>
              <p class="form-subtitle">{{ isEmailLogin ? '使用邮箱验证码登录' : '登录您的账户继续使用' }}</p>

              <!-- 用户名密码登录 -->
              <el-form v-if="!isEmailLogin" ref="loginForm" :model="loginForm" :rules="loginRules" class="auth-form">
                <el-form-item prop="username">
                  <div class="input-wrapper">
                    <label class="input-label">用户名</label>
                    <el-input
                      v-model="loginForm.username"
                      placeholder="请输入用户名"
                      prefix-icon="el-icon-user"
                      autocomplete="off"
                      @keyup.enter.native="handleLogin"
                    />
                  </div>
                </el-form-item>

                <el-form-item prop="password">
                  <div class="input-wrapper">
                    <label class="input-label">密码</label>
                    <el-input
                      v-model="loginForm.password"
                      type="password"
                      placeholder="请输入密码"
                      prefix-icon="el-icon-lock"
                      show-password
                      autocomplete="off"
                      @keyup.enter.native="handleLogin"
                    />
                  </div>
                </el-form-item>

                <div class="form-options">
                  <el-checkbox v-model="loginForm.rememberMe">记住我</el-checkbox>
                  <a href="javascript:;" class="forgot-link">忘记密码？</a>
                </div>

                <el-button
                  :loading="loading"
                  type="primary"
                  class="submit-btn login-btn"
                  @click="handleLogin"
                >
                  <span v-if="!loading" class="btn-text">登录</span>
                  <span v-else class="btn-text">登录中...</span>
                </el-button>

                <div class="login-switch">
                  <a href="javascript:;" class="switch-link" @click="toggleLoginType">
                    <i class="el-icon-message" /> 使用邮箱验证码登录
                  </a>
                </div>
              </el-form>

              <!-- 邮箱验证码登录 -->
              <el-form v-else ref="emailLoginForm" :model="emailLoginForm" :rules="emailLoginRules" class="auth-form">
                <el-form-item prop="email">
                  <div class="input-wrapper">
                    <label class="input-label">邮箱</label>
                    <el-input
                      v-model="emailLoginForm.email"
                      placeholder="请输入邮箱地址"
                      prefix-icon="el-icon-message"
                      autocomplete="off"
                    />
                  </div>
                </el-form-item>

                <el-form-item prop="code">
                  <div class="input-wrapper">
                    <label class="input-label">验证码</label>
                    <div class="code-input-wrapper">
                      <el-input
                        v-model="emailLoginForm.code"
                        placeholder="请输入邮箱验证码"
                        prefix-icon="el-icon-key"
                        maxlength="6"
                        @keyup.enter.native="handleEmailLogin"
                      />
                      <el-button
                        :disabled="loginCodeSending || loginCodeCountdown > 0"
                        class="code-btn"
                        @click="sendLoginCode"
                      >
                        {{ loginCodeBtnText }}
                      </el-button>
                    </div>
                  </div>
                </el-form-item>

                <div class="form-options">
                  <el-checkbox v-model="emailLoginForm.rememberMe">记住我</el-checkbox>
                  <a href="javascript:;" class="forgot-link">忘记密码？</a>
                </div>

                <el-button
                  :loading="loading"
                  type="primary"
                  class="submit-btn login-btn"
                  @click="handleEmailLogin"
                >
                  <span v-if="!loading" class="btn-text">登录</span>
                  <span v-else class="btn-text">登录中...</span>
                </el-button>

                <div class="login-switch">
                  <a href="javascript:;" class="switch-link" @click="toggleLoginType">
                    <i class="el-icon-user" /> 使用用户名密码登录
                  </a>
                </div>
              </el-form>
            </div>

            <!-- 注册表单 -->
            <div v-else key="register" class="form-container">
              <h2 class="form-title">创建账户</h2>
              <p class="form-subtitle">加入我们，开始您的旅程</p>

              <el-form ref="registerForm" :model="registerForm" :rules="registerRules" class="auth-form">
                <el-form-item prop="username">
                  <div class="input-wrapper">
                    <label class="input-label">用户名</label>
                    <el-input
                      v-model="registerForm.username"
                      placeholder="请输入用户名"
                      prefix-icon="el-icon-user"
                      autocomplete="new-username"
                    />
                  </div>
                </el-form-item>

                <el-form-item prop="email">
                  <div class="input-wrapper">
                    <label class="input-label">邮箱</label>
                    <el-input
                      v-model="registerForm.email"
                      placeholder="请输入邮箱地址"
                      prefix-icon="el-icon-message"
                      autocomplete="new-email"
                    />
                  </div>
                </el-form-item>

                <el-form-item prop="code">
                  <div class="input-wrapper">
                    <label class="input-label">验证码</label>
                    <div class="code-input-wrapper">
                      <el-input
                        v-model="registerForm.code"
                        placeholder="请输入邮箱验证码"
                        prefix-icon="el-icon-key"
                        maxlength="6"
                      />
                      <el-button
                        :disabled="registerCodeSending || registerCodeCountdown > 0"
                        class="code-btn"
                        @click="sendRegisterCode"
                      >
                        {{ registerCodeBtnText }}
                      </el-button>
                    </div>
                  </div>
                </el-form-item>

                <el-form-item prop="password">
                  <div class="input-wrapper">
                    <label class="input-label">密码</label>
                    <el-input
                      v-model="registerForm.password"
                      type="password"
                      placeholder="请输入密码（至少6位）"
                      prefix-icon="el-icon-lock"
                      show-password
                      autocomplete="new-password"
                    />
                  </div>
                </el-form-item>

                <el-form-item prop="confirmPassword">
                  <div class="input-wrapper">
                    <label class="input-label">确认密码</label>
                    <el-input
                      v-model="registerForm.confirmPassword"
                      type="password"
                      placeholder="请再次输入密码"
                      prefix-icon="el-icon-lock"
                      show-password
                      autocomplete="new-password"
                      @keyup.enter.native="handleRegister"
                    />
                  </div>
                </el-form-item>

                <div class="form-options">
                  <el-checkbox v-model="registerForm.agreeTerms">
                    我同意<a href="javascript:;" class="link-text">服务条款</a>和<a href="javascript:;" class="link-text">隐私政策</a>
                  </el-checkbox>
                </div>

                <el-button
                  :loading="loading"
                  type="primary"
                  class="submit-btn register-btn"
                  @click="handleRegister"
                >
                  <span v-if="!loading" class="btn-text">注册</span>
                  <span v-else class="btn-text">注册中...</span>
                </el-button>
              </el-form>
            </div>
          </transition>
        </div>
      </div>
    </div>

    <!-- 底部版权信息 -->
    <div class="footer-info">
      <p>© 2026 KONUS AI. All rights reserved.</p>
    </div>
  </div>
</template>

<script>
import { sendEmailCode } from '@/api/emailVerifyCode'
import { register } from '@/api/userRegister'
import { encrypt } from '@/utils/rsaEncrypt'

export default {
  name: 'UserLogin',
  data() {
    // 验证确认密码
    const validateConfirmPassword = (rule, value, callback) => {
      if (value === '') {
        callback(new Error('请再次输入密码'))
      } else if (value !== this.registerForm.password) {
        callback(new Error('两次输入密码不一致'))
      } else {
        callback()
      }
    }

    return {
      isLogin: true,
      isEmailLogin: false,
      loading: false,
      loginForm: {
        username: '',
        password: '',
        rememberMe: false
      },
      emailLoginForm: {
        email: '',
        code: '',
        rememberMe: false
      },
      loginCodeSending: false,
      loginCodeCountdown: 0,
      loginCodeTimer: null,
      registerForm: {
        username: '',
        email: '',
        code: '',
        password: '',
        confirmPassword: '',
        agreeTerms: false
      },
      registerCodeSending: false,
      registerCodeCountdown: 0,
      registerCodeTimer: null,
      loginRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 20, message: '用户名长度为 3 到 20 个字符', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能少于 6 个字符', trigger: 'blur' }
        ]
      },
      emailLoginRules: {
        email: [
          { required: true, message: '请输入邮箱地址', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
        ],
        code: [
          { required: true, message: '请输入邮箱验证码', trigger: 'blur' },
          { len: 6, message: '验证码为6位数字', trigger: 'blur' }
        ]
      },
      registerRules: {
        username: [
          { required: true, message: '请输入用户名', trigger: 'blur' },
          { min: 3, max: 20, message: '用户名长度为 3 到 20 个字符', trigger: 'blur' }
        ],
        email: [
          { required: true, message: '请输入邮箱地址', trigger: 'blur' },
          { type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }
        ],
        code: [
          { required: true, message: '请输入邮箱验证码', trigger: 'blur' },
          { len: 6, message: '验证码为6位数字', trigger: 'blur' }
        ],
        password: [
          { required: true, message: '请输入密码', trigger: 'blur' },
          { min: 6, message: '密码长度不能少于 6 个字符', trigger: 'blur' }
        ],
        confirmPassword: [
          { required: true, validator: validateConfirmPassword, trigger: 'blur' }
        ]
      }
    }
  },
  computed: {
    indicatorStyle() {
      return {
        transform: this.isLogin ? 'translateX(0)' : 'translateX(100%)'
      }
    },
    registerCodeBtnText() {
      if (this.registerCodeCountdown > 0) {
        return `${this.registerCodeCountdown}秒后重试`
      }
      return this.registerCodeSending ? '发送中...' : '获取验证码'
    },
    loginCodeBtnText() {
      if (this.loginCodeCountdown > 0) {
        return `${this.loginCodeCountdown}秒后重试`
      }
      return this.loginCodeSending ? '发送中...' : '获取验证码'
    }
  },
  beforeDestroy() {
    // 清理定时器
    if (this.registerCodeTimer) {
      clearInterval(this.registerCodeTimer)
    }
    if (this.loginCodeTimer) {
      clearInterval(this.loginCodeTimer)
    }
  },
  methods: {
    switchToLogin() {
      this.isLogin = true
      this.isEmailLogin = false
      this.$refs.registerForm && this.$refs.registerForm.clearValidate()
    },
    switchToRegister() {
      this.isLogin = false
      this.$refs.loginForm && this.$refs.loginForm.clearValidate()
      this.$refs.emailLoginForm && this.$refs.emailLoginForm.clearValidate()
    },
    toggleLoginType() {
      this.isEmailLogin = !this.isEmailLogin
      this.$refs.loginForm && this.$refs.loginForm.clearValidate()
      this.$refs.emailLoginForm && this.$refs.emailLoginForm.clearValidate()
    },
    handleLogin() {
      this.$refs.loginForm.validate(valid => {
        if (valid) {
          this.loading = true
          const user = {
            username: this.loginForm.username,
            password: encrypt(this.loginForm.password),
            rememberMe: this.loginForm.rememberMe,
            loginType: 'user'
          }
          this.$store.dispatch('Login', user).then(() => {
            this.loading = false
            this.$message.success('登录成功！')
            // 跳转到用户首页
            this.$router.push('/user/home')
          }).catch(err => {
            this.loading = false
            this.$message.error(err.message || '登录失败')
          })
        }
      })
    },
    handleEmailLogin() {
      this.$refs.emailLoginForm.validate(valid => {
        if (valid) {
          this.loading = true
          this.$store.dispatch('EmailLogin', {
            email: this.emailLoginForm.email,
            code: this.emailLoginForm.code,
            rememberMe: this.emailLoginForm.rememberMe
          }).then(() => {
            this.loading = false
            this.$message.success('登录成功！')
            // 跳转到用户首页
            this.$router.push('/user/home')
          }).catch(err => {
            this.loading = false
            this.$message.error(err.message || '登录失败')
          })
        }
      })
    },
    sendLoginCode() {
      // 先验证邮箱字段
      this.$refs.emailLoginForm.validateField('email', (errorMessage) => {
        if (errorMessage) {
          return
        }

        this.loginCodeSending = true
        sendEmailCode(this.emailLoginForm.email, 'login').then(res => {
          this.loginCodeSending = false
          if (res.success) {
            this.$message.success(res.message || '验证码已发送，请查收邮件')
            // 开始倒计时
            this.loginCodeCountdown = 60
            this.loginCodeTimer = setInterval(() => {
              this.loginCodeCountdown--
              if (this.loginCodeCountdown <= 0) {
                clearInterval(this.loginCodeTimer)
                this.loginCodeTimer = null
              }
            }, 1000)
          } else {
            this.$message.error(res.message || '验证码发送失败')
          }
        }).catch(err => {
          this.loginCodeSending = false
          this.$message.error(err.message || '验证码发送失败')
        })
      })
    },
    sendRegisterCode() {
      // 先验证邮箱字段
      this.$refs.registerForm.validateField('email', (errorMessage) => {
        if (errorMessage) {
          return
        }

        this.registerCodeSending = true
        sendEmailCode(this.registerForm.email, 'register').then(res => {
          this.registerCodeSending = false
          if (res.success) {
            this.$message.success(res.message || '验证码已发送，请查收邮件')
            // 开始倒计时
            this.registerCodeCountdown = 60
            this.registerCodeTimer = setInterval(() => {
              this.registerCodeCountdown--
              if (this.registerCodeCountdown <= 0) {
                clearInterval(this.registerCodeTimer)
                this.registerCodeTimer = null
              }
            }, 1000)
          } else {
            this.$message.error(res.message || '验证码发送失败')
          }
        }).catch(err => {
          this.registerCodeSending = false
          this.$message.error(err.message || '验证码发送失败')
        })
      })
    },
    handleRegister() {
      this.$refs.registerForm.validate(valid => {
        if (valid) {
          if (!this.registerForm.agreeTerms) {
            this.$message.warning('请先同意服务条款和隐私政策')
            return
          }
          this.loading = true
          register({
            username: this.registerForm.username,
            email: this.registerForm.email,
            password: this.registerForm.password,
            confirmPassword: this.registerForm.confirmPassword,
            code: this.registerForm.code
          }).then(res => {
            this.loading = false
            this.$message.success(res.message || '注册成功！')
            // 注册成功后切换到登录表单
            this.switchToLogin()
            // 填充注册的用户名
            this.loginForm.username = this.registerForm.username
            // 重置注册表单
            this.$refs.registerForm.resetFields()
          }).catch(err => {
            this.loading = false
            this.$message.error(err.message || '注册失败')
          })
        }
      })
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
// 导入独特字体（通过 Google Fonts）
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap');

// CSS 变量定义
:root {
  --primary-color: #46A6FF;
  --primary-dark: #2C86D6;
  --primary-light: #7BC1FF;
  --secondary-color: #FF6B9D;
  --accent-color: #FFB800;
  --success-color: #00D084;
  --bg-primary: #0A0E27;
  --bg-secondary: #151B3B;
  --text-primary: #FFFFFF;
  --text-secondary: #94A3B8;
  --text-muted: #64748B;
  --border-color: rgba(255, 255, 255, 0.08);
  --glass-bg: rgba(255, 255, 255, 0.03);
  --glass-border: rgba(255, 255, 255, 0.12);
  --shimmer-color: rgba(255, 255, 255, 0.1);
}

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.auth-container {
  position: relative;
  min-height: 100vh;
  display: flex;
  align-items: center;
  justify-content: center;
  background: var(--bg-primary);
  font-family: 'Outfit', sans-serif;
  overflow: hidden;
}

// 背景装饰
.bg-decoration {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  overflow: hidden;
  z-index: 0;

  .shape {
    position: absolute;
    border-radius: 50%;
    filter: blur(80px);
    animation: float 20s infinite ease-in-out;

    &.shape-1 {
      width: 500px;
      height: 500px;
      background: radial-gradient(circle, rgba(45, 91, 255, 0.3) 0%, transparent 70%);
      top: -10%;
      left: -5%;
      animation-delay: 0s;
    }

    &.shape-2 {
      width: 400px;
      height: 400px;
      background: radial-gradient(circle, rgba(255, 107, 157, 0.25) 0%, transparent 70%);
      bottom: -5%;
      right: 10%;
      animation-delay: 5s;
    }

    &.shape-3 {
      width: 300px;
      height: 300px;
      background: radial-gradient(circle, rgba(255, 184, 0, 0.2) 0%, transparent 70%);
      top: 40%;
      right: -5%;
      animation-delay: 10s;
    }
  }

  .grain-overlay {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 400 400' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noiseFilter'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.9' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noiseFilter)'/%3E%3C/svg%3E");
    opacity: 0.03;
    mix-blend-mode: overlay;
  }
}

@keyframes float {
  0%, 100% { transform: translate(0, 0) scale(1); }
  33% { transform: translate(30px, -30px) scale(1.1); }
  66% { transform: translate(-20px, 20px) scale(0.9); }
}

// 主内容区
.auth-content {
  position: relative;
  z-index: 1;
  display: flex;
  width: 90%;
  max-width: 1300px;
  height: 85vh;
  max-height: 750px;
  min-height: 600px;
  background: var(--glass-bg);
  backdrop-filter: blur(30px) saturate(180%);
  border: 1px solid var(--glass-border);
  border-radius: 24px;
  overflow: hidden;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5),
              0 0 100px rgba(45, 91, 255, 0.15),
              0 0 1px rgba(255, 255, 255, 0.2),
              inset 0 1px 0 rgba(255, 255, 255, 0.15);
  animation: slideUp 0.6s ease-out;

  // 添加微光效果
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(
      90deg,
      transparent,
      rgba(255, 255, 255, 0.03),
      transparent
    );
    animation: shimmer 10s infinite;
    z-index: 1;
    pointer-events: none;
  }
}

@keyframes shimmer {
  0% { left: -100%; }
  50%, 100% { left: 200%; }
}

@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

// 左侧品牌区
.brand-section {
  flex: 1;
  padding: 60px;
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
  display: flex;
  flex-direction: column;
  justify-content: center;
  position: relative;
  overflow: hidden;

  // 顶部高光
  &::before {
    content: '';
    position: absolute;
    top: -50%;
    right: -50%;
    width: 100%;
    height: 100%;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.15) 0%, transparent 70%);
    animation: pulse 8s infinite ease-in-out;
  }

  // 底部渐变
  &::after {
    content: '';
    position: absolute;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 30%;
    background: linear-gradient(to top, rgba(0, 0, 0, 0.2), transparent);
    pointer-events: none;
  }
}

@keyframes pulse {
  0%, 100% { transform: scale(1); opacity: 0.3; }
  50% { transform: scale(1.2); opacity: 0.5; }
}

.brand-content {
  position: relative;
  z-index: 1;
  animation: fadeInLeft 0.8s ease-out 0.2s both;
}

@keyframes fadeInLeft {
  from {
    opacity: 0;
    transform: translateX(-20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.logo-wrapper {
  margin-bottom: 30px;
  animation: logoFloat 3s infinite ease-in-out;
}

@keyframes logoFloat {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

.brand-logo {
  width: 80px;
  height: 80px;
  filter: brightness(0) invert(1);
}

.brand-title {
  font-size: 48px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 15px;
  letter-spacing: -1px;
}

.brand-tagline {
  font-size: 18px;
  color: rgba(255, 255, 255, 0.8);
  margin-bottom: 50px;
  font-weight: 300;
}

.quote-section {
  margin-bottom: 40px;
  padding-left: 20px;
  border-left: 3px solid rgba(255, 255, 255, 0.3);
}

.quote-mark {
  font-size: 60px;
  font-family: 'Georgia', serif;
  color: rgba(255, 255, 255, 0.2);
  line-height: 0.5;
  margin-bottom: 10px;
}

.quote-text {
  font-size: 16px;
  line-height: 1.6;
  color: rgba(255, 255, 255, 0.9);
  font-style: italic;
}

.features-tags {
  display: flex;
  gap: 10px;
  flex-wrap: wrap;
}

.tag {
  display: inline-block;
  padding: 8px 16px;
  background: rgba(255, 255, 255, 0.12);
  border: 1px solid rgba(255, 255, 255, 0.25);
  border-radius: 20px;
  color: var(--text-primary);
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.5px;
  backdrop-filter: blur(10px);
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: linear-gradient(135deg, transparent, rgba(255, 255, 255, 0.1), transparent);
    transform: translateX(-100%);
    transition: transform 0.6s ease;
  }

  &:hover {
    background: rgba(255, 255, 255, 0.2);
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);

    &::before {
      transform: translateX(100%);
    }
  }
}

// 右侧表单区
.form-section {
  flex: 1;
  padding: 40px;
  display: flex;
  flex-direction: column;
  background: var(--bg-secondary);
  overflow: hidden;
  position: relative;

  // 添加细微的网格背景
  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-image:
      linear-gradient(rgba(255, 255, 255, 0.02) 1px, transparent 1px),
      linear-gradient(90deg, rgba(255, 255, 255, 0.02) 1px, transparent 1px);
    background-size: 30px 30px;
    opacity: 0.5;
    pointer-events: none;
  }
}

// 表单内容包装器 - 可滚动区域
.form-content-wrapper {
  flex: 1;
  overflow-y: auto;
  overflow-x: hidden;
  padding: 0 4px;
  margin: 0 -4px;
  animation: fadeInRight 0.8s ease-out 0.3s both;
  display: flex;
  flex-direction: column;
  justify-content: center;

  // 自定义滚动条
  &::-webkit-scrollbar {
    width: 6px;
  }

  &::-webkit-scrollbar-track {
    background: transparent;
  }

  &::-webkit-scrollbar-thumb {
    background: rgba(255, 255, 255, 0.15);
    border-radius: 3px;
    transition: background 0.3s ease;

    &:hover {
      background: rgba(255, 255, 255, 0.25);
    }
  }
}

@keyframes fadeInRight {
  from {
    opacity: 0;
    transform: translateX(20px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

// 标签切换 - 固定在顶部
.tab-switch {
  position: relative;
  display: flex;
  background: var(--glass-bg);
  border: 1px solid var(--border-color);
  border-radius: 14px;
  padding: 6px;
  flex-shrink: 0;
  box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.2);
  max-width: 480px;
  margin-left: auto;
  margin-right: auto;
  width: 100%;
}

.tab-btn {
  flex: 1;
  padding: 12px 24px;
  background: transparent;
  border: none;
  color: var(--text-secondary);
  font-size: 15px;
  font-weight: 500;
  cursor: pointer;
  border-radius: 8px;
  transition: color 0.3s ease;
  position: relative;
  z-index: 2;
  font-family: 'Outfit', sans-serif;

  &.active {
    color: var(--text-primary);
  }

  &:hover {
    color: var(--text-primary);
  }
}

.tab-indicator {
  position: absolute;
  top: 6px;
  left: 6px;
  width: calc(50% - 6px);
  height: calc(100% - 12px);
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-light) 100%);
  border-radius: 10px;
  transition: transform 0.5s cubic-bezier(0.34, 1.56, 0.64, 1);
  z-index: 1;
  box-shadow: 0 4px 12px rgba(45, 91, 255, 0.3),
              inset 0 1px 0 rgba(255, 255, 255, 0.2);
}

// 表单容器
.form-container {
  animation: formSlide 0.4s ease-out;
  max-width: 480px;
  margin: auto;
  width: 100%;
  padding: 20px 0;
}

@keyframes formSlide {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.form-title {
  font-size: 28px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 6px;
  letter-spacing: -0.5px;
}

.form-subtitle {
  font-size: 14px;
  color: var(--text-secondary);
  margin-bottom: 24px;
  font-weight: 300;
}

// 表单样式
.auth-form {
  .el-form-item {
    margin-bottom: 20px;
  }

  // 移除 Element UI 默认的错误提示样式优化
  .el-form-item__error {
    color: #ff6b9d;
    font-size: 12px;
    line-height: 1;
    padding-top: 4px;
    margin-left: 97px; // 对齐输入框左边缘 (85px label + 12px gap)
  }
}

.input-wrapper {
  display: flex;
  align-items: center;
  gap: 12px;
  width: 100%;

  .input-label {
    flex-shrink: 0;
    width: 85px;
    font-size: 12px;
    font-weight: 600;
    color: var(--text-secondary);
    letter-spacing: 0.3px;
    margin-bottom: 0;
  }

  ::v-deep .el-input {
    flex: 1;
    width: 100%;
    min-width: 0;
  }
}

// 验证码输入框样式
.code-input-wrapper {
  flex: 1;
  display: flex;
  gap: 10px;
  align-items: center;

  ::v-deep .el-input {
    flex: 1;
    width: 100%;
    min-width: 0;
  }

  .code-btn {
    flex-shrink: 0;
    height: 44px;
    padding: 0 16px;
    border-radius: 11px;
    font-size: 13px;
    font-weight: 500;
    background: rgba(255, 255, 255, 0.08);
    border: 1.5px solid var(--border-color);
    color: var(--text-primary);
    transition: all 0.3s ease;
    white-space: nowrap;
    min-width: 100px;

    &:hover:not(:disabled) {
      background: rgba(255, 255, 255, 0.12);
      border-color: var(--primary-color);
      color: var(--primary-color);
      transform: translateY(-1px);
      box-shadow: 0 4px 12px rgba(45, 91, 255, 0.2);
    }

    &:disabled {
      opacity: 0.5;
      cursor: not-allowed;
    }
  }
}

// 登录方式切换
.login-switch {
  text-align: center;
  margin-top: 16px;

  .switch-link {
    color: var(--text-secondary);
    font-size: 13px;
    text-decoration: none;
    transition: all 0.3s ease;
    display: inline-flex;
    align-items: center;
    gap: 4px;

    i {
      font-size: 14px;
    }

    &:hover {
      color: var(--primary-color);
      text-decoration: underline;
    }
  }
}

// 重写 Element UI 样式
::v-deep .el-input {
  .el-input__inner {
    height: 44px;
    line-height: 44px;
    background: rgba(255, 255, 255, 0.05);
    border: 1.5px solid var(--border-color);
    border-radius: 11px;
    color: var(--text-primary);
    font-size: 14px;
    padding-left: 44px;
    padding-right: 16px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05);

    &:hover {
      background: rgba(255, 255, 255, 0.07);
      border-color: rgba(255, 255, 255, 0.18);
      box-shadow: inset 0 2px 4px rgba(0, 0, 0, 0.05),
                  0 0 0 1px rgba(255, 255, 255, 0.05);
    }

    &:focus {
      background: rgba(255, 255, 255, 0.09);
      border-color: var(--primary-color);
      box-shadow: 0 0 0 3px rgba(45, 91, 255, 0.12),
                  inset 0 2px 4px rgba(0, 0, 0, 0.05);
    }

    &::placeholder {
      color: var(--text-muted);
      opacity: 0.6;
    }

    // 防止浏览器自动填充样式
    &:-webkit-autofill,
    &:-webkit-autofill:hover,
    &:-webkit-autofill:focus,
    &:-webkit-autofill:active {
      -webkit-text-fill-color: var(--text-primary) !important;
      box-shadow: 0 0 0 1000px rgba(255, 255, 255, 0.05) inset !important;
      -webkit-box-shadow: 0 0 0 1000px rgba(255, 255, 255, 0.05) inset !important;
      transition: background-color 5000s ease-in-out 0s;
    }
  }

  .el-input__prefix {
    left: 14px;
    color: var(--text-muted);
    font-size: 17px;
    transition: all 0.3s ease;
  }

  .el-input__suffix {
    right: 14px;
  }

  // 当输入框聚焦时，图标颜色变化
  &.el-input--prefix {
    &:focus-within {
      .el-input__prefix {
        color: var(--primary-color);
        transform: scale(1.05);
      }
    }
  }
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  margin-top: 2px;

  ::v-deep .el-checkbox {
    .el-checkbox__label {
      color: var(--text-secondary);
      font-size: 13px;
      font-weight: 500;
      user-select: none;
    }

    .el-checkbox__inner {
      width: 18px;
      height: 18px;
      background: rgba(255, 255, 255, 0.05);
      border: 1.5px solid var(--border-color);
      border-radius: 5px;
      box-shadow: inset 0 1px 3px rgba(0, 0, 0, 0.1);
      transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    }

    &:hover {
      .el-checkbox__inner {
        border-color: var(--primary-color);
        background: rgba(45, 91, 255, 0.08);
      }
    }

    &.is-checked {
      .el-checkbox__inner {
        background: var(--primary-color);
        border-color: var(--primary-color);
        box-shadow: 0 2px 10px rgba(45, 91, 255, 0.35),
                    inset 0 1px 0 rgba(255, 255, 255, 0.25);

        &::after {
          border-color: #FFFFFF;
          border-width: 2px;
        }
      }

      .el-checkbox__label {
        color: var(--text-primary);
      }
    }
  }
}

.forgot-link,
.link-text {
  color: var(--primary-color);
  font-size: 13px;
  font-weight: 500;
  text-decoration: none;
  transition: all 0.3s ease;
  white-space: nowrap;
  position: relative;

  &::after {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 0;
    width: 0;
    height: 1px;
    background: var(--primary-color);
    transition: width 0.3s ease;
  }

  &:hover {
    color: var(--primary-light);

    &::after {
      width: 100%;
    }
  }
}

.submit-btn {
  width: 100%;
  height: 52px;
  font-size: 16px;
  font-weight: 700;
  background: linear-gradient(135deg, #46A6FF 0%, #7BC1FF 100%) !important;
  border: none !important;
  border-radius: 12px;
  transition: all 0.4s cubic-bezier(0.25, 0.8, 0.25, 1);
  position: relative;
  overflow: hidden;
  font-family: 'Outfit', sans-serif;
  margin-top: 6px;
  box-shadow: 0 4px 20px rgba(70, 166, 255, 0.35),
              inset 0 1px 0 rgba(255, 255, 255, 0.25);

  // 强制按钮文字颜色
  .btn-text {
    position: relative;
    z-index: 3;
    color: #FFFFFF !important;
    text-shadow: 0 1px 3px rgba(0, 0, 0, 0.2);
    font-weight: 700;
    display: inline-block;
  }

  // Element UI loading 图标也设为白色
  ::v-deep .el-icon-loading {
    color: #FFFFFF !important;
  }

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.25), transparent);
    transition: left 0.6s ease;
    z-index: 1;
  }

  &:hover {
    transform: translateY(-1px);
    background: linear-gradient(135deg, #7BC1FF 0%, #46A6FF 100%) !important;
    box-shadow: 0 8px 25px rgba(70, 166, 255, 0.45),
                0 4px 12px rgba(70, 166, 255, 0.3),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);

    &::before {
      left: 100%;
    }
  }

  &:active {
    transform: translateY(0);
    transition: all 0.1s ease;
    box-shadow: 0 4px 15px rgba(70, 166, 255, 0.45),
                inset 0 1px 3px rgba(0, 0, 0, 0.2);
  }

  &:focus {
    outline: none;
    transform: translateY(-1px);
    box-shadow: 0 8px 25px rgba(70, 166, 255, 0.45),
                0 4px 12px rgba(70, 166, 255, 0.3),
                inset 0 1px 0 rgba(255, 255, 255, 0.3);
  }
}

// 底部版权
.footer-info {
  position: absolute;
  bottom: 20px;
  left: 50%;
  transform: translateX(-50%);
  color: var(--text-muted);
  font-size: 13px;
  z-index: 1;
  animation: fadeIn 1s ease-out 0.5s both;
}

@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

// 过渡动画 - 减慢速度
.form-fade-enter-active {
  transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.form-fade-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.6, 1);
}

.form-fade-enter {
  opacity: 0;
  transform: translateX(30px);
}

.form-fade-leave-to {
  opacity: 0;
  transform: translateX(-30px);
}

// 响应式设计
@media (max-width: 1024px) {
  .auth-content {
    flex-direction: column;
    width: 95%;
    height: auto;
    max-height: 90vh;
  }

  .brand-section {
    padding: 40px;
    min-height: 250px;
    flex-shrink: 0;
  }

  .form-section {
    padding: 30px 40px 40px;
    flex: 1;
    min-height: 0;
  }
}

@media (max-width: 768px) {
  .auth-content {
    width: 100%;
    border-radius: 0;
    height: 100vh;
    max-height: 100vh;
  }

  .brand-section {
    padding: 30px;
    min-height: 200px;

    .brand-title {
      font-size: 36px;
    }

    .quote-section {
      display: none;
    }
  }

  .form-section {
    padding: 25px 20px 30px;
  }

  .form-title {
    font-size: 26px;
  }

  .form-wrapper {
    max-width: 100%;
  }
}
</style>
