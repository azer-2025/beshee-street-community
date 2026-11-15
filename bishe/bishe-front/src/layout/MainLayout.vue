<template>
  <div class="main-layout">
    <header class="shell-header">
      <div class="shell-header-inner">
        <div class="brand-section">
          <div class="brand-logo"><el-icon><Monitor /></el-icon></div>
          <div class="brand-title">街道就业服务</div>
        </div>

        <el-menu :default-active="route.path" class="top-nav" mode="horizontal" router>
          <el-menu-item index="/profile">
            <el-icon><User /></el-icon><span>个人信息</span>
          </el-menu-item>
          <el-menu-item index="/position">
            <el-icon><Suitcase /></el-icon><span>岗位申请</span>
          </el-menu-item>
          <el-menu-item index="/training">
            <el-icon><Reading /></el-icon><span>培训记录</span>
          </el-menu-item>
          <el-menu-item index="/consult">
            <el-icon><ChatDotRound /></el-icon><span>互动咨询</span>
          </el-menu-item>
          <el-menu-item index="/policy">
            <el-icon><Document /></el-icon><span>政策资讯</span>
          </el-menu-item>
        </el-menu>

        <div class="header-actions">
          <div class="user-chip">
            <el-avatar :size="28" :src="avatarUrl" class="chip-avatar">
              <el-icon><UserFilled /></el-icon>
            </el-avatar>
            <span>{{ auth.user?.userName || "未登录" }}</span>
          </div>
          <el-button type="danger" link @click="logout" class="logout-btn">
            <el-icon><SwitchButton /></el-icon>
          </el-button>
        </div>
      </div>
    </header>

    <main class="main-container">
      <div class="page-header-banner">
        <div class="banner-content">
          <h1>{{ currentTitle }}</h1>
          <p>便捷、高效的街道就业一站式服务平台</p>
        </div>
      </div>

      <section class="content-body">
        <router-view />
      </section>
    </main>
  </div>
</template>

<script setup>
import { computed } from "vue";
import { useRoute, useRouter } from "vue-router";
import { useAuthStore } from "@/store/auth";

const route = useRoute();
const router = useRouter();
const auth = useAuthStore();
const apiBase = import.meta.env.VITE_API_BASE || "http://localhost:8080";

const currentTitle = computed(() => route.meta?.title || "就业服务");
const avatarUrl = computed(() => {
  const avatar = auth.user?.avatar;
  if (!avatar) {
    return "";
  }
  if (/^https?:\/\//.test(avatar)) {
    return avatar;
  }
  return `${apiBase}${avatar.startsWith("/") ? "" : "/"}${avatar}`;
});

function logout() {
  auth.logout();
  router.push("/login");
}
</script>
