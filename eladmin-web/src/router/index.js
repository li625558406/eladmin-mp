import router, { ADMIN_BASE_PATH } from './routers'
import store from '@/store'
import Config from '@/settings'
import NProgress from 'nprogress' // progress bar
import 'nprogress/nprogress.css'// progress bar style
import { getToken } from '@/utils/auth' // getToken from cookie
import { buildMenus } from '@/api/system/menu'
import { filterAsyncRouter } from '@/store/modules/permission'

NProgress.configure({ showSpinner: false })// NProgress Configuration

// 后台管理系统登录页路径
const ADMIN_LOGIN_PATH = ADMIN_BASE_PATH + '/login'
// 后台管理系统首页路径
const ADMIN_HOME_PATH = ADMIN_BASE_PATH

// 白名单：不需要登录就可以访问的页面
const whiteList = [
  ADMIN_LOGIN_PATH, // 后台登录页
  '/' // 用户端首页（根路径）
]

router.beforeEach((to, from, next) => {
  if (to.meta.title) {
    document.title = to.meta.title + ' - ' + Config.title
  }
  NProgress.start()

  // 判断是否访问后台管理系统
  const isAdminRoute = to.path.startsWith(ADMIN_BASE_PATH)

  if (getToken()) {
    // 已登录且要跳转的页面是登录页
    if (to.path === ADMIN_LOGIN_PATH) {
      next({ path: ADMIN_HOME_PATH })
      NProgress.done()
    } else if (isAdminRoute) {
      // 访问后台管理系统，需要验证权限
      if (store.getters.roles.length === 0) { // 判断当前用户是否已拉取完user_info信息
        store.dispatch('GetInfo').then(() => { // 拉取user_info
          // 动态路由，拉取菜单
          loadMenus(next, to)
        }).catch(() => {
          store.dispatch('LogOut').then(() => {
            location.reload() // 为了重新实例化vue-router对象 避免bug
          })
        })
      // 登录时未拉取 菜单，在此处拉取
      } else if (store.getters.loadMenus) {
        // 修改成false，防止死循环
        store.dispatch('updateLoadMenus')
        loadMenus(next, to)
      } else {
        next()
      }
    } else {
      // 已登录，访问非后台路由（如用户端页面），直接放行
      next()
    }
  } else {
    /* has no token*/
    if (whiteList.indexOf(to.path) !== -1) { // 在免登录白名单，直接进入
      next()
    } else if (isAdminRoute) {
      // 访问后台管理系统但未登录，重定向到后台登录页
      next(`${ADMIN_LOGIN_PATH}?redirect=${to.fullPath}`)
      NProgress.done()
    } else {
      // 访问用户端页面但未登录，可以根据需求决定是否需要登录
      // 这里暂时放行，您后续可以根据用户端的需求修改
      next()
    }
  }
})

export const loadMenus = (next, to) => {
  buildMenus().then(res => {
    const sdata = JSON.parse(JSON.stringify(res))
    const rdata = JSON.parse(JSON.stringify(res))
    const sidebarRoutes = filterAsyncRouter(sdata)
    const rewriteRoutes = filterAsyncRouter(rdata, false, true)
    rewriteRoutes.push({ path: '*', redirect: ADMIN_BASE_PATH + '/404', hidden: true })

    store.dispatch('GenerateRoutes', rewriteRoutes).then(() => { // 存储路由
      router.addRoutes(rewriteRoutes) // 动态添加可访问路由表
      next({ ...to, replace: true })
    })
    store.dispatch('SetSidebarRouters', sidebarRoutes)
  })
}

router.afterEach(() => {
  NProgress.done() // finish progress bar
})
