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
        <p class="drawer-desc">{{ project.description }}</p>
        <div class="drawer-meta">
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

        <div v-if="project.repo_url" class="drawer-action">
          <a :href="project.repo_url" target="_blank" rel="noopener noreferrer">访问 GitHub</a>
        </div>
      </div>
    </div>
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
</style>
