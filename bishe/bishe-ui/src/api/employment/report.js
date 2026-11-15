import request from "@/utils/request";

export function getReportOverview() {
  return request({
    url: "/employment/admin/report/overview",
    method: "get"
  });
}

export function getAgeReport() {
  return request({
    url: "/employment/admin/report/age",
    method: "get"
  });
}

export function getDistrictReport() {
  return request({
    url: "/employment/admin/report/district",
    method: "get"
  });
}

export function getApplyMonthReport() {
  return request({
    url: "/employment/admin/report/applyMonth",
    method: "get"
  });
}

export function listFlowLogReport(params) {
  return request({
    url: "/employment/admin/report/flowLog/list",
    method: "get",
    params
  });
}

export function getFlowTrendReport(params) {
  return request({
    url: "/employment/admin/report/flowLog/trend",
    method: "get",
    params
  });
}
