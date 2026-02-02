<script>
import { ADMIN_BASE_PATH } from '@/config/paths'

export default {
  created() {
    const { params, query } = this.$route
    const { path } = params
    // 确保重定向的路径包含后台管理系统的基础路径
    const redirectPath = path.startsWith(ADMIN_BASE_PATH) ? '/' + path : ADMIN_BASE_PATH + '/' + path
    this.$router.replace({ path: redirectPath, query })
  },
  render: function(h) {
    return h() // avoid warning message
  }
}
</script>
