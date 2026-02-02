/**
 * 路径配置文件
 * 统一管理前端路由路径，避免硬编码
 */

// 后台管理系统的基础路径
// 注意：修改此路径后，需要同步更新 Nginx 配置、后端 CORS 配置等
export const ADMIN_BASE_PATH = '/admin-secure-mgmt-x7k9p2'

// 后台管理系统相关路径
export const ADMIN_PATHS = {
  // 基础路径
  BASE: ADMIN_BASE_PATH,
  // 登录页
  LOGIN: `${ADMIN_BASE_PATH}/login`,
  // 首页/仪表板
  DASHBOARD: `${ADMIN_BASE_PATH}/dashboard`,
  // 个人中心
  USER_CENTER: `${ADMIN_BASE_PATH}/user/center`,
  // 错误页面
  PAGE_404: `${ADMIN_BASE_PATH}/404`,
  PAGE_401: `${ADMIN_BASE_PATH}/401`,
  // 重定向
  REDIRECT: `${ADMIN_BASE_PATH}/redirect`
}

// 用户端相关路径
export const USER_PATHS = {
  // 基础路径
  BASE: '/',
  // 用户登录页（待开发）
  LOGIN: '/user/login',
  // 用户首页（待开发）
  HOME: '/user/home'
}

// 默认导出所有路径配置
export default {
  ADMIN_BASE_PATH,
  ADMIN_PATHS,
  USER_PATHS
}
