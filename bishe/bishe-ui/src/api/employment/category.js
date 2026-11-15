import request from "@/utils/request";

export function listCategory(query) {
  return request({
    url: "/employment/admin/category/list",
    method: "get",
    params: query
  });
}

export function getCategory(categoryId) {
  return request({
    url: `/employment/admin/category/${categoryId}`,
    method: "get"
  });
}

export function addCategory(data) {
  return request({
    url: "/employment/admin/category",
    method: "post",
    data
  });
}

export function updateCategory(data) {
  return request({
    url: "/employment/admin/category",
    method: "put",
    data
  });
}

export function delCategory(categoryIds) {
  return request({
    url: `/employment/admin/category/${categoryIds}`,
    method: "delete"
  });
}
