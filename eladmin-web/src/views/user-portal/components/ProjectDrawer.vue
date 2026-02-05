<template>
  <el-drawer
    :visible.sync="visibleProxy"
    size="42%"
    custom-class="project-drawer"
    :with-header="false"
  >
    <div class="drawer-content">
      <div class="drawer-header">
        <div>
          <span class="badge">{{ project ? project.repo_name : '' }}</span>
          <h3 class="drawer-title">{{ project ? project.title : '项目详情' }}</h3>
        </div>
        <button class="drawer-close" @click="visibleProxy = false">
          <i class="el-icon-close" />
        </button>
      </div>

      <div v-if="loading" class="drawer-loading">
        <i class="el-icon-loading" />
        <p>加载详情中...</p>
      </div>

      <div v-else-if="project" class="drawer-body">
        <div class="drawer-scroll">
          <div v-if="isBanana && project.image_url" class="drawer-cover" @click="previewVisible = true">
            <img :src="project.image_url" :alt="project.title || ''">
          </div>
          <div v-if="isBanana && project.tags && project.tags.length" class="drawer-tags">
            <span v-for="tag in project.tags" :key="tag" class="tag">{{ tag }}</span>
          </div>
          <div
            v-if="isBanana && (project.category || project.model)"
            class="info-list"
          >
            <div v-if="project.category" class="info-item">
              <span class="label">实时数据</span>
              <span class="value">{{ project.category }}</span>
            </div>
            <div v-if="project.model" class="info-item">
              <span class="label">模型</span>
              <span class="value">{{ project.model }}</span>
            </div>
          </div>

          <div v-if="!isBanana" class="drawer-meta">
            <span class="meta-chip">语言：{{ project.language || '未知' }}</span>
            <span class="meta-chip">星标：{{ formatNumber(project.stars) }}</span>
            <span class="meta-chip">Fork：{{ formatNumber(project.forks) }}</span>
            <span class="meta-chip">热榜：{{ formatPeriodLabel(project.trend_period) }}</span>
          </div>

          <div v-if="project.analysis_data && project.analysis_data.use_cases" class="drawer-section">
            <h4>适用场景</h4>
            <ul>
              <li v-for="item in project.analysis_data.use_cases" :key="item">{{ item }}</li>
            </ul>
          </div>

          <div v-if="project.analysis_data && project.analysis_data.highlights" class="drawer-section">
            <h4>亮点</h4>
            <ul>
              <li v-for="item in project.analysis_data.highlights" :key="item">{{ item }}</li>
            </ul>
          </div>

          <div v-if="isBanana && project.prompt_en" class="drawer-section">
            <div class="section-header">
              <h4>Prompt (EN)</h4>
              <button class="copy-btn" @click="copyText(project.prompt_en)">复制</button>
            </div>
            <p class="prompt-text full-text">{{ project.prompt_en }}</p>
          </div>

          <div v-if="isBanana && project.prompt_zh" class="drawer-section">
            <div class="section-header">
              <h4>Prompt (中文)</h4>
              <button class="copy-btn" @click="copyText(project.prompt_zh)">复制</button>
            </div>
            <p class="prompt-text full-text">{{ project.prompt_zh }}</p>
          </div>
        </div>

        <div v-if="project.repo_url" class="drawer-action">
          <a :href="project.repo_url" target="_blank" rel="noopener noreferrer">访问 GitHub</a>
        </div>
      </div>
    </div>
    <el-dialog
      :visible.sync="previewVisible"
      custom-class="image-preview-dialog"
      :append-to-body="true"
      :show-close="false"
      @opened="resetZoom"
    >
      <div class="preview-container" @wheel.prevent="handleWheel">
        <img
          v-if="project && project.image_url"
          class="preview-image"
          :src="project.image_url"
          :alt="project.title || ''"
          :style="{ transform: `scale(${zoomLevel})` }"
        >
      </div>
    </el-dialog>
  </el-drawer>
</template>

<script>
export default {
  name: 'ProjectDrawer',
  props: {
    visible: {
      type: Boolean,
      default: false
    },
    loading: {
      type: Boolean,
      default: false
    },
    project: {
      type: Object,
      default: null
    },
    formatNumber: {
      type: Function,
      required: true
    },
    formatPeriodLabel: {
      type: Function,
      required: true
    },
    variant: {
      type: String,
      default: 'github'
    }
  },
  data() {
    return {
      previewVisible: false,
      zoomLevel: 1
    }
  },
  computed: {
    visibleProxy: {
      get() {
        return this.visible
      },
      set(value) {
        this.$emit('update:visible', value)
      }
    },
    isBanana() {
      return this.variant === 'banana'
    }
  },
  methods: {
    resetZoom() {
      this.zoomLevel = 1
    },
    zoomIn() {
      this.zoomLevel = Math.min(3, this.zoomLevel + 0.1)
    },
    zoomOut() {
      this.zoomLevel = Math.max(0.3, this.zoomLevel - 0.1)
    },
    handleWheel(event) {
      if (event.deltaY < 0) {
        this.zoomIn()
      } else {
        this.zoomOut()
      }
    },
    async copyText(text) {
      if (!text) {
        return
      }
      try {
        await navigator.clipboard.writeText(text)
        this.$message && this.$message.success('已复制')
      } catch (error) {
        const textarea = document.createElement('textarea')
        textarea.value = text
        textarea.setAttribute('readonly', '')
        textarea.style.position = 'absolute'
        textarea.style.left = '-9999px'
        document.body.appendChild(textarea)
        textarea.select()
        document.execCommand('copy')
        document.body.removeChild(textarea)
        this.$message && this.$message.success('已复制')
      }
    }
  }
}
</script>

<style lang="scss" scoped>
.project-drawer {
  background: var(--bg-secondary, #ffffff);
}

.drawer-content {
  height: 100%;
  display: flex;
  flex-direction: column;
  padding: 24px 24px 30px;
}

.drawer-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  border-bottom: 1px solid var(--border-color, #e2e8f0);
  padding-bottom: 16px;
  margin-bottom: 18px;
}

.drawer-repo {
  font-size: 12px;
  color: var(--text-muted, #64748b);
  margin-bottom: 6px;
  line-height: 1.4;
}

.drawer-title {
  font-size: 20px;
  font-weight: 700;
  color: var(--text-primary, #1e293b);
  line-height: 1.4;
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
.drawer-close {
  border: 1px solid var(--border-color, #e2e8f0);
  background: var(--bg-secondary, #ffffff);
  border-radius: 50%;
  width: 32px;
  height: 32px;
  min-width: 32px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;

  &:hover {
    background: var(--bg-muted, #f1f5f9);
  }
}

.drawer-loading {
  padding: 40px 0;
  text-align: center;
  color: var(--text-muted, #64748b);

  i {
    font-size: 30px;
    margin-bottom: 10px;
  }
}

.drawer-body {
  display: flex;
  flex-direction: column;
  gap: 18px;
  flex: 1;
  min-height: 0;
}

.drawer-scroll {
  flex: 1;
  overflow-y: auto;
  padding-right: 4px;
}

.drawer-cover {
  width: 100%;
  max-height: 220px;
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid var(--border-color, #e2e8f0);
  cursor: zoom-in;

  img {
    width: 100%;
    height: auto;
    max-height: 220px;
    object-fit: contain;
    display: block;
  }
}

.drawer-desc {
  color: var(--text-secondary, #475569);
  line-height: 1.7;
}

.drawer-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;

  .tag {
    font-size: 11px;
    padding: 4px 10px;
    background: var(--bg-muted, #f1f5f9);
    border: 1px solid var(--border-color, #e2e8f0);
    color: var(--text-muted, #64748b);
    border-radius: 999px;
    font-weight: 600;
  }
}

.drawer-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
}

.meta-chip {
  background: var(--bg-muted, #f1f5f9);
  border: 1px solid var(--border-color, #e2e8f0);
  color: var(--text-muted, #64748b);
  padding: 6px 10px;
  border-radius: 999px;
  font-size: 12px;
  font-weight: 600;
}

.info-list {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 8px 16px;
  padding: 12px;
  border-radius: 12px;
  background: var(--bg-primary, #f8fafc);
  border: 1px solid var(--border-color, #e2e8f0);
}

.info-item {
  display: flex;
  gap: 8px;
  font-size: 12px;
  color: var(--text-muted, #64748b);

  .label {
    color: var(--text-muted, #64748b);
    min-width: 60px;
  }

  .value {
    color: var(--text-secondary, #475569);
    word-break: break-word;
  }

  .link {
    color: var(--primary-color, #2563eb);
    text-decoration: none;
  }

  .link:hover {
    text-decoration: underline;
  }
}

.drawer-section {
  background: var(--bg-primary, #f8fafc);
  border: 1px solid var(--border-color, #e2e8f0);
  border-radius: 10px;
  padding: 14px;
  margin-top: 10px;

  h4 {
    font-size: 14px;
    font-weight: 700;
    color: var(--text-primary, #1e293b);
    margin: 0 0 8px;
  }

  p {
    margin: 0;
    color: var(--text-secondary, #475569);
    line-height: 1.75;
    font-size: 14px;
  }

  ul {
    margin: 0;
    padding-left: 16px;
    color: var(--text-secondary, #475569);
    line-height: 1.75;
    font-size: 14px;
  }

  li {
    margin-bottom: 6px;
  }
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 8px;
}

.copy-btn {
  border: 1px solid var(--border-color, #e2e8f0);
  background: var(--bg-secondary, #ffffff);
  color: var(--text-secondary, #475569);
  border-radius: 8px;
  padding: 4px 10px;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    border-color: var(--primary-color, #2563eb);
    color: var(--text-primary, #1e293b);
  }
}

.prompt-text {
  margin: 0;
  color: #5d6472;
  line-height: 1.6;
  white-space: pre-line;
  font-size: 14px;
}

::v-deep .image-preview-dialog {
  display: flex;
  align-items: center;
  justify-content: center;

  &.el-dialog {
    background: transparent !important;
    box-shadow: none !important;
    width: 0;
    max-width: 0vw;
  }

  .el-dialog {
    margin: 0;
    background: transparent !important;
    box-shadow: none !important;
  }

  .el-dialog__header {
    padding: 0;
    height: 0;
    display: none;
  }

  .el-dialog__body {
    padding: 0;
    display: flex;
    align-items: center;
    justify-content: center;
    background: transparent;
  }
}

.preview-image {
  width: auto;
  max-width: 70vw;
  height: auto;
  max-height: 70vh;
  object-fit: contain;
  display: block;
}

.drawer-action {
  display: flex;
  justify-content: flex-start;
  margin-top: auto;
  padding-top: 12px;
  border-top: 1px solid var(--border-color, #e2e8f0);

  a {
    background: var(--primary-color, #2563eb);
    color: #ffffff;
    padding: 8px 16px;
    border-radius: 7px;
    font-weight: 600;
    font-size: 12px;
    text-decoration: none;
    box-shadow: 0 6px 16px rgba(37, 99, 235, 0.2);
    transition: all 0.2s ease;

    &:hover {
      background: var(--primary-dark, #1d4ed8);
    }
  }
}
</style>
