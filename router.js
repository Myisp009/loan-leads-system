import { createRouter, createWebHistory } from 'vue-router'
import { getCurrentUser } from './utils/supabase'

const routes = [
  {
    path: '/',
    redirect: '/login'
  },
  {
    path: '/login',
    name: 'Login',
    component: () => import('./views/Login.vue'),
    meta: { public: true }
  },
  {
    path: '/staff',
    name: 'Staff',
    component: () => import('./views/Staff.vue'),
    meta: { requiresAuth: true, role: 'staff' }
  },
  {
    path: '/boss',
    name: 'Boss',
    component: () => import('./views/Boss.vue'),
    meta: { requiresAuth: true, role: 'boss' }
  },
  {
    path: '/pool',
    name: 'Pool',
    component: () => import('./views/Pool.vue'),
    meta: { requiresAuth: true, role: 'staff' }
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach(async (to, from, next) => {
  const user = await getCurrentUser()
  
  if (to.meta.public) {
    next()
    return
  }
  
  if (!user) {
    next('/login')
    return
  }
  
  if (to.meta.role && to.meta.role !== user.role) {
    if (user.role === 'boss') {
      next('/boss')
    } else {
      next('/staff')
    }
    return
  }
  
  next()
})

export default router
