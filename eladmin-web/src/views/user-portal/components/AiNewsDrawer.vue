<template>
  <el-drawer
    :visible.sync="visible"
    :with-header="false"
    size="520px"
    custom-class="ai-news-drawer"
  >
    <div class="drawer-content">
      <div class="drawer-header">
        <div class="title-group">
          <span class="badge">AI 报道</span>
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
        <p v-if="newsSummary" class="summary">{{ newsSummary }}</p>
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
      return this.news.ai_title || this.news.title || this.news.headline || this.news.name || 'AI 报道详情'
    },
    newsSummary() {
      return this.news.ai_summary || this.news.summary || this.news.description || this.news.excerpt || ''
    },
    newsContent() {
      return this.news.ai_summary || this.news.content || this.news.body || ''
    },
    newsSource() {
      return this.news.source || this.news.source_name || this.news.publisher || ''
    },
    newsDate() {
      return this.news.published_at || this.news.publishedAt || this.news.created_at || ''
    },
    newsUrl() {
      return this.news.url || this.news.link || ''
    },
    newsCategory() {
      return this.news.ai_category || this.news.category || ''
    },
    newsSentiment() {
      return this.news.ai_sentiment || this.news.sentiment || ''
    },
    newsHighlights() {
      const highlights = this.news.ai_highlights || this.news.highlights || []
      return Array.isArray(highlights) ? highlights : []
    },
    newsKeywords() {
      const keywords = this.news.ai_keywords || this.news.keywords || []
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
  background: rgba(70, 166, 255, 0.12);
  color: #2c86d6;
  font-size: 12px;
  font-weight: 600;
}

.title {
  margin: 10px 0 6px;
  font-size: 20px;
  line-height: 1.4;
  color: #1f2a44;
  word-break: break-word;
}

.meta {
  display: flex;
  gap: 10px;
  color: #98a2b3;
  font-size: 12px;
}

.close-btn {
  border: 1px solid #e6eaf3;
  color: #98a2b3;
}

.drawer-loading {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  color: #98a2b3;
}

.drawer-body {
  flex: 1;
  overflow-y: auto;
}

.summary {
  font-size: 14px;
  line-height: 1.7;
  color: #344054;
  margin-bottom: 18px;
}

.content {
  font-size: 14px;
  line-height: 1.75;
  color: #475467;
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
  background: #f3f5fb;
  color: #4b5565;
  font-size: 12px;
  font-weight: 600;

  &.secondary {
    background: rgba(70, 166, 255, 0.12);
    color: #2c86d6;
  }
}

.section {
  margin-top: 18px;

  h3 {
    font-size: 14px;
    color: #1f2a44;
    margin-bottom: 10px;
  }

  ul {
    padding-left: 18px;
    margin: 0;
    color: #4b5565;
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
  background: #f7f9fc;
  color: #667085;
  font-size: 12px;
  border: 1px solid #e6eaf3;
}

.empty {
  color: #98a2b3;
  font-size: 13px;
}

.actions {
  margin-top: 20px;
}

.link-btn {
  background: #46a6ff;
  border-color: #46a6ff;

  &:hover,
  &:focus {
    background: #3a97f0;
    border-color: #3a97f0;
  }
}
</style>
