<template>
  <div class="modules-toolbar">
    <div class="modules-title">
      <h2>{{ title }}</h2>
      <span class="module-count">{{ count }} 个项目</span>
    </div>
    <div class="search-section">
      <i class="el-icon-search" />
      <input
        :value="value"
        type="text"
        :placeholder="placeholder"
        class="search-input"
        @input="handleInput"
      >
    </div>
  </div>
</template>

<script>
export default {
  name: 'ModulesToolbar',
  props: {
    title: {
      type: String,
      default: ''
    },
    count: {
      type: Number,
      default: 0
    },
    value: {
      type: String,
      default: ''
    },
    placeholder: {
      type: String,
      default: ''
    }
  },
  methods: {
    handleInput(event) {
      const nextValue = event.target.value
      this.$emit('input', nextValue)
      this.$emit('search', nextValue)
    }
  }
}
</script>

<style lang="scss" scoped>
.modules-toolbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  position: sticky;
  top: 0;
  z-index: 5;
  background: var(--bg-primary, #f8fafc);
  padding: 16px 0 12px;
  margin-top: -72px;
}

.modules-title {
  display: flex;
  align-items: center;
  gap: 10px;

  h2 {
    font-size: 18px;
    font-weight: 700;
    color: var(--text-primary, #1e293b);
    letter-spacing: -0.3px;
  }
}

.module-count {
  font-size: 12px;
  color: var(--text-muted, #64748b);
  background: var(--bg-secondary, #ffffff);
  border: 1px solid var(--border-color, #e2e8f0);
  padding: 6px 10px;
  border-radius: 12px;
}

.search-section {
  width: 340px;
  position: relative;
  display: flex;
  align-items: center;

  i {
    position: absolute;
    left: 14px;
    color: var(--text-muted, #64748b);
    font-size: 15px;
    pointer-events: none;
  }

  .search-input {
    width: 100%;
    height: 38px;
    background: var(--bg-secondary, #ffffff);
    border: 1px solid var(--border-color, #e2e8f0);
    border-radius: 18px;
    padding: 0 14px 0 40px;
    color: var(--text-primary, #1e293b);
    font-size: 13px;
    font-family: 'Outfit', sans-serif;
    transition: all 0.2s ease;

    &::placeholder {
      color: var(--text-muted, #64748b);
    }

    &:hover {
      border-color: var(--border-color, #e2e8f0);
    }

    &:focus {
      outline: none;
      background: var(--bg-secondary, #ffffff);
      border-color: var(--primary-color, #2563eb);
      box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
    }
  }
}

@media (max-width: 768px) {
  .modules-toolbar {
    flex-direction: column;
    align-items: flex-start;
  }

  .search-section {
    width: 100%;
  }
}
</style>
