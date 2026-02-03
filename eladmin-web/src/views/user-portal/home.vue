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
          <el-dropdown trigger="click" @command="handleCommand">
            <div class="user-profile">
              <img src="@/assets/images/avatar.png" alt="User" class="user-avatar">
              <span class="username">用户</span>
              <i class="el-icon-arrow-down" />
            </div>
            <el-dropdown-menu slot="dropdown">
              <el-dropdown-item command="profile">个人资料</el-dropdown-item>
              <el-dropdown-item command="settings">设置</el-dropdown-item>
              <el-dropdown-item divided command="logout">退出</el-dropdown-item>
            </el-dropdown-menu>
          </el-dropdown>
        </div>
      </div>
    </header>

    <!-- 主内容区 -->
    <main class="main-content">
      <div class="content-wrapper">
        <div class="layout-container">
          <!-- 左侧分类导航 -->
          <aside class="sidebar-categories">
            <div class="sidebar-title">标签</div>
            <div class="tag-list">
              <button
                v-for="tag in tags"
                :key="tag.id"
                :class="['category-item', { active: activeTagId === tag.id }]"
                @click="selectTag(tag.id)"
              >
                <span class="item-name">{{ tag.name }}</span>
                <span class="count">{{ tag.count }}</span>
              </button>
            </div>
          </aside>

          <!-- 右侧模块展示区 -->
          <div ref="modulesScroll" class="modules-area" @scroll="handleScroll">
            <div class="modules-scroll-inner">
              <div class="modules-toolbar">
                <div class="modules-title">
                  <h2>{{ activeTagLabel }}</h2>
                  <span class="module-count">{{ filteredProjects.length }} 个项目</span>
                </div>
                <div class="search-section">
                  <i class="el-icon-search" />
                  <input
                    v-model="searchText"
                    type="text"
                    placeholder="搜索 GitHub 热榜项目..."
                    class="search-input"
                    @input="handleSearch"
                  >
                </div>
              </div>

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
              <div v-else-if="groupedProjects.length > 0" class="modules-grid">
                <div v-for="group in groupedProjects" :key="`group-${group.date}`">
                  <div class="date-divider">
                    <span>{{ group.date }}</span>
                  </div>
                  <div
                    v-for="project in group.items"
                    :key="project.id"
                    class="module-card"
                    @click="openProjectDetail(project)"
                  >
                    <div class="card-icon">
                      <i class="el-icon-star-on" />
                    </div>
                    <div class="card-body">
                      <div class="card-top">
                        <div class="card-title-group">
                          <h3 class="card-title">{{ project.title }}</h3>
                          <p class="card-desc">{{ project.description }}</p>
                        </div>
                        <div class="card-badges">
                          <span class="badge hot">{{ formatPeriodLabel(project.trend_period) }}</span>
                        </div>
                      </div>
                      <div class="card-footer">
                        <div class="card-tags">
                          <span v-if="project.analysis_data && project.analysis_data.category" class="tag">
                            {{ project.analysis_data.category }}
                          </span>
                          <span v-if="project.language" class="tag">{{ project.language }}</span>
                        </div>
                        <div class="card-meta">
                          <span>★ {{ formatNumber(project.stars) }}</span>
                          <span>⑂ {{ formatNumber(project.forks) }}</span>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

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

    <el-drawer
      :visible.sync="detailVisible"
      size="42%"
      custom-class="project-drawer"
      :with-header="false"
    >
      <div class="drawer-content">
        <div class="drawer-header">
          <div>
            <p class="drawer-repo">{{ selectedProject ? selectedProject.repo_name : '' }}</p>
            <h3 class="drawer-title">{{ selectedProject ? selectedProject.title : '项目详情' }}</h3>
          </div>
          <button class="drawer-close" @click="detailVisible = false">
            <i class="el-icon-close" />
          </button>
        </div>

        <div v-if="detailLoading" class="drawer-loading">
          <i class="el-icon-loading" />
          <p>加载详情中...</p>
        </div>

        <div v-else-if="selectedProject" class="drawer-body">
          <p class="drawer-desc">{{ selectedProject.description }}</p>
          <div class="drawer-meta">
            <span class="meta-chip">语言：{{ selectedProject.language || '未知' }}</span>
            <span class="meta-chip">星标：{{ formatNumber(selectedProject.stars) }}</span>
            <span class="meta-chip">Fork：{{ formatNumber(selectedProject.forks) }}</span>
            <span class="meta-chip">热榜：{{ formatPeriodLabel(selectedProject.trend_period) }}</span>
          </div>

          <div v-if="selectedProject.analysis_data && selectedProject.analysis_data.use_cases" class="drawer-section">
            <h4>适用场景</h4>
            <ul>
              <li v-for="item in selectedProject.analysis_data.use_cases" :key="item">{{ item }}</li>
            </ul>
          </div>

          <div v-if="selectedProject.analysis_data && selectedProject.analysis_data.highlights" class="drawer-section">
            <h4>亮点</h4>
            <ul>
              <li v-for="item in selectedProject.analysis_data.highlights" :key="item">{{ item }}</li>
            </ul>
          </div>

          <div class="drawer-action">
            <a :href="selectedProject.repo_url" target="_blank" rel="noopener noreferrer">访问 GitHub</a>
          </div>
        </div>
      </div>
    </el-drawer>
  </div>
</template>

<script>
import { getGithubProjects, getGithubProjectDetail } from '@/api/ai/github'

export default {
  name: 'UserHome',
  data() {
    return {
      searchText: '',
      activeTagId: 'github',
      tags: [
        { id: 'github', name: 'GitHub 热榜', count: 0 }
      ],
      projects: [],
      listLoading: false,
      listError: '',
      page: 1,
      pageSize: 20,
      hasMore: true,
      isFetchingMore: false,
      detailVisible: false,
      detailLoading: false,
      selectedProject: null
    }
  },
  computed: {
    activeTagLabel() {
      const active = this.tags.find(tag => tag.id === this.activeTagId)
      return active ? active.name : '全部项目'
    },
    filteredProjects() {
      if (this.activeTagId !== 'github') {
        return []
      }
      let result = [...this.projects]

      if (this.searchText) {
        const searchLower = this.searchText.toLowerCase()
        result = result.filter(project => {
          const category = project.analysis_data && project.analysis_data.category
          return [
            project.repo_name,
            project.title,
            project.description,
            project.language,
            category
          ].some(field => field && field.toLowerCase().includes(searchLower))
        })
      }

      return result
    },
    groupedProjects() {
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
        return '该标签暂无数据'
      }
      return '未找到相关项目'
    }
  },
  created() {
    this.fetchProjects({ reset: true })
  },
  methods: {
    selectTag(tagId) {
      this.activeTagId = tagId
      this.searchText = ''
      if (this.$refs.modulesScroll) {
        this.$refs.modulesScroll.scrollTop = 0
      }
      if (tagId === 'github') {
        this.fetchProjects({ reset: true })
      }
    },
    handleSearch() {
      // 搜索逻辑已在 computed 中实现
    },
    handleScroll(event) {
      if (!this.hasMore || this.listLoading || this.isFetchingMore) {
        return
      }
      const target = event.target
      const threshold = 120
      if (target.scrollHeight - target.scrollTop - target.clientHeight < threshold) {
        this.fetchProjects()
      }
    },
    async fetchProjects({ reset = false } = {}) {
      if (reset) {
        this.page = 1
        this.hasMore = true
        this.projects = []
      }
      if (!this.hasMore) {
        return
      }
      if (reset) {
        this.listLoading = true
        this.listError = ''
      } else {
        this.isFetchingMore = true
      }
      try {
        const data = await getGithubProjects({ limit: this.pageSize, page: this.page })
        const list = Array.isArray(data) ? data : []
        this.projects = reset ? list : this.projects.concat(list)
        if (list.length < this.pageSize) {
          this.hasMore = false
        } else {
          this.page += 1
        }
        this.tags = this.tags.map(tag => {
          if (tag.id === 'github') {
            return { ...tag, count: this.projects.length }
          }
          return tag
        })
      } catch (error) {
        if (reset) {
          this.listError = '获取 GitHub 热榜失败，请稍后重试'
          this.projects = []
        } else {
          this.$message.error('加载更多失败，请稍后重试')
        }
      } finally {
        if (reset) {
          this.listLoading = false
        }
        this.isFetchingMore = false
      }
    },
    async openProjectDetail(project) {
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

.modules-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 16px;
}

.modules-title {
  display: flex;
  flex-direction: column;
  gap: 6px;

  h2 {
    font-size: 18px;
    font-weight: 700;
    color: #1f2a44;
    letter-spacing: -0.3px;
  }
}

.search-section {
  width: 340px;
  position: relative;
  display: flex;
  align-items: center;

  i {
    position: absolute;
    left: 14px;
    color: #98a2b3;
    font-size: 15px;
    pointer-events: none;
  }

  .search-input {
    width: 100%;
    height: 38px;
    background: #f5f7fb;
    border: 1px solid #e6eaf2;
    border-radius: 18px;
    padding: 0 14px 0 40px;
    color: #1f2a44;
    font-size: 13px;
    font-family: 'Outfit', sans-serif;
    transition: all 0.2s ease;

    &::placeholder {
      color: #98a2b3;
    }

    &:hover {
      border-color: #d6dce8;
    }

    &:focus {
      outline: none;
      background: #ffffff;
      border-color: #ffd2a6;
      box-shadow: 0 0 0 3px rgba(91, 91, 246, 0.12);
    }
  }
}

.module-count {
  font-size: 12px;
  color: #98a2b3;
  background: #ffffff;
  border: 1px solid #e8ecf3;
  padding: 6px 10px;
  border-radius: 12px;
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
        color: #ffd2a6;
      }
      i {
        color: #ffd2a6;
      }
    }

    .user-avatar {
      width: 30px;
      height: 30px;
      border-radius: 50%;
      border: 2px solid #ffd2a6;
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
}

// 主内容区
.main-content {
  padding: calc(var(--header-height) + 24px) 0 0 24px;
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
.sidebar-categories {
  width: 220px;
  flex-shrink: 0;
  background: #ffffff;
  border: 1px solid #e8ecf3;
  border-radius: 14px;
  padding: 14px;
  position: sticky;
  top: 0;
  height: 100%;
  box-shadow: 0 10px 30px rgba(31, 42, 68, 0.06);
  overflow: hidden;
}

.sidebar-title {
  font-size: 14px;
  font-weight: 700;
  color: #1f2a44;
  padding: 6px 8px 10px;
  border-bottom: 1px solid #eef1f7;
  margin-bottom: 8px;
}

.tag-list {
  display: flex;
  flex-direction: column;
  gap: 4px;
}

.category-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 10px;
  padding: 10px 12px;
  background: transparent;
  border: 1px solid transparent;
  border-radius: 8px;
  color: #6b7280;
  font-size: 13px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  font-family: 'Outfit', sans-serif;
  width: 100%;
  text-align: left;
  position: relative;

  .item-name {
    flex: 1;
  }

  .count {
    font-size: 11px;
    color: #9aa3b2;
    background: #f2f4f8;
    padding: 2px 7px;
    border-radius: 5px;
    font-weight: 600;
    transition: all 0.3s;
  }

  &:hover {
    background: #f6f7fb;
    border-color: #e8ecf3;
    color: #1f2a44;

    .count {
      background: rgba(91, 91, 246, 0.12);
      color: #ffd2a6;
    }
  }

  &.active {
    background: rgba(91, 91, 246, 0.12);
    border-color: rgba(91, 91, 246, 0.35);
    color: #1f2a44;
    box-shadow: 0 6px 14px rgba(91, 91, 246, 0.12);

    &::before {
      content: '';
      position: absolute;
      left: 0;
      top: 25%;
      bottom: 25%;
      width: 3px;
      background: linear-gradient(180deg, #ffd2a6, #6c7cff);
      border-radius: 0 2px 2px 0;
    }

    .count {
      background: linear-gradient(135deg, #ffd2a6, #ffc285);
      color: #ffffff;
      font-weight: 700;
      box-shadow: 0 2px 8px rgba(91, 91, 246, 0.2);
    }
  }
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

.modules-toolbar {
  position: sticky;
  top: 0;
  z-index: 5;
  background: #f6f7fb;
  padding: 16px 0 12px;
  margin-top: -72px;
}

// 模块卡片网格
.modules-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 16px;
}

.date-divider {
  grid-column: 1 / -1;
  display: flex;
  align-items: center;
  gap: 16px;
  margin: 6px 0 4px;
  color: #98a2b3;
  font-size: 12px;
  font-weight: 600;

  &::before,
  &::after {
    content: '';
    flex: 1;
    height: 1px;
    background: #e7ebf2;
  }
}

.module-card {
  background: #ffffff;
  border: 1px solid #e8ecf3;
  border-radius: 14px;
  padding: 16px;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  gap: 14px;
  position: relative;
  box-shadow: 0 10px 30px rgba(31, 42, 68, 0.06);

  &:hover {
    border-color: #ffd2a6;
    transform: translateY(-3px);
    box-shadow: 0 14px 34px rgba(91, 91, 246, 0.14);

    .card-icon {
      background: linear-gradient(135deg, #ffd2a6, #ffc285);
      box-shadow: 0 8px 18px rgba(91, 91, 246, 0.25);
      transform: scale(1.05);

      i {
        color: #ffffff;
        transform: scale(1.1) rotate(5deg);
      }
    }

    .tag {
      background: rgba(91, 91, 246, 0.12);
      border-color: rgba(91, 91, 246, 0.2);
      color: #ffd2a6;
    }
  }

  .card-icon {
    width: 50px;
    height: 50px;
    background: #f3f5ff;
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    transition: all 0.3s ease;

    i {
      font-size: 24px;
      color: #ffd2a6;
      transition: all 0.3s ease;
    }
  }

  .card-body {
    flex: 1;
    min-width: 0;
  }

  .card-top {
    display: flex;
    justify-content: space-between;
    gap: 10px;
    align-items: flex-start;
  }

  .card-title-group {
    min-width: 0;
  }

  .card-title {
    font-size: 15px;
    font-weight: 600;
    color: #1f2a44;
    margin: 0 0 6px;
    letter-spacing: -0.2px;
  }

  .card-desc {
    font-size: 12px;
    color: #6b7280;
    line-height: 1.5;
    margin: 0 0 12px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
    font-weight: 300;
  }

  .card-badges {
    display: flex;
    gap: 6px;
    flex-shrink: 0;

    .badge {
      font-size: 11px;
      font-weight: 600;
      padding: 4px 8px;
      border-radius: 8px;
      border: 1px solid transparent;
      white-space: nowrap;

      &.hot {
        background: #ffe9ef;
        color: #ff6b8b;
        border-color: #ffd2dd;
      }

      &.new {
        background: #fff4db;
        color: #f59e0b;
        border-color: #ffe3b3;
      }
    }
  }

  .card-footer {
    display: flex;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
    justify-content: space-between;

    .card-tags {
      display: flex;
      gap: 4px;
      flex: 1;

      .tag {
        font-size: 10px;
        padding: 3px 8px;
        background: #f2f4f8;
        border: 1px solid #e6eaf2;
        color: #7a869a;
        border-radius: 5px;
        font-weight: 500;
        transition: all 0.3s;
      }
    }

    .card-meta {
      display: flex;
      gap: 10px;
      font-size: 12px;
      color: #98a2b3;
      font-weight: 600;
    }
  }
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

.project-drawer {
  background: #ffffff;
}

.drawer-content {
  padding: 24px;
}

.drawer-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  border-bottom: 1px solid #eef1f7;
  padding-bottom: 16px;
  margin-bottom: 20px;
}

.drawer-repo {
  font-size: 12px;
  color: #98a2b3;
  margin-bottom: 6px;
}

.drawer-title {
  font-size: 20px;
  font-weight: 700;
  color: #1f2a44;
}

.drawer-close {
  border: none;
  background: #f2f4f8;
  border-radius: 8px;
  width: 32px;
  height: 32px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;

  &:hover {
    background: #e8ecf3;
  }
}

.drawer-loading {
  padding: 40px 0;
  text-align: center;
  color: #6b7280;

  i {
    font-size: 30px;
    margin-bottom: 10px;
  }
}

.drawer-body {
  display: flex;
  flex-direction: column;
  gap: 18px;
}

.drawer-desc {
  color: #475467;
  line-height: 1.7;
}

.drawer-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.meta-chip {
  background: #f2f4f8;
  border: 1px solid #e6eaf2;
  color: #6b7280;
  padding: 6px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
}

.drawer-section {
  background: #f9fafc;
  border: 1px solid #eef1f7;
  border-radius: 12px;
  padding: 14px;

  h4 {
    font-size: 14px;
    font-weight: 700;
    color: #1f2a44;
    margin: 0 0 8px;
  }

  p {
    margin: 0;
    color: #5d6472;
    line-height: 1.6;
  }

  ul {
    margin: 0;
    padding-left: 16px;
    color: #5d6472;
    line-height: 1.6;
  }
}

.drawer-action {
  display: flex;
  justify-content: flex-start;

  a {
    background: #ffd2a6;
    color: #ffffff;
    padding: 10px 16px;
    border-radius: 10px;
    font-weight: 600;
    text-decoration: none;
    box-shadow: 0 6px 16px rgba(91, 91, 246, 0.2);
    transition: all 0.2s ease;

    &:hover {
      background: #ffc285;
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

  .sidebar-categories {
    width: 100%;
    position: static;
  }

  .tag-list {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
    gap: 8px;
  }
}

@media (max-width: 768px) {
  .header-content {
    flex-wrap: wrap;
    gap: 12px;
  }

  .modules-toolbar {
    flex-direction: column;
    align-items: flex-start;
  }

  .search-section {
    width: 100%;
  }

  .modules-grid {
    grid-template-columns: 1fr;
  }

  .tag-list {
    grid-template-columns: 1fr;
  }
}
</style>
