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
              <ModulesToolbar
                v-model="searchText"
                :title="activeTagLabel"
                :count="activeListCount"
                :placeholder="searchPlaceholder"
                :credit-name="activeTagId === 'banana' ? '松果先森' : ''"
                :credit-url="activeTagId === 'banana' ? 'https://github.com/songguoxs/gpt4o-image-prompts' : ''"
                @search="handleSearch"
              />

              <div v-if="listLoading" class="loading-state">
                <i class="el-icon-loading" />
                <p>正在加载 {{ activeTagLabel }}...</p>
              </div>

              <div v-else-if="listError" class="error-state">
                <i class="el-icon-warning-outline" />
                <p>{{ listError }}</p>
                <button @click="retryFetch">重试</button>
              </div>

              <!-- 模块卡片网格 -->
              <div v-else-if="activeTagId === 'ai-news'" class="news-list">
                <div
                  v-for="group in groupedAiNews"
                  :key="`news-group-${group.date}`"
                  class="news-group"
                >
                  <div class="date-divider">
                    <span>{{ group.date }}</span>
                  </div>
                  <article
                    v-for="news in group.items"
                    :key="news.id || news.url || news.title"
                    class="news-card"
                    @click="openNewsDetail(news)"
                  >
                    <div class="news-main">
                      <div class="news-header">
                        <span class="news-badge">AI 新闻</span>
                        <span v-if="news.source" class="news-source">{{ news.source }}</span>
                      </div>
                      <h3 class="news-title">{{ news.title || '未命名报道' }}</h3>
                      <p class="news-summary">{{ news.summary || '暂无摘要内容' }}</p>
                      <div v-if="news.category || news.sentiment" class="news-tags">
                        <span v-if="news.category" class="news-tag">{{ news.category }}</span>
                        <span v-if="news.sentiment" class="news-tag secondary">{{ news.sentiment }}</span>
                      </div>
                      <div class="news-meta">
                        <span v-if="news.published_at" class="news-date">{{ formatDateOnly(news.published_at) }}</span>
                        <span v-else class="news-date">未知日期</span>
                        <span v-if="news.author" class="news-author">{{ news.author }}</span>
                      </div>
                    </div>
                    <div v-if="news.image" class="news-cover">
                      <img :src="news.image" alt="cover">
                    </div>
                  </article>
                </div>
              </div>
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
    <AiNewsDrawer
      :visible.sync="newsDetailVisible"
      :loading="newsDetailLoading"
      :news="selectedNews"
    />

    <div class="user-footer">© 2026 KONUS AI. All rights reserved.</div>
  </div>
</template>

<script>
import { getGithubProjects, getGithubProjectDetail } from '@/api/ai/github'
import { searchPromptList, getPromptStats } from '@/api/ai/prompts'
import { searchTechCrunchNews, getTechCrunchNewsDetail, getTechCrunchNewsTotal } from '@/api/ai/techcrunch'
import TagSidebar from './components/TagSidebar'
import ModulesToolbar from './components/ModulesToolbar'
import ModulesGrid from './components/ModulesGrid'
import ProjectDrawer from './components/ProjectDrawer'
import AiNewsDrawer from './components/AiNewsDrawer'
import { mapGetters } from 'vuex'
import DefaultAvatar from '@/assets/images/avatar.png'

export default {
  name: 'UserHome',
  components: {
    TagSidebar,
    ModulesToolbar,
    ModulesGrid,
    ProjectDrawer,
    AiNewsDrawer
  },
  data() {
    return {
      searchText: '',
      activeTagId: 'github',
      navTabs: [
        { id: 'realtime', label: '实时数据', path: '/user/home' },
        { id: 'tools', label: '工具集', path: '/user/tools' }
      ],
      tags: [
        { id: 'github', name: 'GitHub 热榜', count: 0 },
        { id: 'ai-news', name: 'AI 新闻', count: 0 },
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
      aiNewsState: {
        items: [],
        page: 1,
        pageSize: 20,
        hasMore: true,
        listLoading: false,
        listError: '',
        isFetchingMore: false,
        total: 0
      },
      searchTimer: null,
      detailVisible: false,
      detailLoading: false,
      selectedProject: null,
      newsDetailVisible: false,
      newsDetailLoading: false,
      selectedNews: null
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
      if (this.activeTagId === 'banana') {
        return this.bananaState
      }
      if (this.activeTagId === 'ai-news') {
        return this.aiNewsState
      }
      return this.githubState
    },
    activeTagLabel() {
      const active = this.tags.find(tag => tag.id === this.activeTagId)
      return active ? active.name : '全部项目'
    },
    searchPlaceholder() {
      if (this.activeTagId === 'banana') {
        return '搜索 banana 绘图提示词...'
      }
      if (this.activeTagId === 'ai-news') {
        return '搜索 AI 新闻...'
      }
      return '搜索 实时数据项目...'
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
      if (this.activeTagId === 'ai-news') {
        return '未找到 AI 新闻'
      }
      if (this.activeTagId !== 'github') {
        return '未找到绘图提示词'
      }
      return '未找到相关项目'
    },
    filteredNews() {
      const items = [...this.aiNewsState.items]
      if (!this.searchText) {
        return items
      }
      const searchLower = this.searchText.toLowerCase()
      return items.filter(news => {
        return [
          news.title,
          news.summary,
          news.source,
          news.author
        ].some(field => field && field.toLowerCase().includes(searchLower))
      })
    },
    groupedAiNews() {
      const groups = new Map()
      this.filteredNews.forEach(news => {
        const dateKey = this.formatDateOnly(news.published_at)
        if (!groups.has(dateKey)) {
          groups.set(dateKey, [])
        }
        groups.get(dateKey).push(news)
      })
      return Array.from(groups.entries()).map(([date, items]) => ({ date, items }))
    },
    activeListCount() {
      if (this.activeTagId === 'ai-news') {
        return this.filteredNews.length
      }
      return this.filteredProjects.length
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
  created() {
    this.ensureUserProfile()
    this.fetchProjects({ reset: true })
    this.fetchPromptStats()
    this.fetchAiNewsTotal()
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
    async fetchPromptStats() {
      try {
        const data = await getPromptStats()
        const total = data && typeof data.total === 'number' ? data.total : 0
        this.updateTagCount('banana', total)
      } catch (error) {
        // ignore stats failures to avoid blocking page
      }
    },
    async fetchAiNewsTotal(keyword) {
      try {
        const params = {}
        if (keyword) {
          params.keyword = keyword
        }
        const data = await getTechCrunchNewsTotal(params)
        const total = typeof data === 'number'
          ? data
          : (data && typeof data.total === 'number'
            ? data.total
            : (data && typeof data.count === 'number' ? data.count : 0))
        this.updateTagCount('ai-news', total)
      } catch (error) {
        // ignore stats failures to avoid blocking page
      }
    },
    selectTag(tagId) {
      this.activeTagId = tagId
      this.searchText = ''
      this.detailVisible = false
      this.detailLoading = false
      this.selectedProject = null
      this.newsDetailVisible = false
      this.newsDetailLoading = false
      this.selectedNews = null
      if (this.searchTimer) {
        clearTimeout(this.searchTimer)
        this.searchTimer = null
      }
      if (this.$refs.modulesScroll) {
        this.$refs.modulesScroll.scrollTop = 0
      }
      if (tagId === 'github') {
        this.fetchProjects({ reset: true })
      } else if (tagId === 'ai-news') {
        this.fetchAiNews({ reset: true })
      } else if (tagId === 'banana') {
        this.fetchPrompts({ reset: true })
      }
    },
    handleSearch() {
      if (this.activeTagId !== 'banana' && this.activeTagId !== 'ai-news') {
        return
      }
      if (this.searchTimer) {
        clearTimeout(this.searchTimer)
      }
      this.searchTimer = setTimeout(() => {
        if (this.activeTagId === 'banana') {
          this.fetchPrompts({ reset: true })
        } else if (this.activeTagId === 'ai-news') {
          this.fetchAiNews({ reset: true })
          this.fetchAiNewsTotal(this.searchText)
        }
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
        } else if (this.activeTagId === 'ai-news') {
          this.fetchAiNews()
        } else if (this.activeTagId === 'banana') {
          this.fetchPrompts()
        }
      }
    },
    retryFetch() {
      if (this.activeTagId === 'github') {
        this.fetchProjects({ reset: true })
      } else if (this.activeTagId === 'ai-news') {
        this.fetchAiNews({ reset: true })
      } else if (this.activeTagId === 'banana') {
        this.fetchPrompts({ reset: true })
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
          state.listError = '获取实时数据失败，请稍后重试'
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
    normalizeNewsResponse(data) {
      if (Array.isArray(data)) {
        return { items: data }
      }
      if (!data || typeof data !== 'object') {
        return { items: [] }
      }
      const items = data.items || data.data || data.results || data.list || data.news || []
      const total = data.total !== undefined && data.total !== null
        ? data.total
        : (data.count !== undefined && data.count !== null
          ? data.count
          : (data.total_count !== undefined && data.total_count !== null
            ? data.total_count
            : data.totalCount))
      const pages = data.pages !== undefined && data.pages !== null
        ? data.pages
        : (data.total_pages !== undefined && data.total_pages !== null
          ? data.total_pages
          : data.totalPages)
      return {
        items: Array.isArray(items) ? items : [],
        total,
        pages
      }
    },
    mapNewsItem(item) {
      if (!item) {
        return {}
      }
      const newsId = item.id !== undefined && item.id !== null
        ? item.id
        : (item.news_id !== undefined && item.news_id !== null
          ? item.news_id
          : (item.newsId !== undefined && item.newsId !== null
            ? item.newsId
            : (item.article_id !== undefined && item.article_id !== null
              ? item.article_id
              : item.articleId)))
      return {
        id: newsId,
        title: item.ai_title || item.title || item.headline || item.name,
        summary: item.ai_summary || item.summary || item.description || item.excerpt || item.brief,
        source: item.source || item.source_name || item.publisher || 'TechCrunch',
        author: item.author || item.writer || '',
        url: item.url || item.link || item.source_url || '',
        published_at: item.published_at || item.publishedAt || item.created_at || item.createdAt || '',
        image: item.image || item.cover || item.thumbnail || item.image_url || '',
        content: item.ai_summary || item.content || item.body || item.html || '',
        category: item.ai_category || item.category || '',
        sentiment: item.ai_sentiment || item.sentiment || '',
        highlights: Array.isArray(item.ai_highlights) ? item.ai_highlights : [],
        keywords: Array.isArray(item.ai_keywords) ? item.ai_keywords : [],
        ai_data: item.ai_data || null
      }
    },
    async fetchAiNews({ reset = false } = {}) {
      const state = this.aiNewsState
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
        const data = await searchTechCrunchNews(params)
        const normalized = this.normalizeNewsResponse(data)
        const list = normalized.items.map(this.mapNewsItem)
        state.items = reset ? list : state.items.concat(list)
        if (typeof normalized.pages === 'number') {
          state.hasMore = state.page < normalized.pages
        } else if (typeof normalized.total === 'number') {
          state.hasMore = state.items.length < normalized.total
        } else if (list.length < state.pageSize) {
          state.hasMore = false
        }
        if (state.hasMore) {
          state.page += 1
        }
        if (typeof normalized.total === 'number') {
          state.total = normalized.total
          this.updateTagCount('ai-news', normalized.total)
        }
      } catch (error) {
        if (reset) {
          state.listError = '获取 AI 新闻失败，请稍后重试'
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
    async openNewsDetail(news) {
      this.newsDetailVisible = true
      this.newsDetailLoading = true
      this.selectedNews = news
      if (!news || !news.id) {
        this.newsDetailLoading = false
        return
      }
      try {
        const detail = await getTechCrunchNewsDetail(news.id)
        const mapped = this.mapNewsItem(detail)
        this.selectedNews = { ...news, ...mapped }
      } catch (error) {
        this.$message.error('获取报道详情失败')
      } finally {
        this.newsDetailLoading = false
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
  padding-top: 72px;
}

// AI 新闻列表
.news-list {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.news-group {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.date-divider {
  display: flex;
  align-items: center;
  gap: 16px;
  margin: 6px 0 4px;
  color: var(--text-muted);
  font-size: 12px;
  font-weight: 600;

  &::before,
  &::after {
    content: '';
    flex: 1;
    height: 1px;
    background: var(--border-color);
  }

  span {
    padding: 4px 10px;
    background: var(--bg-secondary);
    border: 1px solid var(--border-color);
    border-radius: 10px;
    color: var(--text-primary);
  }
}

.news-card {
  display: flex;
  gap: 18px;
  padding: 18px;
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: 16px;
  box-shadow: var(--shadow-sm);
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    border-color: var(--primary-color);
    transform: translateY(-3px);
    box-shadow: var(--shadow-md);
  }
}

.news-main {
  flex: 1;
  min-width: 0;
}

.news-header {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 10px;
}

.news-badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(37, 99, 235, 0.12);
  color: var(--primary-color);
  font-size: 12px;
  font-weight: 600;
}

.news-source {
  font-size: 12px;
  color: var(--text-muted);
}

.news-title {
  font-size: 16px;
  color: var(--text-primary);
  line-height: 1.5;
  margin-bottom: 8px;
}

.news-summary {
  font-size: 13px;
  color: var(--text-secondary);
  line-height: 1.6;
  margin-bottom: 12px;
}

.news-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin-bottom: 10px;
}

.news-tag {
  padding: 4px 10px;
  border-radius: 999px;
  background: var(--bg-muted);
  color: var(--text-muted);
  font-size: 12px;
  font-weight: 600;

  &.secondary {
    background: rgba(37, 99, 235, 0.12);
    color: var(--primary-color);
  }
}

.news-meta {
  display: flex;
  gap: 12px;
  font-size: 12px;
  color: var(--text-muted);
}

.news-cover {
  width: 120px;
  height: 88px;
  border-radius: 12px;
  overflow: hidden;
  flex-shrink: 0;
  background: var(--bg-muted);

  img {
    width: 100%;
    height: 100%;
    object-fit: cover;
    display: block;
  }
}

// 空状态
.empty-state {
  padding: 60px 20px;
  text-align: center;
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  box-shadow: var(--shadow-sm);

  i {
    font-size: 48px;
    color: var(--primary-color);
    margin-bottom: 16px;
    opacity: 0.6;
  }

  p {
    color: var(--text-muted);
    font-size: 14px;
    margin: 0 0 20px;
    font-weight: 300;
  }

  button {
    padding: 10px 20px;
    background: var(--primary-color);
    border: none;
    border-radius: 8px;
    color: #ffffff;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    font-family: 'Outfit', sans-serif;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 6px 16px rgba(37, 99, 235, 0.2);

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(37, 99, 235, 0.35),
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
  color: var(--text-muted);
  font-size: 12px;
  font-weight: 500;
}

.loading-state,
.error-state {
  padding: 60px 20px;
  text-align: center;
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  box-shadow: var(--shadow-sm);

  i {
    font-size: 42px;
    color: var(--primary-color);
    margin-bottom: 16px;
  }

  p {
    color: var(--text-muted);
    font-size: 14px;
    margin: 0 0 20px;
    font-weight: 300;
  }

  button {
    padding: 10px 20px;
    background: var(--primary-color);
    border: none;
    border-radius: 8px;
    color: #ffffff;
    font-size: 13px;
    font-weight: 600;
    cursor: pointer;
    font-family: 'Outfit', sans-serif;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 0 6px 16px rgba(37, 99, 235, 0.2);

    &:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 25px rgba(37, 99, 235, 0.35),
                  inset 0 1px 0 rgba(255, 255, 255, 0.3);
    }

    &:active {
      transform: translateY(0);
    }
  }
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

// Element UI 下拉菜单样式
::v-deep .el-dropdown-menu {
  background: var(--bg-secondary);
  border: 1px solid var(--border-color);
  border-radius: 10px;
  padding: 6px;
  box-shadow: var(--shadow-md);

  .el-dropdown-menu__item {
    color: var(--text-muted);
    font-size: 13px;
    font-weight: 500;
    padding: 9px 14px;
    border-radius: 7px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    font-family: 'Outfit', sans-serif;

    &:hover {
      background: var(--bg-muted);
      color: var(--text-primary);
    }

    &.is-divided {
      margin-top: 4px;
      padding-top: 9px;
      border-top: 1px solid var(--border-color);
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
