<template>
  <div class="user-home-container">

    <!-- 顶部导航栏 -->
    <header class="header">
      <div class="header-content">
        <div class="logo-section">
          <img src="@/assets/images/logo.png" alt="KONUS AI" class="logo">
          <span class="brand-name">KONUS AI</span>
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
                <button @click="fetchProjects">重试</button>
              </div>

              <!-- 模块卡片网格 -->
              <ModulesGrid
                v-else-if="activeTagId === 'github' && groupedGithubProjects.length > 0"
                :grouped-items="groupedGithubProjects"
                :show-date-divider="true"
                :format-number="formatNumber"
                :format-period-label="formatPeriodLabel"
                :variant="activeTagId"
                @select="openProjectDetail"
              />
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
import { getGithubProjects, getGithubProjectDetail } from '@/api/ai/github'
import { searchPromptList, getPromptStats } from '@/api/ai/prompts'
import TagSidebar from './components/TagSidebar'
import ModulesToolbar from './components/ModulesToolbar'
import ModulesGrid from './components/ModulesGrid'
import ProjectDrawer from './components/ProjectDrawer'
import { mapGetters } from 'vuex'
import DefaultAvatar from '@/assets/images/avatar.png'

export default {
  name: 'UserHome',
  components: {
    TagSidebar,
    ModulesToolbar,
    ModulesGrid,
    ProjectDrawer
  },
  data() {
    return {
      searchText: '',
      activeTagId: 'github',
      tags: [
        { id: 'github', name: 'GitHub 热榜', count: 0 },
        { id: 'banana', name: 'banana 绘图', count: 0 }
      ],
      githubState: {
        items: [],
        page: 1,
        pageSize: 20,
        hasMore: true,
        listLoading: false,
        listError: '',
        isFetchingMore: false
      },
      bananaState: {
        items: [],
        page: 1,
        pageSize: 20,
        hasMore: true,
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
      return this.activeTagId === 'banana' ? this.bananaState : this.githubState
    },
    activeTagLabel() {
      const active = this.tags.find(tag => tag.id === this.activeTagId)
      return active ? active.name : '全部项目'
    },
    searchPlaceholder() {
      if (this.activeTagId === 'banana') {
        return '搜索 banana 绘图提示词...'
      }
      return '搜索 GitHub 热榜项目...'
    },
    filteredProjects() {
      const items = [...this.activeState.items]
      if (this.activeTagId !== 'github') {
        return items
      }
      if (!this.searchText) {
        return items
      }
      const searchLower = this.searchText.toLowerCase()
      return items.filter(project => {
        const category = project.analysis_data && project.analysis_data.category
        return [
          project.repo_name,
          project.title,
          project.description,
          project.language,
          category
        ].some(field => field && field.toLowerCase().includes(searchLower))
      })
    },
    groupedGithubProjects() {
      if (this.activeTagId !== 'github') {
        return []
      }
      const groups = new Map()
      this.filteredProjects.forEach(project => {
        const dateKey = this.formatDateOnly(project.created_at)
        if (!groups.has(dateKey)) {
          groups.set(dateKey, [])
        }
        groups.get(dateKey).push(project)
      })
      return Array.from(groups.entries()).map(([date, items]) => ({ date, items }))
    },
    emptyStateText() {
      if (this.activeTagId !== 'github') {
        return '未找到绘图提示词'
      }
      return '未找到相关项目'
    }
  },
  created() {
    this.fetchProjects({ reset: true })
    this.fetchPromptStats()
  },
  methods: {
    async fetchPromptStats() {
      try {
        const data = await getPromptStats()
        const total = data && typeof data.total === 'number' ? data.total : 0
        this.updateTagCount('banana', total)
      } catch (error) {
        // ignore stats failures to avoid blocking page
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
      if (tagId === 'github') {
        this.fetchProjects({ reset: true })
      } else if (tagId === 'banana') {
        this.fetchPrompts({ reset: true })
      }
    },
    handleSearch() {
      if (this.activeTagId !== 'banana') {
        return
      }
      if (this.searchTimer) {
        clearTimeout(this.searchTimer)
      }
      this.searchTimer = setTimeout(() => {
        this.fetchPrompts({ reset: true })
      }, 300)
    },
    handleScroll(event) {
      if (!this.activeState.hasMore || this.activeState.listLoading || this.activeState.isFetchingMore) {
        return
      }
      const target = event.target
      const threshold = 120
      if (target.scrollHeight - target.scrollTop - target.clientHeight < threshold) {
        if (this.activeTagId === 'github') {
          this.fetchProjects()
        } else if (this.activeTagId === 'banana') {
          this.fetchPrompts()
        }
      }
    },
    updateTagCount(tagId, count) {
      this.tags = this.tags.map(tag => {
        if (tag.id === tagId) {
          return { ...tag, count }
        }
        return tag
      })
    },
    truncateText(text, limit) {
      if (!text) {
        return ''
      }
      const normalized = String(text).replace(/\s+/g, ' ').trim()
      if (normalized.length <= limit) {
        return normalized
      }
      return normalized.slice(0, limit) + '...'
    },
    extractPromptParts(promptText) {
      if (!promptText) {
        return { en: '', zh: '' }
      }
      const raw = String(promptText)
      if (raw.includes('---')) {
        const [enPart, zhPart] = raw.split('---')
        return {
          en: enPart.trim(),
          zh: zhPart.trim()
        }
      }
      return { en: raw.trim(), zh: '' }
    },
    async fetchProjects({ reset = false } = {}) {
      const state = this.githubState
      if (reset) {
        state.page = 1
        state.hasMore = true
        state.items = []
      }
      if (!state.hasMore) {
        return
      }
      if (reset) {
        state.listLoading = true
        state.listError = ''
      } else {
        state.isFetchingMore = true
      }
      try {
        const data = await getGithubProjects({ limit: state.pageSize, page: state.page })
        const list = Array.isArray(data) ? data : []
        state.items = reset ? list : state.items.concat(list)
        if (list.length < state.pageSize) {
          state.hasMore = false
        } else {
          state.page += 1
        }
        this.updateTagCount('github', state.items.length)
      } catch (error) {
        if (reset) {
          state.listError = '获取 GitHub 热榜失败，请稍后重试'
          state.items = []
        } else {
          this.$message.error('加载更多失败，请稍后重试')
        }
      } finally {
        if (reset) {
          state.listLoading = false
        }
        state.isFetchingMore = false
      }
    },
    mapPromptToProject(item) {
      const imageUrl = item.image_path
        ? `http://localhost:8000/ai/${item.image_path.replace(/^\/+/, '')}`
        : ''
      const promptParts = this.extractPromptParts(item.prompt_text)
      const model = item.extra_data && item.extra_data.model
      const tags = Array.isArray(item.tags) ? item.tags : []
      const source = item.extra_data && item.extra_data.source
      return {
        id: item.id || item.prompt_id,
        repo_name: item.prompt_id ? `Prompt #${item.prompt_id}` : item.title,
        prompt_id: item.prompt_id,
        category: item.category,
        model,
        title: item.title,
        description: item.description || item.prompt_text,
        short_description: this.truncateText(item.description || item.prompt_text, 120),
        language: model || item.category,
        stars: 0,
        forks: 0,
        trend_period: 'banana',
        created_at: item.created_at,
        updated_at: item.updated_at,
        analysis_data: {
          category: item.category
        },
        image_url: imageUrl,
        tags,
        source_name: source ? source.name : '',
        source_url: source ? source.url : '',
        prompt_en: promptParts.en,
        prompt_zh: promptParts.zh,
        prompt_text: item.prompt_text,
        repo_url: ''
      }
    },
    async fetchPrompts({ reset = false } = {}) {
      const state = this.bananaState
      if (reset) {
        state.page = 1
        state.hasMore = true
        state.items = []
      }
      if (!state.hasMore) {
        return
      }
      if (reset) {
        state.listLoading = true
        state.listError = ''
      } else {
        state.isFetchingMore = true
      }
      try {
        const params = {
          page: state.page,
          size: state.pageSize
        }
        if (this.searchText) {
          params.keyword = this.searchText
        }
        const data = await searchPromptList(params)
        const items = Array.isArray(data && data.items) ? data.items : []
        const list = items.map(this.mapPromptToProject)
        state.items = reset ? list : state.items.concat(list)
        if (typeof data.pages === 'number') {
          state.hasMore = state.page < data.pages
        } else if (list.length < state.pageSize) {
          state.hasMore = false
        }
        if (state.hasMore) {
          state.page += 1
        }
        if (typeof data.total === 'number') {
          this.updateTagCount('banana', data.total)
        } else {
          this.updateTagCount('banana', state.items.length)
        }
      } catch (error) {
        if (reset) {
          state.listError = '获取绘图提示词失败，请稍后重试'
          state.items = []
        } else {
          this.$message.error('加载更多失败，请稍后重试')
        }
      } finally {
        if (reset) {
          state.listLoading = false
        }
        state.isFetchingMore = false
      }
    },
    async openProjectDetail(project) {
      if (this.activeTagId === 'banana') {
        this.selectedProject = project
        this.detailLoading = false
        this.detailVisible = true
        return
      }
      this.detailVisible = true
      this.detailLoading = true
      this.selectedProject = null
      try {
        const detail = await getGithubProjectDetail(project.id)
        this.selectedProject = detail || project
      } catch (error) {
        this.selectedProject = project
        this.$message.error('获取项目详情失败')
      } finally {
        this.detailLoading = false
      }
    },
    resetFilters() {
      this.searchText = ''
      this.activeTagId = 'github'
      this.fetchProjects({ reset: true })
    },
    formatNumber(num) {
      if (num >= 1000) {
        return (num / 1000).toFixed(1) + 'k'
      }
      return num
    },
    formatDateOnly(value) {
      if (!value) {
        return '未知日期'
      }
      const date = new Date(value)
      if (Number.isNaN(date.getTime())) {
        return '未知日期'
      }
      const year = date.getFullYear()
      const month = String(date.getMonth() + 1).padStart(2, '0')
      const day = String(date.getDate()).padStart(2, '0')
      return `${year}-${month}-${day}`
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
        color: #2d5bff;
      }
      i {
        color: #2d5bff;
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

// 左侧分类导航

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
  padding: 60px 20px;
  text-align: center;
  background: #ffffff;
  border: 1px solid #e8ecf3;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(31, 42, 68, 0.06);

  i {
    font-size: 48px;
    color: #ffd2a6;
    margin-bottom: 16px;
    opacity: 0.6;
  }

  p {
    color: #6b7280;
    font-size: 14px;
    margin: 0 0 20px;
    font-weight: 300;
  }

  button {
    padding: 10px 20px;
    background: linear-gradient(135deg, #ffd2a6, #ffc285);
    border: none;
    border-radius: 8px;
    color: #ffffff;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    font-family: 'Outfit', sans-serif;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 6px 16px rgba(91, 91, 246, 0.2);

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(45, 91, 255, 0.5),
                  inset 0 1px 0 rgba(255, 255, 255, 0.3);
    }

    &:active {
      transform: translateY(0);
    }
  }
}

.loading-more {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  padding: 16px 0;
  color: #98a2b3;
  font-size: 12px;
  font-weight: 500;
}

.loading-state,
.error-state {
  padding: 60px 20px;
  text-align: center;
  background: #ffffff;
  border: 1px solid #e8ecf3;
  border-radius: 12px;
  box-shadow: 0 10px 30px rgba(31, 42, 68, 0.06);

  i {
    font-size: 42px;
    color: #ffd2a6;
    margin-bottom: 16px;
  }

  p {
    color: #6b7280;
    font-size: 14px;
    margin: 0 0 20px;
    font-weight: 300;
  }

  button {
    padding: 10px 20px;
    background: linear-gradient(135deg, #ffd2a6, #ffc285);
    border: none;
    border-radius: 8px;
    color: #ffffff;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    font-family: 'Outfit', sans-serif;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 6px 16px rgba(91, 91, 246, 0.2);

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(45, 91, 255, 0.5),
                  inset 0 1px 0 rgba(255, 255, 255, 0.3);
    }

    &:active {
      transform: translateY(0);
    }
  }
}

// Element UI 下拉菜单样式
::v-deep .el-dropdown-menu {
  background: #ffffff;
  border: 1px solid #e8ecf3;
  border-radius: 10px;
  padding: 6px;
  box-shadow: 0 12px 30px rgba(31, 42, 68, 0.12);

  .el-dropdown-menu__item {
    color: #6b7280;
    font-size: 13px;
    font-weight: 500;
    padding: 9px 14px;
    border-radius: 7px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    font-family: 'Outfit', sans-serif;

    &:hover {
      background: #f2f4f8;
      color: #1f2a44;
    }

    &.is-divided {
      margin-top: 4px;
      padding-top: 9px;
      border-top: 1px solid #edf0f6;
    }
  }
}

// 响应式设计
@media (max-width: 1024px) {
  .layout-container {
    flex-direction: column;
  }
}

@media (max-width: 768px) {
  .header-content {
    flex-wrap: wrap;
    gap: 12px;
  }
}
</style>
