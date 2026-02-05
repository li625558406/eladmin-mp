<template>
  <div class="modules-grid" :class="variant">
    <template v-if="showDateDivider && groupedItems.length">
      <div v-for="group in groupedItems" :key="`group-${group.date}`" class="group-wrapper">
        <div class="date-divider">
          <span>{{ group.date }}</span>
        </div>
        <div
          v-for="project in group.items"
          :key="project.id"
          class="module-card"
          :class="variant"
          @click="$emit('select', project)"
        >
          <div class="card-icon">
            <img v-if="project.image_url" :src="project.image_url" alt="" loading="lazy">
            <svg
              v-else
              aria-hidden="true"
              focusable="false"
              class="github-icon"
              viewBox="0 0 24 24"
              width="32"
              height="32"
              fill="currentColor"
              display="inline-block"
              overflow="visible"
              style="vertical-align:text-bottom"
            >
              <path
                d="M12 1C5.923 1 1 5.923 1 12c0 4.867 3.149 8.979 7.521 10.436.55.096.756-.233.756-.522 0-.262-.013-1.128-.013-2.049-2.764.509-3.479-.674-3.699-1.292-.124-.317-.66-1.293-1.127-1.554-.385-.207-.936-.715-.014-.729.866-.014 1.485.797 1.691 1.128.99 1.663 2.571 1.196 3.204.907.096-.715.385-1.196.701-1.471-2.448-.275-5.005-1.224-5.005-5.432 0-1.196.426-2.186 1.128-2.956-.111-.275-.496-1.402.11-2.915 0 0 .921-.288 3.024 1.128a10.193 10.193 0 0 1 2.75-.371c.936 0 1.871.123 2.75.371 2.104-1.43 3.025-1.128 3.025-1.128.605 1.513.221 2.64.111 2.915.701.77 1.127 1.747 1.127 2.956 0 4.222-2.571 5.157-5.019 5.432.399.344.743 1.004.743 2.035 0 1.471-.014 2.654-.014 3.025 0 .289.206.632.756.522C19.851 20.979 23 16.854 23 12c0-6.077-4.922-11-11-11Z"
              />
            </svg>
          </div>
          <div class="card-body">
            <div class="card-top">
              <div class="card-title-group">
                <h3 class="card-title">{{ project.title }}</h3>
                <p class="card-desc">{{ project.short_description || project.description }}</p>
              </div>
              <div class="card-badges">
                <span class="badge hot">{{ formatPeriodLabel(project.trend_period) }}</span>
              </div>
            </div>
            <div class="card-meta">
              <span>★ {{ formatNumber(project.stars) }}</span>
              <span>⑂ {{ formatNumber(project.forks) }}</span>
            </div>
            <div class="card-footer">
              <div class="card-tags">
                <span
                  v-for="tag in (project.tags || []).slice(0, 3)"
                  :key="tag"
                  class="tag"
                >
                  {{ tag }}
                </span>
                <span v-if="project.analysis_data && project.analysis_data.category" class="tag">
                  {{ project.analysis_data.category }}
                </span>
                <span v-if="project.language" class="tag">{{ project.language }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>
    <template v-else>
      <div
        v-for="project in items"
        :key="project.id"
        class="module-card"
        :class="variant"
        @click="$emit('select', project)"
      >
        <template v-if="variant === 'banana'">
          <div class="card-cover">
            <img v-if="project.image_url" :src="project.image_url" alt="" loading="lazy">
            <div v-else class="cover-placeholder">
              <i class="el-icon-picture-outline" />
            </div>
          </div>
          <div class="card-body">
            <h3 class="card-title">{{ project.title }}</h3>
            <p class="card-desc">{{ project.short_description || project.description }}</p>
            <div class="card-tags">
              <span
                v-for="tag in (project.tags || [])"
                :key="tag"
                class="tag"
              >
                {{ tag }}
              </span>
            </div>
          </div>
        </template>
        <template v-else>
          <div class="card-icon">
            <img v-if="project.image_url" :src="project.image_url" alt="" loading="lazy">
            <svg
              v-else
              aria-hidden="true"
              focusable="false"
              class="github-icon"
              viewBox="0 0 24 24"
              width="32"
              height="32"
              fill="currentColor"
              display="inline-block"
              overflow="visible"
              style="vertical-align:text-bottom"
            >
              <path
                d="M12 1C5.923 1 1 5.923 1 12c0 4.867 3.149 8.979 7.521 10.436.55.096.756-.233.756-.522 0-.262-.013-1.128-.013-2.049-2.764.509-3.479-.674-3.699-1.292-.124-.317-.66-1.293-1.127-1.554-.385-.207-.936-.715-.014-.729.866-.014 1.485.797 1.691 1.128.99 1.663 2.571 1.196 3.204.907.096-.715.385-1.196.701-1.471-2.448-.275-5.005-1.224-5.005-5.432 0-1.196.426-2.186 1.128-2.956-.111-.275-.496-1.402.11-2.915 0 0 .921-.288 3.024 1.128a10.193 10.193 0 0 1 2.75-.371c.936 0 1.871.123 2.75.371 2.104-1.43 3.025-1.128 3.025-1.128.605 1.513.221 2.64.111 2.915.701.77 1.127 1.747 1.127 2.956 0 4.222-2.571 5.157-5.019 5.432.399.344.743 1.004.743 2.035 0 1.471-.014 2.654-.014 3.025 0 .289.206.632.756.522C19.851 20.979 23 16.854 23 12c0-6.077-4.922-11-11-11Z"
              />
            </svg>
          </div>
          <div class="card-body">
            <div class="card-top">
              <div class="card-title-group">
                <h3 class="card-title">{{ project.title }}</h3>
                <p class="card-desc">{{ project.short_description || project.description }}</p>
              </div>
              <div class="card-badges">
                <span class="badge hot">{{ formatPeriodLabel(project.trend_period) }}</span>
              </div>
            </div>
            <div class="card-meta">
              <span>★ {{ formatNumber(project.stars) }}</span>
              <span>⑂ {{ formatNumber(project.forks) }}</span>
            </div>
            <div class="card-footer">
              <div class="card-tags">
                <span
                  v-for="tag in (project.tags || []).slice(0, 3)"
                  :key="tag"
                  class="tag"
                >
                  {{ tag }}
                </span>
                <span v-if="project.analysis_data && project.analysis_data.category" class="tag">
                  {{ project.analysis_data.category }}
                </span>
                <span v-if="project.language" class="tag">{{ project.language }}</span>
              </div>
            </div>
          </div>
        </template>
      </div>
    </template>
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
    groupedItems: {
      type: Array,
      default: () => []
    },
    showDateDivider: {
      type: Boolean,
      default: false
    },
    variant: {
      type: String,
      default: 'github'
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

.group-wrapper {
  display: contents;
}

.date-divider {
  grid-column: 1 / -1;
  display: flex;
  align-items: center;
  gap: 16px;
  margin: 12px 0 8px;
  color: var(--text-muted, #64748b);
  font-size: 12px;
  font-weight: 600;

  &::before,
  &::after {
    content: '';
    flex: 1;
    height: 1px;
    background: var(--border-color, #e2e8f0);
  }

  span {
    padding: 4px 10px;
    background: var(--bg-secondary, #ffffff);
    border: 1px solid var(--border-color, #e2e8f0);
    border-radius: 10px;
    color: var(--text-primary, #1e293b);
  }
}

.module-card {
  background: var(--bg-secondary, #ffffff);
  border: 1px solid var(--border-color, #e2e8f0);
  border-radius: 10px;
  padding: 16px;
  cursor: pointer;
  transition: all 0.2s ease;
  display: flex;
  gap: 14px;
  position: relative;
  box-shadow: var(--shadow-sm, 0 10px 30px rgba(31, 42, 68, 0.06));

  &:hover {
    border-color: var(--primary-color, #2563eb);
    transform: translateY(-3px);
    box-shadow: var(--shadow-md, 0 14px 34px rgba(15, 23, 42, 0.1));

    .card-icon {
      background: rgba(37, 99, 235, 0.12);
      box-shadow: 0 8px 18px rgba(37, 99, 235, 0.2);
      transform: scale(1.05);

      i {
        color: var(--primary-color, #2563eb);
        transform: scale(1.1) rotate(5deg);
      }
    }

    .tag {
      background: var(--bg-muted, #f1f5f9);
      border-color: var(--border-color, #e2e8f0);
      color: var(--text-muted, #64748b);
    }
  }

  .card-icon {
    width: 50px;
    height: 50px;
    background: rgba(37, 99, 235, 0.08);
    border-radius: 14px;
    display: flex;
    align-items: center;
    justify-content: center;
    flex-shrink: 0;
    transition: all 0.3s ease;

    .github-icon {
      width: 26px;
      height: 26px;
      opacity: 0.9;
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
    color: var(--text-primary, #1e293b);
    margin: 0 0 6px;
    letter-spacing: -0.2px;
  }

  .card-desc {
    font-size: 12px;
    color: var(--text-secondary, #475569);
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
        background: rgba(37, 99, 235, 0.12);
        color: var(--primary-color, #2563eb);
        border-color: rgba(37, 99, 235, 0.2);
      }

      &.new {
        background: rgba(249, 115, 22, 0.12);
        color: var(--accent-color, #f97316);
        border-color: rgba(249, 115, 22, 0.2);
      }
    }
  }

  .card-footer {
    margin-top: 10px;

    .card-tags {
      display: flex;
      gap: 4px;
      flex-wrap: wrap;

      .tag {
        font-size: 10px;
        padding: 3px 8px;
        background: var(--bg-muted, #f1f5f9);
        border: 1px solid var(--border-color, #e2e8f0);
        color: var(--text-muted, #64748b);
        border-radius: 15px;
        font-weight: 500;
        white-space: nowrap;
      }
    }
  }

  .card-meta {
    display: flex;
    gap: 10px;
    font-size: 12px;
    color: var(--text-muted, #64748b);
    font-weight: 600;
    margin-top: 10px;
  }
}

.module-card.banana {
  flex-direction: column;
  padding: 12px;
  gap: 12px;

  .card-cover {
    width: 100%;
    height: 180px;
    border-radius: 12px;
    overflow: hidden;
    background: transparent;
    border: none;

    img {
      width: 100%;
      height: 100%;
      object-fit: cover;
      display: block;
    }

    .cover-placeholder {
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #c7cdd8;
      font-size: 32px;
    }
  }

  .card-body {
    display: flex;
    flex-direction: column;
    gap: 8px;
  }

  .card-title {
    font-size: 16px;
  }

  .card-desc {
    margin: 0;
    -webkit-line-clamp: 3;
  }

  .card-tags {
    display: flex;
    flex-wrap: wrap;
    gap: 6px;
  }

  .tag {
    width: auto;
    white-space: nowrap;
    font-size: 12px;
    padding: 4px 10px;
    background: #f2f4f8;
    border: 0;
    color: #6b7280;
    border-radius: 10px;
    font-weight: 500;
    line-height: 1;
  }

  .tag::before {
    content: '#';
    margin-right: 2px;
    color: #9aa3b2;
  }

  .tag:hover {
    background: #f2f4f8;
    color: #6b7280;
  }
}

@media (max-width: 768px) {
  .modules-grid {
    grid-template-columns: 1fr;
  }
}
</style>
