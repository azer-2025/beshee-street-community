<template>
  <div class="auth-page">
    <div class="auth-card">
      <h2>注册账号</h2>
      <p>注册后即可使用用户端服务</p>
      <el-form :model="form" label-position="top">
        <el-form-item label="用户名"><el-input v-model="form.username" /></el-form-item>
        <el-form-item label="密码"><el-input v-model="form.password" type="password" show-password /></el-form-item>
        <el-form-item label="确认密码"><el-input v-model="form.confirmPassword" type="password" show-password /></el-form-item>
        <el-form-item label="失业状态">
          <el-radio-group v-model="form.employmentStatus">
            <el-radio label="0">失业登记</el-radio>
            <el-radio label="2">已就业</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="验证码" v-if="captchaEnabled">
          <div class="captcha-row">
            <el-input v-model="form.code" />
            <img :src="captchaImg" class="captcha" @click="loadCaptcha" alt="captcha" />
          </div>
        </el-form-item>
        <el-button type="primary" class="w-full" :loading="loading" @click="submit">提交注册</el-button>
      </el-form>
      <div class="auth-links single"><router-link to="/login">返回登录</router-link></div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { getCaptchaImage } from "@/api/auth";
import { useAuthStore } from "@/store/auth";

const auth = useAuthStore();
const router = useRouter();
const loading = ref(false);
const captchaImg = ref("");
const captchaEnabled = ref(true);

const form = reactive({ username: "", password: "", confirmPassword: "", employmentStatus: "0", code: "", uuid: "" });

async function loadCaptcha() {
  const res = await getCaptchaImage();
  captchaEnabled.value = res.captchaEnabled !== false;
  captchaImg.value = `data:image/gif;base64,${res.img}`;
  form.uuid = res.uuid;
}

async function submit() {
  if (form.password !== form.confirmPassword) {
    ElMessage.warning("两次密码输入不一致");
    return;
  }
  loading.value = true;
  try {
    await auth.doRegister({
      username: form.username,
      password: form.password,
      employmentStatus: form.employmentStatus,
      code: form.code,
      uuid: form.uuid
    });
    ElMessage.success("注册成功，请登录");
    router.push("/login");
  } finally {
    loading.value = false;
  }
}

loadCaptcha();
</script>
