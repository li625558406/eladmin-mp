<template>
  <div class="user-home-container">
    <!-- 顶部导航栏 -->
    <header class="header">
      <div class="header-content">
        <div class="logo-section">
          <img src="@/assets/images/logo.png" alt="KONUS AI" class="logo">
          <span class="brand-name">KONUS AI</span>
        </div>

        <nav class="nav-menu">
          <a href="javascript:;" class="nav-item active">首页</a>
          <a href="javascript:;" class="nav-item">服务</a>
          <a href="javascript:;" class="nav-item">关于</a>
        </nav>

        <div class="user-actions">
          <el-dropdown trigger="click" @command="handleCommand">
            <div class="user-info">
              <img src="@/assets/images/avatar.png" alt="User" class="avatar">
              <span class="username">用户</span>
              <i class="el-icon-arrow-down" />
            </div>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="profile">个人资料</el-dropdown-item>
              <el-dropdown-item command="settings">设置</el-dropdown-item>
              <el-dropdown-item divided command="logout">退出登录</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </div>
    </header>

    <!-- 主内容区 -->
    <main class="main-content">
      <div class="content-wrapper">
        <!-- 欢迎区域 -->
        <div class="welcome-section">
          <div class="welcome-content">
            <h1 class="welcome-title">欢迎使用 KONUS AI</h1>
            <p class="welcome-subtitle">用户端功能开发中，敬请期待...</p>

            <!-- 装饰性元素 -->
            <div class="decoration-elements">
              <div class="circle circle-1" />
              <div class="circle circle-2" />
              <div class="circle circle-3" />
            </div>
          </div>
        </div>

        <!-- 功能卡片区域 -->
        <div class="features-grid">
          <div v-for="(feature, index) in features" :key="index" class="feature-card">
            <div class="card-icon">
              <i :class="feature.icon" />
            </div>
            <h3 class="card-title">{{ feature.title }}</h3>
            <p class="card-description">{{ feature.description }}</p>
            <div class="card-status">开发中</div>
          </div>
        </div>

        <!-- 占位内容 -->
        <div class="placeholder-section">
          <div class="placeholder-content">
            <i class="el-icon-s-promotion placeholder-icon" />
            <h2 class="placeholder-title">功能开发中</h2>
            <p class="placeholder-text">
              此页面为用户端首页预览，后续将添加更多功能模块。<br>
              如需访问管理后台，请联系系统管理员获取访问地址。
            </p>
          </div>
        </div>
      </div>
    </main>

    <!-- 底部信息 -->
    <footer class="footer">
      <div class="footer-content">
        <p>© 2026 KONUS AI. All rights reserved.</p>
      </div>
    </footer>
  </div>
</template>

<script>
export default {
  name: 'UserHome',
  data() {
    return {
      features: [
        {
          icon: 'el-icon-user',
          title: '个人中心',
          description: '管理您的个人信息和偏好设置'
        },
        {
          icon: 'el-icon-document',
          title: '我的文档',
          description: '查看和管理您的所有文档'
        },
        {
          icon: 'el-icon-message',
          title: '消息通知',
          description: '接收系统重要消息和通知'
        },
        {
          icon: 'el-icon-s-order',
          title: '我的订单',
          description: '查看订单状态和历史记录'
        },
        {
          icon: 'el-icon-star-off',
          title: '我的收藏',
          description: '管理您收藏的内容'
        },
        {
          icon: 'el-icon-setting',
          title: '系统设置',
          description: '个性化您的使用体验'
        }
      ]
    }
  },
  methods: {
    handleCommand(command) {
      if (command === 'logout') {
        this.$confirm('确定要退出登录吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }).then(() => {
          this.$message.success('已退出登录')
          this.$router.push('/user/login')
        })
      } else if (command === 'profile') {
        this.$message.info('个人资料功能开发中')
      } else if (command === 'settings') {
        this.$message.info('设置功能开发中')
      }
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap');

:root {
  --primary-color: #2D5BFF;
  --primary-dark: #1E40AF;
  --secondary-color: #FF6B9D;
  --accent-color: #FFB800;
  --bg-primary: #0A0E27;
  --bg-secondary: #151B3B;
  --bg-card: #1A2142;
  --text-primary: #FFFFFF;
  --text-secondary: #94A3B8;
  --text-muted: #64748B;
  --border-color: rgba(255, 255, 255, 0.1);
}

.user-home-container {
  min-height: 100vh;
  background: var(--bg-primary);
  font-family: 'Outfit', sans-serif;
  display: flex;
  flex-direction: column;
}

// 顶部导航栏
.header {
  position: sticky;
  top: 0;
  z-index: 100;
  background: rgba(21, 27, 59, 0.8);
  backdrop-filter: blur(20px);
  border-bottom: 1px solid var(--border-color);
  animation: slideDown 0.5s ease-out;
}

@keyframes slideDown {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.header-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px 40px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo-section {
  display: flex;
  align-items: center;
  gap: 12px;

  .logo {
    width: 40px;
    height: 40px;
    filter: brightness(0) invert(1);
  }

  .brand-name {
    font-size: 24px;
    font-weight: 700;
    color: var(--text-primary);
    letter-spacing: -0.5px;
  }
}

.nav-menu {
  display: flex;
  gap: 30px;

  .nav-item {
    color: var(--text-secondary);
    text-decoration: none;
    font-size: 15px;
    font-weight: 500;
    transition: color 0.3s ease;
    position: relative;

    &::after {
      content: '';
      position: absolute;
      bottom: -5px;
      left: 0;
      width: 0;
      height: 2px;
      background: var(--primary-color);
      transition: width 0.3s ease;
    }

    &:hover,
    &.active {
      color: var(--text-primary);

      &::after {
        width: 100%;
      }
    }
  }
}

.user-actions {
  .user-info {
    display: flex;
    align-items: center;
    gap: 10px;
    cursor: pointer;
    padding: 8px 16px;
    border-radius: 20px;
    transition: background 0.3s ease;

    &:hover {
      background: rgba(255, 255, 255, 0.05);
    }

    .avatar {
      width: 36px;
      height: 36px;
      border-radius: 50%;
      border: 2px solid var(--primary-color);
    }

    .username {
      color: var(--text-primary);
      font-weight: 500;
      font-size: 14px;
    }

    i {
      color: var(--text-secondary);
      font-size: 12px;
    }
  }
}

// 主内容区
.main-content {
  flex: 1;
  padding: 60px 40px;
}

.content-wrapper {
  max-width: 1400px;
  margin: 0 auto;
}

// 欢迎区域
.welcome-section {
  margin-bottom: 60px;
  position: relative;
  padding: 80px 60px;
  background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
  border-radius: 24px;
  overflow: hidden;
  animation: fadeInUp 0.6s ease-out 0.2s both;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.welcome-content {
  position: relative;
  z-index: 2;
}

.welcome-title {
  font-size: 48px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 15px;
  letter-spacing: -1px;
}

.welcome-subtitle {
  font-size: 20px;
  color: rgba(255, 255, 255, 0.8);
  font-weight: 300;
}

.decoration-elements {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  z-index: 1;
  opacity: 0.3;

  .circle {
    position: absolute;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(255, 255, 255, 0.2) 0%, transparent 70%);

    &.circle-1 {
      width: 300px;
      height: 300px;
      top: -100px;
      right: -50px;
      animation: float1 8s infinite ease-in-out;
    }

    &.circle-2 {
      width: 200px;
      height: 200px;
      bottom: -50px;
      left: 20%;
      animation: float2 10s infinite ease-in-out;
    }

    &.circle-3 {
      width: 150px;
      height: 150px;
      top: 50%;
      right: 20%;
      animation: float3 12s infinite ease-in-out;
    }
  }
}

@keyframes float1 {
  0%, 100% { transform: translate(0, 0); }
  50% { transform: translate(-20px, 20px); }
}

@keyframes float2 {
  0%, 100% { transform: translate(0, 0); }
  50% { transform: translate(30px, -30px); }
}

@keyframes float3 {
  0%, 100% { transform: translate(0, 0); }
  50% { transform: translate(-15px, -15px); }
}

// 功能卡片
.features-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 24px;
  margin-bottom: 60px;
}

.feature-card {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  padding: 30px;
  transition: all 0.3s ease;
  position: relative;
  overflow: hidden;
  animation: fadeInUp 0.6s ease-out both;

  @for $i from 1 through 6 {
    &:nth-child(#{$i}) {
      animation-delay: #{0.3 + $i * 0.1}s;
    }
  }

  &::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 4px;
    background: linear-gradient(90deg, var(--primary-color), var(--secondary-color));
    transform: scaleX(0);
    transform-origin: left;
    transition: transform 0.3s ease;
  }

  &:hover {
    transform: translateY(-5px);
    box-shadow: 0 10px 30px rgba(45, 91, 255, 0.2);
    border-color: var(--primary-color);

    &::before {
      transform: scaleX(1);
    }

    .card-icon {
      transform: scale(1.1) rotate(5deg);
    }
  }
}

.card-icon {
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, var(--primary-color), var(--primary-dark));
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-bottom: 20px;
  transition: transform 0.3s ease;

  i {
    font-size: 28px;
    color: var(--text-primary);
  }
}

.card-title {
  font-size: 20px;
  font-weight: 600;
  color: var(--text-primary);
  margin-bottom: 10px;
}

.card-description {
  font-size: 14px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 15px;
}

.card-status {
  display: inline-block;
  padding: 4px 12px;
  background: rgba(255, 184, 0, 0.1);
  color: var(--accent-color);
  border-radius: 12px;
  font-size: 12px;
  font-weight: 500;
}

// 占位内容
.placeholder-section {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: 20px;
  padding: 80px 40px;
  text-align: center;
  animation: fadeInUp 0.6s ease-out 0.8s both;
}

.placeholder-content {
  max-width: 600px;
  margin: 0 auto;
}

.placeholder-icon {
  font-size: 80px;
  color: var(--primary-color);
  margin-bottom: 30px;
  animation: bounce 2s infinite;
}

@keyframes bounce {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-20px); }
}

.placeholder-title {
  font-size: 32px;
  font-weight: 700;
  color: var(--text-primary);
  margin-bottom: 20px;
}

.placeholder-text {
  font-size: 16px;
  color: var(--text-secondary);
  line-height: 1.8;
}

// 底部信息
.footer {
  background: var(--bg-secondary);
  border-top: 1px solid var(--border-color);
  padding: 30px 40px;
  margin-top: auto;
}

.footer-content {
  max-width: 1400px;
  margin: 0 auto;
  text-align: center;
  color: var(--text-muted);
  font-size: 14px;
}

// 响应式设计
@media (max-width: 1024px) {
  .header-content {
    padding: 20px 30px;
  }

  .main-content {
    padding: 40px 30px;
  }

  .welcome-section {
    padding: 60px 40px;
  }

  .welcome-title {
    font-size: 36px;
  }

  .nav-menu {
    gap: 20px;
  }
}

@media (max-width: 768px) {
  .header-content {
    padding: 15px 20px;
  }

  .nav-menu {
    display: none;
  }

  .main-content {
    padding: 30px 20px;
  }

  .welcome-section {
    padding: 40px 30px;
  }

  .welcome-title {
    font-size: 28px;
  }

  .welcome-subtitle {
    font-size: 16px;
  }

  .features-grid {
    grid-template-columns: 1fr;
  }

  .placeholder-section {
    padding: 60px 30px;
  }

  .placeholder-title {
    font-size: 24px;
  }
}

// Element UI 样式覆盖
::v-deep .el-dropdown-menu {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  padding: 8px;

  .el-dropdown-menu__item {
    color: var(--text-secondary);
    border-radius: 8px;
    transition: all 0.3s ease;

    &:hover {
      background: rgba(45, 91, 255, 0.1);
      color: var(--text-primary);
    }
  }
}
</style>
