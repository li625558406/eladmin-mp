<template>
  <div class="modules-grid">
    <div
      v-for="project in items"
      :key="project.id"
      class="module-card"
      @click="$emit('select', project)"
    >
      <div class="card-icon">
        <img v-if="project.image_url" :src="project.image_url" alt="" loading="lazy">
        <i v-else class="el-icon-star-on" />
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
</template>

<script>
export default {
  name: 'ModulesGrid',
  props: {
    items: {
      type: Array,
      default: () => []
    },
    formatNumber: {
      type: Function,
      required: true
    },
    formatPeriodLabel: {
      type: Function,
      required: true
    }
  }
}
</script>

<style lang="scss" scoped>
.modules-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
  gap: 16px;
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

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      border-radius: 12px;
      display: block;
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

@media (max-width: 768px) {
  .modules-grid {
    grid-template-columns: 1fr;
  }
}
</style>
