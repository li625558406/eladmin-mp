<template>
  <el-drawer
    :visible.sync="visible"
    :with-header="false"
    size="42%"
    custom-class="ai-news-drawer"
  >
    <div class="drawer-content">
      <div class="drawer-header">
        <div class="title-group">
          <span class="badge">AI 新闻</span>
          <h2 class="title">{{ newsTitle }}</h2>
          <p v-if="newsSource || newsDate" class="meta">
            <span v-if="newsSource" class="source">{{ newsSource }}</span>
            <span v-if="newsDate" class="date">{{ newsDate }}</span>
          </p>
        </div>
        <el-button class="close-btn" icon="el-icon-close" circle @click="close" />
      </div>

      <div v-if="loading" class="drawer-loading">
        <i class="el-icon-loading" />
        <span>正在加载详情...</span>
      </div>

      <div v-else class="drawer-body">
        <div class="drawer-scroll">
          <div v-if="newsContent" class="content" v-html="newsContent" />
          <div v-else-if="!newsSummary" class="empty">暂无详情内容</div>

          <div v-if="newsCategory || newsSentiment" class="meta-tags">
            <span v-if="newsCategory" class="tag">{{ newsCategory }}</span>
            <span v-if="newsSentiment" class="tag secondary">{{ newsSentiment }}</span>
          </div>

          <div v-if="newsHighlights.length" class="section">
            <h3>要点</h3>
            <ul>
              <li v-for="(item, index) in newsHighlights" :key="`highlight-${index}`">{{ item }}</li>
            </ul>
          </div>

          <div v-if="newsKeywords.length" class="section">
            <h3>关键词</h3>
            <div class="keywords">
              <span v-for="(item, index) in newsKeywords" :key="`keyword-${index}`" class="keyword">
                {{ item }}
              </span>
            </div>
          </div>
        </div>

        <div class="actions">
          <el-button
            v-if="newsUrl"
            type="primary"
            class="link-btn"
            @click="openLink"
          >
            前往原文
          </el-button>
        </div>
      </div>
    </div>
  </el-drawer>
</template>

<script>
export default {
  name: 'AiNewsDrawer',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    loading: {
      type: Boolean,
      default: false
    },
    news: {
      type: Object,
      default: () => ({})
    }
  },
  computed: {
    newsTitle() {
      const news = this.news || {}
      return news.ai_title || news.title || news.headline || news.name || 'AI 新闻详情'
    },
    newsSummary() {
      const news = this.news || {}
      return news.ai_summary || news.summary || news.description || news.excerpt || ''
    },
    newsContent() {
      const news = this.news || {}
      return news.ai_summary || news.content || news.body || ''
    },
    newsSource() {
      const news = this.news || {}
      return news.source || news.source_name || news.publisher || ''
    },
    newsDate() {
      const news = this.news || {}
      return news.published_at || news.publishedAt || news.created_at || ''
    },
    newsUrl() {
      const news = this.news || {}
      return news.url || news.link || ''
    },
    newsCategory() {
      const news = this.news || {}
      return news.ai_category || news.category || ''
    },
    newsSentiment() {
      const news = this.news || {}
      return news.ai_sentiment || news.sentiment || ''
    },
    newsHighlights() {
      const news = this.news || {}
      const highlights = news.ai_highlights || news.highlights || []
      return Array.isArray(highlights) ? highlights : []
    },
    newsKeywords() {
      const news = this.news || {}
      const keywords = news.ai_keywords || news.keywords || []
      return Array.isArray(keywords) ? keywords : []
    }
  },
  methods: {
    close() {
      this.$emit('update:visible', false)
    },
    openLink() {
      if (this.newsUrl) {
        window.open(this.newsUrl, '_blank')
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.drawer-content {
  height: 100%;
  display: flex;
  flex-direction: column;
  padding: 24px 24px 30px;
}

.drawer-header {
  display: flex;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 18px;
}

.title-group {
  flex: 1;
  min-width: 0;
}

.badge {
  display: inline-flex;
  align-items: center;
  padding: 4px 10px;
  border-radius: 999px;
  background: rgba(37, 99, 235, 0.12);
  color: var(--primary-color, #2563eb);
  font-size: 12px;
  font-weight: 600;
}

.title {
  margin: 10px 0 6px;
  font-size: 20px;
  line-height: 1.4;
  color: var(--text-primary, #1e293b);
  word-break: break-word;
}

.meta {
  display: flex;
  gap: 10px;
  color: var(--text-muted, #64748b);
  font-size: 12px;
}

.close-btn {
  border: 1px solid var(--border-color, #e2e8f0);
  color: var(--text-muted, #64748b);
  width: 32px;
  height: 32px;
  min-width: 32px;
  padding: 0;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

.drawer-loading {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: var(--text-muted, #64748b);
}

.drawer-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.drawer-scroll {
  flex: 1;
  overflow-y: auto;
  padding-right: 4px;
}

.summary {
  font-size: 14px;
  line-height: 1.7;
  color: var(--text-secondary, #475569);
  margin-bottom: 18px;
}

.content {
  font-size: 14px;
  line-height: 1.75;
  color: var(--text-secondary, #475569);
}

.meta-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
  margin: 16px 0 12px;
}

.tag {
  padding: 4px 10px;
  border-radius: 999px;
  background: var(--bg-muted, #f1f5f9);
  color: var(--text-muted, #64748b);
  font-size: 12px;
  font-weight: 600;

  &.secondary {
    background: rgba(37, 99, 235, 0.12);
    color: var(--primary-color, #2563eb);
  }
}

.section {
  margin-top: 18px;

  h3 {
    font-size: 14px;
    color: var(--text-primary, #1e293b);
    margin-bottom: 10px;
  }

  ul {
    padding-left: 18px;
    margin: 0;
    color: var(--text-secondary, #475569);
    font-size: 13px;
    line-height: 1.6;
  }
}

.keywords {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.keyword {
  padding: 4px 10px;
  border-radius: 8px;
  background: var(--bg-primary, #f8fafc);
  color: var(--text-muted, #64748b);
  font-size: 12px;
  border: 1px solid var(--border-color, #e2e8f0);
}

.empty {
  color: var(--text-muted, #64748b);
  font-size: 13px;
}

.actions {
  margin-top: 12px;
  padding-top: 12px;
  border-top: 1px solid var(--border-color, #e2e8f0);
}

.link-btn {
  background: var(--primary-color, #2563eb);
  border-color: var(--primary-color, #2563eb);
  border-radius: 7px;

  &:hover,
  &:focus {
    background: var(--primary-dark, #1d4ed8);
    border-color: var(--primary-dark, #1d4ed8);
  }
}
</style>
