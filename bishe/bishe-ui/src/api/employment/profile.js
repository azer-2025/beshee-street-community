import request from "@/utils/request";

export function listProfile(query) {
  return request({
    url: "/employment/admin/profile/list",
    method: "get",
    params: query
  });
}

export function getProfile(profileId) {
  return request({
    url: `/employment/admin/profile/${profileId}`,
    method: "get"
  });
}

export function addProfile(data) {
  return request({
    url: "/employment/admin/profile",
    method: "post",
    data
  });
}

export function updateProfile(data) {
  return request({
    url: "/employment/admin/profile",
    method: "put",
    data
  });
}

export function auditProfile(data) {
  return request({
    url: "/employment/admin/profile/audit",
    method: "put",
    data
  });
}

export function delProfile(profileIds) {
  return request({
    url: `/employment/admin/profile/${profileIds}`,
    method: "delete"
  });
}
