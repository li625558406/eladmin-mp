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
          <el-dropdown v-if="isLoggedIn" trigger="click" @command="handleCommand">
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
            <img :src="defaultAvatar" alt="Guest" class="user-avatar guest">
            <span class="username guest">未登录</span>
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
            title="工具列表"
            :tags="tags"
            :active-tag-id="activeTagId"
            @select="selectTag"
          />

          <!-- 右侧模块展示区 -->
          <div ref="modulesScroll" class="modules-area" @scroll="handleScroll">
            <div class="modules-scroll-inner">
              <ModulesToolbar
                v-model="searchText"
                :title="activeTagLabel"
                :count="filteredProjects.length"
                :placeholder="searchPlaceholder"
                @search="handleSearch"
              />

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
  </div>
</template>

<script>
import TagSidebar from './components/TagSidebar'
import ModulesToolbar from './components/ModulesToolbar'
import ModulesGrid from './components/ModulesGrid'
import ProjectDrawer from './components/ProjectDrawer'
import { mapGetters } from 'vuex'
import DefaultAvatar from '@/assets/images/avatar.png'

export default {
  name: 'UserTools',
  components: {
    TagSidebar,
    ModulesToolbar,
    ModulesGrid,
    ProjectDrawer
  },
  data() {
    return {
      searchText: '',
      activeTagId: 'tools',
      navTabs: [
        { id: 'realtime', label: '实时数采', path: '/user/home' },
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
          type: 'warning'
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
  background: #f6f7fb;
  font-family: 'Outfit', sans-serif;
  --header-height: 64px;
  --accent-color: #46a6ff;
}

// 顶部导航栏
.header {
  background: #ffffff;
  border-bottom: 1px solid #e8ecf3;
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
    color: #1f2a44;
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
  background: #f3f5fb;
  border-radius: 999px;
  border: 1px solid #e6eaf3;
}

.nav-tab {
  padding: 8px 22px;
  border: 0;
  background: transparent;
  border-radius: 999px;
  font-size: 13px;
  font-weight: 600;
  color: #667085;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    color: var(--accent-color);
  }

  &.active {
    color: #1f2a44;
    background: #ffffff;
    box-shadow: 0 6px 16px rgba(15, 23, 42, 0.08);
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
        color: var(--accent-color);
      }
      i {
        color: var(--accent-color);
      }
    }

    .user-avatar {
      width: 30px;
      height: 30px;
      border-radius: 50%;
      border: 2px solid #e8ecf3;
      object-fit: cover;
    }

    .username {
      font-size: 13px;
      font-weight: 500;
      color: #1f2a44;
    }

    i {
      font-size: 12px;
      color: #98a2b3;
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
      border: 2px solid #e8ecf3;
      object-fit: cover;
      opacity: 0.9;
    }

    .username.guest {
      font-size: 13px;
      color: #98a2b3;
    }

    .login-btn {
      height: 28px;
      padding: 0 12px;
      border-radius: 14px;
      font-size: 12px;
      font-weight: 600;
      background: linear-gradient(135deg, #46a6ff 0%, #7bc1ff 100%);
      border-color: #46a6ff;
      color: #ffffff;
      box-shadow: 0 6px 16px rgba(70, 166, 255, 0.25);

      &:hover,
      &:focus {
        background: linear-gradient(135deg, #7bc1ff 0%, #46a6ff 100%);
        border-color: #46a6ff;
        box-shadow: 0 8px 18px rgba(70, 166, 255, 0.35);
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
    background: #f6f7fb;
    border-radius: 999px;
  }

  &::-webkit-scrollbar-thumb {
    background: rgba(180, 186, 204, 0.7);
    border-radius: 999px;
    border: 2px solid #f6f7fb;
  }

  &::-webkit-scrollbar-thumb:hover {
    background: rgba(146, 154, 176, 0.9);
  }
}

.modules-scroll-inner {
  padding-right: 20px;
  padding-bottom: 24px;
  padding-top: 72px;
}

// 空状态
.empty-state {
  height: 120px;
}

.loading-state,
.error-state {
  background: #ffffff;
  border-radius: 16px;
  padding: 60px 24px;
  text-align: center;
  box-shadow: 0 12px 32px rgba(15, 23, 42, 0.08);
  color: #667085;

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
  color: #98a2b3;
  padding: 16px 0;
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
