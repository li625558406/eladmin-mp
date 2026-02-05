<template>
  <aside class="sidebar-categories">
    <div class="sidebar-title">{{ title }}</div>
    <div class="tag-list">
      <button
        v-for="tag in tags"
        :key="tag.id"
        :class="['category-item', { active: activeTagId === tag.id }]"
        @click="$emit('select', tag.id)"
      >
        <span class="item-name">{{ tag.name }}</span>
        <span class="count">{{ tag.count }}</span>
      </button>
    </div>
  </aside>
</template>

<script>
export default {
  name: 'TagSidebar',
  props: {
    title: {
      type: String,
      default: '实时数采'
    },
    tags: {
      type: Array,
      default: () => []
    },
    activeTagId: {
      type: String,
      default: ''
    }
  }
}
</script>

<style lang="scss" scoped>
.sidebar-categories {
  width: 220px;
  flex-shrink: 0;
  background: var(--bg-secondary, #ffffff);
  border: 1px solid var(--border-color, #e2e8f0);
  border-radius: 14px;
  padding: 14px;
  position: sticky;
  top: 0;
  height: 100%;
  box-shadow: var(--shadow-sm, 0 10px 30px rgba(31, 42, 68, 0.06));
  overflow: hidden;
}

.sidebar-title {
  font-size: 14px;
  font-weight: 700;
  color: var(--text-primary, #1e293b);
  padding: 6px 8px 10px;
  border-bottom: 1px solid var(--border-color, #e2e8f0);
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
  color: var(--text-muted, #64748b);
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
    color: var(--text-muted, #64748b);
    background: var(--bg-muted, #f1f5f9);
    padding: 2px 7px;
    border-radius: 5px;
    font-weight: 600;
    transition: all 0.3s;
  }

  &:hover {
    background: var(--bg-muted, #f1f5f9);
    border-color: var(--border-color, #e2e8f0);
    color: var(--text-primary, #1e293b);

    .count {
      background: rgba(37, 99, 235, 0.12);
      color: var(--primary-color, #2563eb);
    }
  }

  &.active {
    background: rgba(37, 99, 235, 0.12);
    border-color: rgba(37, 99, 235, 0.35);
    color: var(--text-primary, #1e293b);
    box-shadow: 0 6px 14px rgba(37, 99, 235, 0.12);

    &::before {
      content: '';
      position: absolute;
      left: 0;
      top: 25%;
      bottom: 25%;
      width: 3px;
      background: linear-gradient(180deg, #93c5fd, #2563eb);
      border-radius: 0 2px 2px 0;
    }

    .count {
      background: var(--primary-color, #2563eb);
      color: #ffffff;
      font-weight: 700;
      box-shadow: 0 2px 8px rgba(37, 99, 235, 0.2);
    }
  }
}

@media (max-width: 1024px) {
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
  .tag-list {
    grid-template-columns: 1fr;
  }
}
</style>
