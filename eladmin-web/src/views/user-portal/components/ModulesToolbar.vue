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
  margin-bottom: 16px;
  position: sticky;
  top: 0;
  z-index: 5;
  background: #f6f7fb;
  padding: 16px 0 12px;
  margin-top: -72px;
}

.modules-title {
  display: flex;
  flex-direction: column;
  gap: 6px;

  h2 {
    font-size: 18px;
    font-weight: 700;
    color: #1f2a44;
    letter-spacing: -0.3px;
  }
}

.module-count {
  font-size: 12px;
  color: #98a2b3;
  background: #ffffff;
  border: 1px solid #e8ecf3;
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
    color: #98a2b3;
    font-size: 15px;
    pointer-events: none;
  }

  .search-input {
    width: 100%;
    height: 38px;
    background: #f5f7fb;
    border: 1px solid #e6eaf2;
    border-radius: 18px;
    padding: 0 14px 0 40px;
    color: #1f2a44;
    font-size: 13px;
    font-family: 'Outfit', sans-serif;
    transition: all 0.2s ease;

    &::placeholder {
      color: #98a2b3;
    }

    &:hover {
      border-color: #d6dce8;
    }

    &:focus {
      outline: none;
      background: #ffffff;
      border-color: #ffd2a6;
      box-shadow: 0 0 0 3px rgba(91, 91, 246, 0.12);
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
