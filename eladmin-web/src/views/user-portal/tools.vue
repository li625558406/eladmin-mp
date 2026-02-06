<template>
  <div class="user-home-container">
    <!-- 顶部导航栏 -->
    <header class="header">
      <div class="header-content">
        <div class="logo-section">
          <img src="@/assets/images/logo.png" alt="KONUS AI" class="logo">
          <span class="brand-name">KONUS AI</span>
        </div>

        <div class="nav-section">
          <div class="nav-tabs">
            <button
              v-for="tab in navTabs"
              :key="tab.id"
              :class="['nav-tab', { active: isActiveTab(tab) }]"
              @click="switchTab(tab)"
            >
              {{ tab.label }}
            </button>
          </div>
        </div>

        <div class="user-section">
          <el-dropdown v-if="isLoggedIn" trigger="click" popper-class="user-dropdown-menu" @command="handleCommand">
            <div class="user-profile">
              <img :src="userAvatar" alt="User" class="user-avatar">
              <span class="username">{{ userDisplayName }}</span>
              <i class="el-icon-arrow-down" />
            </div>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="profile">个人资料</el-dropdown-item>
              <el-dropdown-item command="settings">设置</el-dropdown-item>
              <el-dropdown-item divided command="logout">退出</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
          <div v-else class="user-guest">
            <el-button class="login-btn" type="primary" size="mini" @click="goToLogin">登录/注册</el-button>
          </div>
        </div>
      </div>
    </header>

    <!-- 主内容区 -->
    <main class="main-content">
      <div class="content-wrapper">
        <div class="layout-container">
          <!-- 左侧分类导航 -->
          <TagSidebar
            title="列表"
            :tags="tags"
            :active-tag-id="activeTagId"
            @select="selectTag"
          />

          <!-- 右侧模块展示区 -->
          <div ref="modulesScroll" class="modules-area" @scroll="handleScroll">
            <div class="modules-scroll-inner">
              <div class="tools-title">{{ activeTagLabel }}</div>

              <div v-if="listLoading" class="loading-state">
                <i class="el-icon-loading" />
                <p>正在加载 {{ activeTagLabel }}...</p>
              </div>

              <div v-else-if="listError" class="error-state">
                <i class="el-icon-warning-outline" />
                <p>{{ listError }}</p>
                <button @click="fetchTools">重试</button>
              </div>

              <!-- 模块卡片网格 -->
              <ModulesGrid
                v-else-if="filteredProjects.length > 0"
                :items="filteredProjects"
                :format-number="formatNumber"
                :format-period-label="formatPeriodLabel"
                :variant="activeTagId"
                @select="openProjectDetail"
              />

              <div v-if="isFetchingMore" class="loading-more">
                <i class="el-icon-loading" />
                <span>加载更多中...</span>
              </div>

              <!-- 空状态（按需求隐藏） -->
              <div v-else v-show="false" class="empty-state" />
            </div>
          </div>
        </div>
      </div>

    </main>

    <ProjectDrawer
      :visible.sync="detailVisible"
      :loading="detailLoading"
      :project="selectedProject"
      :format-number="formatNumber"
      :format-period-label="formatPeriodLabel"
      :variant="activeTagId"
    />
    <div class="user-footer">© 2026 KONUS AI. All rights reserved.</div>
  </div>
</template>

<script>
import TagSidebar from './components/TagSidebar'
import ModulesGrid from './components/ModulesGrid'
import ProjectDrawer from './components/ProjectDrawer'
import { mapGetters } from 'vuex'
import DefaultAvatar from '@/assets/images/avatar.png'

export default {
  name: 'UserTools',
  components: {
    TagSidebar,
    ModulesGrid,
    ProjectDrawer
  },
  data() {
    return {
      searchText: '',
      activeTagId: 'tools',
      navTabs: [
        { id: 'realtime', label: '实时数据', path: '/user/home' },
        { id: 'tools', label: '工具集', path: '/user/tools' }
      ],
      tags: [
        { id: 'tools', name: '工具集', count: 0 }
      ],
      toolsState: {
        items: [],
        page: 1,
        pageSize: 20,
        hasMore: false,
        listLoading: false,
        listError: '',
        isFetchingMore: false
      },
      searchTimer: null,
      detailVisible: false,
      detailLoading: false,
      selectedProject: null
    }
  },
  created() {
    this.ensureUserProfile()
  },
  computed: {
    ...mapGetters(['user', 'baseApi', 'token']),
    isLoggedIn() {
      return Boolean(this.token)
    },
    userProfile() {
      return this.user && this.user.user ? this.user.user : (this.user || {})
    },
    userDisplayName() {
      const user = this.userProfile
      return user.nickName || user.username || user.email || '用户'
    },
    userAvatar() {
      const user = this.userProfile
      if (user.avatarPath) {
        if (user.avatarPath.startsWith('http')) {
          return user.avatarPath
        }
        const base = process.env.BASE_URL || '/'
        const normalizedBase = base.endsWith('/') ? base.slice(0, -1) : base
        const normalizedPath = user.avatarPath.startsWith('/') ? user.avatarPath : `/${user.avatarPath}`
        return `${normalizedBase}${normalizedPath}`
      }
      if (user.avatarName && this.baseApi) {
        return `${this.baseApi}/avatar/${user.avatarName}`
      }
      return DefaultAvatar
    },
    defaultAvatar() {
      return DefaultAvatar
    },
    activeState() {
      return this.toolsState
    },
    activeTagLabel() {
      const active = this.tags.find(tag => tag.id === this.activeTagId)
      return active ? active.name : '全部工具'
    },
    searchPlaceholder() {
      return '搜索工具集...'
    },
    filteredProjects() {
      const items = [...this.activeState.items]
      if (!this.searchText) {
        return items
      }
      const searchLower = this.searchText.toLowerCase()
      return items.filter(project => {
        return [
          project.name,
          project.title,
          project.description,
          project.category
        ].some(field => field && field.toLowerCase().includes(searchLower))
      })
    },
    listLoading() {
      return this.activeState.listLoading
    },
    listError() {
      return this.activeState.listError
    },
    isFetchingMore() {
      return this.activeState.isFetchingMore
    }
  },
  methods: {
    ensureUserProfile() {
      const profile = this.userProfile
      if (this.isLoggedIn && (!profile || !profile.username)) {
        this.$store.dispatch('GetInfo').catch(() => {})
      }
    },
    isActiveTab(tab) {
      return this.$route.path === tab.path
    },
    switchTab(tab) {
      if (this.$route.path !== tab.path) {
        this.$router.push(tab.path)
      }
    },
    selectTag(tagId) {
      this.activeTagId = tagId
      this.searchText = ''
      if (this.searchTimer) {
        clearTimeout(this.searchTimer)
        this.searchTimer = null
      }
      if (this.$refs.modulesScroll) {
        this.$refs.modulesScroll.scrollTop = 0
      }
    },
    handleSearch() {
      if (this.searchTimer) {
        clearTimeout(this.searchTimer)
      }
      this.searchTimer = setTimeout(() => {}, 200)
    },
    handleScroll() {
      // 预留滚动加载逻辑
    },
    fetchTools() {
      // 预留工具集数据加载逻辑
    },
    openProjectDetail(project) {
      this.detailLoading = false
      this.selectedProject = project
      this.detailVisible = true
    },
    formatNumber(num) {
      if (num >= 1000) {
        return (num / 1000).toFixed(1) + 'k'
      }
      return num
    },
    formatPeriodLabel(period) {
      const map = {
        daily: '日榜',
        weekly: '周榜',
        monthly: '月榜'
      }
      return map[period] || period || '热榜'
    },
    handleCommand(command) {
      if (command === 'logout') {
        this.$confirm('确定要退出登录吗？', '提示', {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
          customClass: 'user-confirm-dialog'
        }).then(() => {
          this.$store.dispatch('LogOut').then(() => {
            this.$message.success('已退出登录')
            this.$router.push('/user/login')
          })
        })
      } else if (command === 'profile') {
        this.$message.info('个人资料功能开发中')
      } else if (command === 'settings') {
        this.$message.info('设置功能开发中')
      }
    },
    goToLogin() {
      this.$router.push('/user/login')
    }
  }
}
</script>

<style rel="stylesheet/scss" lang="scss" scoped>
@import url('https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap');

* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

.user-home-container {
  min-height: 100vh;
  height: 100vh;
  overflow: hidden;
  background: #f8fafc;
  font-family: 'Outfit', sans-serif;
  --header-height: 64px;
  --primary-color: #2563eb;
  --primary-light: #3b82f6;
  --primary-dark: #1d4ed8;
  --accent-color: #f97316;
  --bg-primary: #f8fafc;
  --bg-secondary: #ffffff;
  --bg-muted: #f1f5f9;
  --text-primary: #1e293b;
  --text-secondary: #475569;
  --text-muted: #64748b;
  --border-color: #e2e8f0;
  --shadow-sm: 0 6px 20px rgba(15, 23, 42, 0.06);
  --shadow-md: 0 12px 28px rgba(15, 23, 42, 0.08);
}

// 顶部导航栏
.header {
  background: var(--bg-secondary);
  border-bottom: 1px solid var(--border-color);
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
}

.header-content {
  max-width: 1400px;
  margin: 0 auto;
  padding: 14px 24px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.logo-section {
  display: flex;
  align-items: center;
  gap: 10px;

  .logo {
    width: 36px;
    height: 36px;
  }

  .brand-name {
    font-size: 18px;
    font-weight: 700;
    color: var(--text-primary);
    letter-spacing: -0.3px;
  }
}

.nav-section {
  flex: 1;
  display: flex;
  justify-content: center;
}

.nav-tabs {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 4px;
  background: var(--bg-muted);
  border-radius: 999px;
  border: 1px solid var(--border-color);
}

.nav-tab {
  padding: 8px 22px;
  border: 0;
  background: transparent;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 600;
  color: var(--text-muted);
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    color: var(--primary-color);
  }

  &.active {
    color: var(--text-primary);
    background: var(--bg-secondary);
    box-shadow: var(--shadow-sm);
  }
}

.user-section {
  .user-profile {
    display: flex;
    align-items: center;
    gap: 8px;
    padding: 4px 0;
    cursor: pointer;
    transition: all 0.2s ease;

    &:hover {
      .username {
        color: var(--primary-color);
      }
      i {
        color: var(--primary-color);
      }
    }

    .user-avatar {
      width: 30px;
      height: 30px;
      border-radius: 50%;
      border: 2px solid var(--border-color);
      object-fit: cover;
    }

    .username {
      font-size: 13px;
      font-weight: 500;
      color: var(--text-primary);
    }

    i {
      font-size: 12px;
      color: var(--text-muted);
    }
  }

  .user-guest {
    display: flex;
    align-items: center;
    gap: 10px;

    .user-avatar.guest {
      width: 30px;
      height: 30px;
      border-radius: 50%;
      border: 2px solid var(--border-color);
      object-fit: cover;
      opacity: 0.9;
    }

    .username.guest {
      font-size: 13px;
      color: var(--text-muted);
    }

    .login-btn {
      height: 28px;
      padding: 0 12px;
      border-radius: 14px;
      font-size: 12px;
      font-weight: 600;
      background: var(--primary-color);
      border-color: var(--primary-color);
      color: #ffffff;
      box-shadow: 0 6px 16px rgba(37, 99, 235, 0.25);

      &:hover,
      &:focus {
        background: var(--primary-dark);
        border-color: var(--primary-dark);
        box-shadow: 0 8px 18px rgba(37, 99, 235, 0.35);
      }
    }
  }
}

// 主内容区
.main-content {
  padding: calc(var(--header-height) + 24px) 0 0 85px;
  height: calc(100vh - var(--header-height));
  box-sizing: border-box;
}

.content-wrapper {
  max-width: none;
  width: 100%;
  margin: 0 auto;
  height: 100%;
}

.layout-container {
  display: flex;
  gap: 20px;
  height: 100%;
  width: 100%;
}

// 右侧模块区域
.modules-area {
  flex: 1;
  min-width: 0;
  height: 100%;
  overflow-y: auto;
  padding-right: 0;

  &::-webkit-scrollbar {
    width: 8px;
  }

  &::-webkit-scrollbar-track {
    background: var(--bg-primary);
    border-radius: 999px;
  }

  &::-webkit-scrollbar-thumb {
    background: rgba(180, 186, 204, 0.7);
    border-radius: 999px;
    border: 2px solid var(--bg-primary);
  }

  &::-webkit-scrollbar-thumb:hover {
    background: rgba(146, 154, 176, 0.9);
  }
}

.modules-scroll-inner {
  padding-right: 20px;
  padding-bottom: 24px;
  padding-top: 24px;
}

.tools-title {
  font-size: 18px;
  font-weight: 700;
  color: var(--text-primary, #1e293b);
  letter-spacing: -0.3px;
  line-height: 1.4;
  margin-bottom: 16px;
}

// 空状态
.empty-state {
  height: 120px;
}

.loading-state,
.error-state {
  background: var(--bg-secondary);
  border-radius: 16px;
  padding: 60px 24px;
  text-align: center;
  box-shadow: var(--shadow-sm);
  color: var(--text-muted);

  i {
    font-size: 28px;
    margin-bottom: 12px;
    display: block;
  }

  p {
    font-size: 14px;
    margin-bottom: 0;
  }
}

.loading-more {
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 8px;
  color: var(--text-muted);
  padding: 16px 0;
}

.user-footer {
  position: fixed;
  left: 0;
  right: 0;
  bottom: 16px;
  text-align: center;
  font-size: 12px;
  color: var(--text-muted);
  z-index: 900;
}

@media (max-width: 1280px) {
  .header-content {
    padding: 14px 16px;
  }
}

@media (max-width: 1024px) {
  .header-content {
    flex-wrap: wrap;
    gap: 12px;
  }

  .nav-section {
    order: 3;
    width: 100%;
    justify-content: flex-start;
  }

  .nav-tabs {
    width: 100%;
    justify-content: center;
  }
}
</style>
