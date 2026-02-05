<template>
  <aside class="sidebar-categories">
    <div class="sidebar-title">实时数采</div>
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
