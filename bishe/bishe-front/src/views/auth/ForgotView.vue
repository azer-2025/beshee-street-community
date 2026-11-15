<template>
  <div class="auth-page">
    <div class="auth-card">
      <h2>找回密码</h2>
      <p>通过用户名与手机号重置密码</p>
      <el-form :model="form" label-position="top">
        <el-form-item label="用户名"><el-input v-model="form.userName" /></el-form-item>
        <el-form-item label="手机号"><el-input v-model="form.phone" /></el-form-item>
        <el-form-item label="新密码"><el-input v-model="form.newPassword" type="password" show-password /></el-form-item>
        <el-button type="primary" class="w-full" :loading="loading" @click="submit">重置密码</el-button>
      </el-form>
      <div class="auth-links single"><router-link to="/login">返回登录</router-link></div>
    </div>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { useRouter } from "vue-router";
import { ElMessage } from "element-plus";
import { resetPassword } from "@/api/auth";

const router = useRouter();
const loading = ref(false);
const form = reactive({ userName: "", phone: "", newPassword: "" });

async function submit() {
  loading.value = true;
  try {
    await resetPassword(form);
    ElMessage.success("密码重置成功，请重新登录");
    router.push("/login");
  } finally {
    loading.value = false;
  }
}
</script>
