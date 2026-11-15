import request from "@/utils/request";

export function getProfile() {
  return request({ url: "/employment/front/profile", method: "get" });
}

export function saveProfile(data) {
  return request({ url: "/employment/front/profile", method: "put", data });
}

export function getDictByType(dictType) {
  return request({ url: `/system/dict/data/type/${dictType}`, method: "get" });
}

export function uploadCommonImage(file) {
  const formData = new FormData();
  formData.append("file", file);
  return request({ url: "/common/upload/image", method: "post", data: formData });
}

export function uploadCommonFile(file) {
  const formData = new FormData();
  formData.append("file", file);
  return request({ url: "/common/upload", method: "post", data: formData });
}

export function getCategories(categoryType) {
  return request({ url: `/employment/front/categories/${categoryType}`, method: "get" });
}

export function getPositions(params) {
  return request({ url: "/employment/front/positions/list", method: "get", params });
}

export function applyPosition(data) {
  return request({ url: "/employment/front/positions/apply", method: "post", data });
}

export function getMyApplies(params) {
  return request({ url: "/employment/front/positions/myApply", method: "get", params });
}

export function getTrainings(params) {
  return request({ url: "/employment/front/trainings/list", method: "get", params });
}

export function signupTraining(trainingId) {
  return request({ url: `/employment/front/trainings/signup/${trainingId}`, method: "post" });
}

export function getMyTrainingRecords(params) {
  return request({ url: "/employment/front/trainings/myRecords", method: "get", params });
}

export function getMyConsultations(params) {
  return request({ url: "/employment/front/consultations/my", method: "get", params });
}

export function addConsultation(data) {
  return request({ url: "/employment/front/consultations", method: "post", data });
}

export function getPolicies(params) {
  return request({ url: "/employment/front/policies/list", method: "get", params });
}

export function getPolicyDetail(policyId) {
  return request({ url: `/employment/front/policies/${policyId}`, method: "get" });
}
