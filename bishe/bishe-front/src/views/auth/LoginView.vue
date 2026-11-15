<template>
  <div class="auth-page">
    <div class="auth-card">
      <h2>用户登录</h2>
      <p>街道待就业人员管理服务系统</p>
      <el-form :model="form" label-position="top">
        <el-form-item label="用户名"><el-input v-model="form.username" /></el-form-item>
        <el-form-item label="密码"><el-input v-model="form.password" type="password" show-password /></el-form-item>
        <el-form-item label="验证码" v-if="captchaEnabled">
          <div class="captcha-row">
            <el-input v-model="form.code" />
            <img :src="captchaImg" class="captcha" @click="loadCaptcha" alt="captcha" />
          </div>
        </el-form-item>
        <el-button type="primary" class="w-full" @click="submit" :loading="loading">登录</el-button>
      </el-form>
      <div class="auth-links">
        <router-link to="/register">注册账号</router-link>
      </div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { getCaptchaImage } from "@/api/auth";
import { useAuthStore } from "@/store/auth";

const router = useRouter();
const auth = useAuthStore();
const loading = ref(false);
const captchaImg = ref("");
const captchaEnabled = ref(true);

const form = reactive({
  username: "",
  password: "",
  code: "",
  uuid: ""
});

async function loadCaptcha() {
  const res = await getCaptchaImage();
  captchaEnabled.value = res.captchaEnabled !== false;
  captchaImg.value = `data:image/gif;base64,${res.img}`;
  form.uuid = res.uuid;
}

async function submit() {
  loading.value = true;
  try {
    await auth.doLogin({ ...form });
    ElMessage.success("登录成功");
    router.push("/profile");
  } finally {
    loading.value = false;
  }
}

loadCaptcha();
</script>
