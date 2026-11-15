import request from "@/utils/request";

export function listPosition(query) {
  return request({
    url: "/employment/admin/position/list",
    method: "get",
    params: query
  });
}

export function addPosition(data) {
  return request({
    url: "/employment/admin/position",
    method: "post",
    data
  });
}

export function updatePosition(data) {
  return request({
    url: "/employment/admin/position",
    method: "put",
    data
  });
}

export function auditPosition(data) {
  return request({
    url: "/employment/admin/position/audit",
    method: "put",
    data
  });
}

export function delPosition(positionIds) {
  return request({
    url: `/employment/admin/position/${positionIds}`,
    method: "delete"
  });
}

export function listTraining(query) {
  return request({
    url: "/employment/admin/training/list",
    method: "get",
    params: query
  });
}

export function addTraining(data) {
  return request({
    url: "/employment/admin/training",
    method: "post",
    data
  });
}

export function updateTraining(data) {
  return request({
    url: "/employment/admin/training",
    method: "put",
    data
  });
}

export function auditTraining(data) {
  return request({
    url: "/employment/admin/training/audit",
    method: "put",
    data
  });
}

export function delTraining(trainingIds) {
  return request({
    url: `/employment/admin/training/${trainingIds}`,
    method: "delete"
  });
}

export function listTrainingRecord(query) {
  return request({
    url: "/employment/admin/trainingRecord/list",
    method: "get",
    params: query
  });
}

export function getTrainingRecord(recordId) {
  return request({
    url: `/employment/admin/trainingRecord/${recordId}`,
    method: "get"
  });
}

export function addTrainingRecord(data) {
  return request({
    url: "/employment/admin/trainingRecord",
    method: "post",
    data
  });
}

export function updateTrainingRecord(data) {
  return request({
    url: "/employment/admin/trainingRecord",
    method: "put",
    data
  });
}

export function delTrainingRecord(recordIds) {
  return request({
    url: `/employment/admin/trainingRecord/${recordIds}`,
    method: "delete"
  });
}

export function updateTrainingRecordStatus(data) {
  return request({
    url: "/employment/admin/trainingRecord/status",
    method: "put",
    data
  });
}

export function listConsult(query) {
  return request({
    url: "/employment/admin/consult/list",
    method: "get",
    params: query
  });
}

export function addConsult(data) {
  return request({
    url: "/employment/admin/consult",
    method: "post",
    data
  });
}

export function updateConsult(data) {
  return request({
    url: "/employment/admin/consult",
    method: "put",
    data
  });
}

export function auditConsult(data) {
  return request({
    url: "/employment/admin/consult/audit",
    method: "put",
    data
  });
}

export function replyConsult(data) {
  return request({
    url: "/employment/admin/consult/reply",
    method: "put",
    data
  });
}

export function delConsult(consultIds) {
  return request({
    url: `/employment/admin/consult/${consultIds}`,
    method: "delete"
  });
}

export function listPolicy(query) {
  return request({
    url: "/employment/admin/policy/list",
    method: "get",
    params: query
  });
}

export function addPolicy(data) {
  return request({
    url: "/employment/admin/policy",
    method: "post",
    data
  });
}

export function updatePolicy(data) {
  return request({
    url: "/employment/admin/policy",
    method: "put",
    data
  });
}

export function auditPolicy(data) {
  return request({
    url: "/employment/admin/policy/audit",
    method: "put",
    data
  });
}

export function delPolicy(policyIds) {
  return request({
    url: `/employment/admin/policy/${policyIds}`,
    method: "delete"
  });
}

export function listApply(query) {
  return request({
    url: "/employment/admin/apply/list",
    method: "get",
    params: query
  });
}

export function addApply(data) {
  return request({
    url: "/employment/admin/apply",
    method: "post",
    data
  });
}

export function updateApply(data) {
  return request({
    url: "/employment/admin/apply",
    method: "put",
    data
  });
}

export function updateApplyStatus(data) {
  return request({
    url: "/employment/admin/apply/status",
    method: "put",
    data
  });
}

export function delApply(applyIds) {
  return request({
    url: `/employment/admin/apply/${applyIds}`,
    method: "delete"
  });
}
