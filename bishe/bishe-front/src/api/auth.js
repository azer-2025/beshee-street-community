import request from "@/utils/request";

export function getCaptchaImage() {
  return request({
    url: "/captchaImage",
    method: "get",
    headers: { isToken: false }
  });
}

export function login(data) {
  return request({
    url: "/login",
    method: "post",
    data
  });
}

export function register(data) {
  return request({
    url: "/register",
    method: "post",
    data
  });
}

export function getCurrentUser() {
  return request({
    url: "/employment/front/currentUser",
    method: "get"
  });
}

export function uploadAvatar(file) {
  const formData = new FormData();
  formData.append("avatarfile", file);
  return request({
    url: "/system/user/profile/avatar",
    method: "post",
    data: formData
  });
}

export function resetPassword(data) {
  return request({
    url: "/employment/front/password/reset",
    method: "post",
    data
  });
}
