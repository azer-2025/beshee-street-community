import request from "@/utils/request";

export function getRolePermissionReport() {
  return request({
    url: "/employment/admin/permission/roles",
    method: "get"
  });
}

export function getMenuPermissionReport() {
  return request({
    url: "/employment/admin/permission/menus",
    method: "get"
  });
}
