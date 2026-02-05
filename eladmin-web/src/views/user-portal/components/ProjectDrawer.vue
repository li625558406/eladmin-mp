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
          <p class="drawer-repo">{{ project ? project.repo_name : '' }}</p>
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
            <span class="label">实时数采</span>
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

.drawer-cover {
  width: 100%;
  max-height: 220px;
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid #eef1f7;
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
  color: #475467;
  line-height: 1.7;
}

.drawer-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;

  .tag {
    font-size: 11px;
    padding: 4px 10px;
    background: #f2f4f8;
    border: 1px solid #e6eaf2;
    color: #7a869a;
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
  background: #f2f4f8;
  border: 1px solid #e6eaf2;
  color: #6b7280;
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
  background: #f9fafc;
  border: 1px solid #eef1f7;
}

.info-item {
  display: flex;
  gap: 8px;
  font-size: 12px;
  color: #6b7280;

  .label {
    color: #98a2b3;
    min-width: 60px;
  }

  .value {
    color: #475467;
    word-break: break-word;
  }

  .link {
    color: #5b5bf6;
    text-decoration: none;
  }

  .link:hover {
    text-decoration: underline;
  }
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

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  margin-bottom: 8px;
}

.copy-btn {
  border: 1px solid #e6eaf2;
  background: #ffffff;
  color: #475467;
  border-radius: 8px;
  padding: 4px 10px;
  font-size: 12px;
  cursor: pointer;
  transition: all 0.2s ease;

  &:hover {
    border-color: #ffd2a6;
    color: #1f2a44;
  }
}

.prompt-text {
  margin: 0;
  color: #5d6472;
  line-height: 1.6;
  white-space: pre-line;
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
</style>
