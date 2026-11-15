import axios from "axios";
import { ElMessage } from "element-plus";
import { useAuthStore } from "@/store/auth";

const service = axios.create({
  baseURL: import.meta.env.VITE_API_BASE || "http://localhost:8080",
  timeout: 12000,
  headers: { "Content-Type": "application/json;charset=utf-8" }
});

service.interceptors.request.use((config) => {
  const auth = useAuthStore();
  if (auth.token && config.headers) {
    config.headers.Authorization = `Bearer ${auth.token}`;
  }
  if (config.data instanceof FormData && config.headers) {
    delete config.headers["Content-Type"];
  }
  return config;
});

service.interceptors.response.use(
  (response) => {
    const data = response.data;
    const code = data?.code ?? 200;
    if (code !== 200) {
      ElMessage.error(data?.msg || "Request failed");
      return Promise.reject(new Error(data?.msg || "Request failed"));
    }
    return data;
  },
  (error) => {
    ElMessage.error(error?.response?.data?.msg || error.message || "Network error");
    return Promise.reject(error);
  }
);

export default service;
