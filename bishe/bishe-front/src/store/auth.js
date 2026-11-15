import { defineStore } from "pinia";
import { getCurrentUser, login, register } from "@/api/auth";

const TOKEN_KEY = "emp_front_token";

export const useAuthStore = defineStore("auth", {
  state: () => ({
    token: localStorage.getItem(TOKEN_KEY) || "",
    user: null
  }),
  getters: {
    isLogin: (state) => Boolean(state.token)
  },
  actions: {
    async doLogin(payload) {
      const res = await login(payload);
      this.token = res.token;
      localStorage.setItem(TOKEN_KEY, this.token);
      await this.fetchUser();
    },
    async doRegister(payload) {
      await register(payload);
    },
    async fetchUser() {
      if (!this.token) return;
      const res = await getCurrentUser();
      this.user = res.data;
    },
    logout() {
      this.token = "";
      this.user = null;
      localStorage.removeItem(TOKEN_KEY);
    }
  }
});
