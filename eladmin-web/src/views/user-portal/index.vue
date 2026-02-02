<template>
  <div class="user-portal-container">
    <div class="user-portal-content">
      <div class="logo-section">
        <img src="@/assets/images/logo.png" alt="KONUS AI" class="logo">
        <h1 class="title">KONUS AI</h1>
        <p class="subtitle">欢迎使用 KONUS AI 系统</p>
      </div>

      <div class="content-section">
        <h2>用户端功能开发中...</h2>
        <p class="description">
          这是用户端的首页，您可以在此基础上开发用户端的登录、注册、首页等功能。
        </p>

        <div class="features">
          <div class="feature-card">
            <i class="el-icon-user" />
            <h3>用户登录</h3>
            <p>待开发</p>
          </div>
          <div class="feature-card">
            <i class="el-icon-s-home" />
            <h3>用户首页</h3>
            <p>待开发</p>
          </div>
          <div class="feature-card">
            <i class="el-icon-s-custom" />
            <h3>个人信息</h3>
            <p>待开发</p>
          </div>
        </div>
      </div>

      <!-- 底部 -->
      <div v-if="$store.state.settings.showFooter" class="footer">
        <span v-html="$store.state.settings.footerTxt" />
        <span v-if="$store.state.settings.caseNumber"> ⋅ </span>
        <a v-if="$store.state.settings.caseNumber" href="https://beian.miit.gov.cn/#/Integrated/index" target="_blank">
          {{ $store.state.settings.caseNumber }}
        </a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: 'UserPortal',
  data() {
    return {
      // 数据
    }
  },
  created() {
    // 初始化
  },
  methods: {
    // 方法
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
.user-portal-container {
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}

.user-portal-content {
  background: #ffffff;
  border-radius: 20px;
  padding: 60px 80px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  max-width: 900px;
  text-align: center;
}

.logo-section {
  margin-bottom: 50px;

  .logo {
    width: 120px;
    height: 120px;
    margin-bottom: 20px;
  }

  .title {
    font-size: 48px;
    font-weight: bold;
    color: #333;
    margin: 0 0 10px 0;
  }

  .subtitle {
    font-size: 18px;
    color: #666;
    margin: 0;
  }
}

.content-section {
  h2 {
    font-size: 32px;
    color: #333;
    margin-bottom: 20px;
  }

  .description {
    font-size: 16px;
    color: #666;
    line-height: 1.8;
    margin-bottom: 40px;
  }
}

.features {
  display: flex;
  justify-content: space-around;
  gap: 30px;
  margin-bottom: 40px;
}

.feature-card {
  flex: 1;
  padding: 30px 20px;
  border-radius: 10px;
  background: #f8f9fa;
  transition: all 0.3s ease;

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
  }

  i {
    font-size: 48px;
    color: #667eea;
    margin-bottom: 15px;
  }

  h3 {
    font-size: 20px;
    color: #333;
    margin: 10px 0;
  }

  p {
    font-size: 14px;
    color: #999;
    margin: 0;
  }
}

.footer {
  margin-top: 40px;
  padding-top: 20px;
  border-top: 1px solid #eee;
  font-size: 14px;
  color: #999;

  a {
    color: #667eea;
    text-decoration: none;

    &:hover {
      text-decoration: underline;
    }
  }
}
</style>
