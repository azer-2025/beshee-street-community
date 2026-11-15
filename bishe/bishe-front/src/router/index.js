import { createRouter, createWebHistory } from "vue-router";
import { useAuthStore } from "@/store/auth";

const routes = [
  { path: "/login", name: "login", component: () => import("@/views/auth/LoginView.vue") },
  { path: "/register", name: "register", component: () => import("@/views/auth/RegisterView.vue") },
  {
    path: "/",
    component: () => import("@/layout/MainLayout.vue"),
    redirect: "/profile",
    meta: { requiresAuth: true },
    children: [
      { path: "profile", name: "profile", component: () => import("@/views/profile/ProfileView.vue"), meta: { title: "个人信息管理" } },
      { path: "position", name: "position", component: () => import("@/views/position/PositionView.vue"), meta: { title: "岗位申请管理" } },
      { path: "training", name: "training", component: () => import("@/views/training/TrainingView.vue"), meta: { title: "培训记录管理" } },
      { path: "consult", name: "consult", component: () => import("@/views/consult/ConsultView.vue"), meta: { title: "互动咨询管理" } },
      { path: "policy", name: "policy", component: () => import("@/views/policy/PolicyView.vue"), meta: { title: "政策资讯管理" } }
    ]
  },
  { path: "/:pathMatch(.*)*", redirect: "/login" }
];

const router = createRouter({
  history: createWebHistory(),
  routes
});

router.beforeEach(async (to) => {
  const auth = useAuthStore();
  const needAuth = to.matched.some((item) => item.meta.requiresAuth);

  if (!needAuth) {
    if (auth.isLogin && ["/login", "/register"].includes(to.path)) {
      return "/profile";
    }
    return true;
  }

  if (!auth.isLogin) {
    return "/login";
  }

  if (!auth.user) {
    try {
      await auth.fetchUser();
    } catch (e) {
      auth.logout();
      return "/login";
    }
  }

  return true;
});

export default router;
