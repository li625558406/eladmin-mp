import Vue from 'vue'
import Router from 'vue-router'
import Layout from '../layout/index'
import { ADMIN_BASE_PATH } from '@/config/paths'

Vue.use(Router)

// 导出后台管理系统的路径前缀，供其他模块使用
export { ADMIN_BASE_PATH }

export const constantRouterMap = [
  { path: ADMIN_BASE_PATH + '/login',
    meta: { title: '登录', noCache: true },
    component: (resolve) => require(['@/views/login'], resolve),
    hidden: true
  },
  {
    path: ADMIN_BASE_PATH + '/404',
    component: (resolve) => require(['@/views/features/404'], resolve),
    hidden: true
  },
  {
    path: ADMIN_BASE_PATH + '/401',
    component: (resolve) => require(['@/views/features/401'], resolve),
    hidden: true
  },
  {
    path: ADMIN_BASE_PATH + '/redirect',
    component: Layout,
    hidden: true,
    children: [
      {
        path: '/redirect/:path*',
        component: (resolve) => require(['@/views/features/redirect'], resolve)
      }
    ]
  },
  {
    path: ADMIN_BASE_PATH,
    component: Layout,
    redirect: ADMIN_BASE_PATH + '/dashboard',
    children: [
      {
        path: 'dashboard',
        component: (resolve) => require(['@/views/home'], resolve),
        name: 'Dashboard',
        meta: { title: '首页', icon: 'index', affix: true, noCache: true }
      }
    ]
  },
  {
    path: ADMIN_BASE_PATH + '/user',
    component: Layout,
    hidden: true,
    redirect: 'noredirect',
    children: [
      {
        path: 'center',
        component: (resolve) => require(['@/views/system/user/center'], resolve),
        name: '个人中心',
        meta: { title: '个人中心' }
      }
    ]
  },
  // 用户端路由
  {
    path: '/',
    redirect: '/user/login',
    hidden: true
  },
  {
    path: '/user',
    component: (resolve) => require(['@/views/user-portal'], resolve),
    redirect: '/user/login',
    hidden: true
  },
  {
    path: '/user/login',
    component: (resolve) => require(['@/views/user-portal/login'], resolve),
    meta: { title: 'KONUS AI - 用户登录', noCache: true },
    hidden: true
  },
  {
    path: '/user/home',
    component: (resolve) => require(['@/views/user-portal/home'], resolve),
    meta: { title: 'KONUS AI - 用户首页', noCache: true },
    hidden: true
  }
]

export default new Router({
  // mode: 'hash',
  mode: 'history',
  scrollBehavior: () => ({ y: 0 }),
  routes: constantRouterMap
})
