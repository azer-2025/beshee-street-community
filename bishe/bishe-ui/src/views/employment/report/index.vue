<template>
  <div class="app-container report-page">
    <el-row :gutter="16" class="mb16">
      <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="item in cards" :key="item.key">
        <el-card shadow="hover" class="metric-card">
          <div class="metric-title">{{ item.title }}</div>
          <div class="metric-value">{{ item.value }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-card shadow="never" class="mb16">
      <template #header>
        <span>年龄结构分析</span>
      </template>
      <div class="age-row" v-for="row in ageRows" :key="row.name">
        <div class="age-label">{{ row.name }}</div>
        <el-progress :percentage="calcPercent(row.value)" :stroke-width="18" :text-inside="true">
          <span>{{ row.value }} 人</span>
        </el-progress>
      </div>
      <el-empty v-if="ageRows.length === 0" description="暂无数据" />
    </el-card>

    <el-row :gutter="16" class="mb16">
      <el-col :xs="24" :lg="12">
        <el-card shadow="never">
          <template #header>
            <span>辖区就业结构图</span>
          </template>
          <div ref="districtChartRef" class="report-chart" />
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="12">
        <el-card shadow="never">
          <template #header>
            <span>月度申请/录用趋势</span>
          </template>
          <div ref="monthChartRef" class="report-chart" />
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="16">
      <el-col :xs="24" :lg="12">
        <el-card shadow="never" class="mb16">
          <template #header>
            <span>辖区失业率</span>
          </template>
          <el-table :data="districtRows" v-loading="loadingDistrict" size="small">
            <el-table-column label="辖区" prop="deptName" min-width="120" />
            <el-table-column label="档案总数" prop="profileTotal" width="100" align="center" />
            <el-table-column label="待就业" prop="unemployedTotal" width="100" align="center" />
            <el-table-column label="已就业" prop="employedTotal" width="100" align="center" />
            <el-table-column label="失业率" width="110" align="center">
              <template #default="scope">{{ formatPercent(scope.row.unemploymentRatePct) }}</template>
            </el-table-column>
          </el-table>
          <el-empty v-if="districtRows.length === 0" description="暂无数据" />
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="12">
        <el-card shadow="never" class="mb16">
          <template #header>
            <span>月度就业成功率</span>
          </template>
          <el-table :data="monthRows" v-loading="loadingMonth" size="small">
            <el-table-column label="月份" prop="statMonth" width="110" align="center" />
            <el-table-column label="申请数" prop="applyTotal" width="90" align="center" />
            <el-table-column label="录用数" prop="hiredTotal" width="90" align="center" />
            <el-table-column label="成功率" align="center">
              <template #default="scope">{{ formatPercent(scope.row.hireRatePct) }}</template>
            </el-table-column>
          </el-table>
          <el-empty v-if="monthRows.length === 0" description="暂无数据" />
        </el-card>
      </el-col>
    </el-row>

    <el-card shadow="never">
      <template #header>
        <div class="report-head">
          <span>就业服务流程追踪</span>
          <div class="report-head-actions">
            <el-tag type="info">联动审计</el-tag>
            <el-button
              type="warning"
              plain
              icon="Download"
              v-hasPermi="['employment:report:export']"
              @click="handleFlowExport"
            >
              导出
            </el-button>
          </div>
        </div>
      </template>
      <el-form :inline="true" :model="flowQuery" class="flow-filter">
        <el-form-item label="业务类型">
          <el-select v-model="flowQuery.bizType" placeholder="全部" clearable style="width: 140px">
            <el-option label="档案" value="PROFILE" />
            <el-option label="申请" value="APPLY" />
            <el-option label="培训" value="TRAINING" />
            <el-option label="咨询" value="CONSULT" />
            <el-option label="政策" value="POLICY" />
          </el-select>
        </el-form-item>
        <el-form-item label="动作类型">
          <el-select v-model="flowQuery.actionType" placeholder="全部" clearable style="width: 140px">
            <el-option label="新增" value="CREATE" />
            <el-option label="更新" value="UPDATE" />
            <el-option label="审核" value="AUDIT" />
            <el-option label="回复" value="REPLY" />
            <el-option label="状态变更" value="STATUS_CHANGE" />
          </el-select>
        </el-form-item>
        <el-form-item label="目标用户">
          <el-input v-model="flowQuery.userName" clearable placeholder="用户名" style="width: 140px" />
        </el-form-item>
        <el-form-item label="操作人">
          <el-input v-model="flowQuery.operatorName" clearable placeholder="操作人" style="width: 140px" />
        </el-form-item>
        <el-form-item label="时间范围">
          <el-date-picker
            v-model="flowDateRange"
            type="datetimerange"
            value-format="YYYY-MM-DD HH:mm:ss"
            range-separator="-"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            style="width: 320px"
          />
        </el-form-item>
        <el-form-item label="趋势粒度">
          <el-radio-group v-model="flowTrendType" @change="loadFlowTrend">
            <el-radio-button label="day">按日</el-radio-button>
            <el-radio-button label="week">按周</el-radio-button>
          </el-radio-group>
        </el-form-item>
        <el-form-item>
          <el-button type="primary" @click="handleFlowQuery">筛选</el-button>
          <el-button @click="resetFlowQuery">重置</el-button>
        </el-form-item>
      </el-form>
      <div v-loading="loadingFlowTrend">
        <div ref="flowTrendChartRef" class="report-chart flow-trend-chart" />
      </div>
      <el-table :data="flowRows" v-loading="loadingFlow" size="small">
        <el-table-column label="时间" prop="operateTime" width="165" />
        <el-table-column label="业务类型" width="110" align="center">
          <template #default="scope">
            <el-tag :type="bizTagType(scope.row.bizType)">{{ formatBizType(scope.row.bizType) }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="动作" width="110" align="center">
          <template #default="scope">{{ formatActionType(scope.row.actionType) }}</template>
        </el-table-column>
        <el-table-column label="目标用户" prop="userName" width="120" />
        <el-table-column label="操作人" prop="operatorName" width="120" />
        <el-table-column label="状态流转" min-width="220" :show-overflow-tooltip="true">
          <template #default="scope">
            {{ scope.row.fromStatus || "-" }} -> {{ scope.row.toStatus || "-" }}
          </template>
        </el-table-column>
        <el-table-column label="动作详情" prop="actionDetail" min-width="260" :show-overflow-tooltip="true" />
      </el-table>
      <pagination
        v-show="flowTotal > 0"
        :total="flowTotal"
        v-model:page="flowQuery.pageNum"
        v-model:limit="flowQuery.pageSize"
        @pagination="loadFlowLog"
      />
      <el-empty v-if="flowRows.length === 0" description="暂无流程日志" />
    </el-card>
  </div>
</template>

<script setup name="EmploymentReport">
import { getAgeReport, getApplyMonthReport, getDistrictReport, getFlowTrendReport, listFlowLogReport, getReportOverview } from "@/api/employment/report";
import * as echarts from "echarts";

const { proxy } = getCurrentInstance();
const overview = ref({});
const ageRows = ref([]);
const districtRows = ref([]);
const monthRows = ref([]);
const flowRows = ref([]);
const flowTotal = ref(0);
const flowTrendRows = ref([]);
const flowDateRange = ref([]);
const flowTrendType = ref("day");
const flowQuery = reactive({
  bizType: "",
  actionType: "",
  userName: "",
  operatorName: "",
  pageNum: 1,
  pageSize: 10
});
const loadingDistrict = ref(false);
const loadingMonth = ref(false);
const loadingFlow = ref(false);
const loadingFlowTrend = ref(false);
const districtChartRef = ref(null);
const monthChartRef = ref(null);
const flowTrendChartRef = ref(null);
let districtChartInstance;
let monthChartInstance;
let flowTrendChartInstance;

function formatPercent(value) {
  const num = Number(value);
  if (Number.isNaN(num)) {
    return "0%";
  }
  return `${num.toFixed(2)}%`;
}

const cards = computed(() => [
  { key: "profileCount", title: "人员档案总数", value: overview.value.profileCount || 0 },
  { key: "unemployedCount", title: "在库待就业人数", value: overview.value.unemployedCount || 0 },
  { key: "employedCount", title: "已就业人数", value: overview.value.employedCount || 0 },
  { key: "unemploymentRatePct", title: "失业率", value: formatPercent(overview.value.unemploymentRatePct) },
  { key: "applyCount", title: "岗位申请总数", value: overview.value.applyCount || 0 },
  { key: "employmentSuccessRatePct", title: "就业成功率", value: formatPercent(overview.value.employmentSuccessRatePct) },
  { key: "consultReplyRatePct", title: "咨询回复率", value: formatPercent(overview.value.consultReplyRatePct) },
  { key: "policyCount", title: "有效政策数", value: overview.value.policyCount || 0 }
]);

function calcPercent(value) {
  const max = Math.max(...ageRows.value.map((item) => item.value || 0), 1);
  return Math.round(((value || 0) / max) * 100);
}

function formatBizType(value) {
  const map = {
    PROFILE: "档案",
    APPLY: "申请",
    TRAINING: "培训",
    CONSULT: "咨询",
    POLICY: "政策"
  };
  return map[value] || (value || "-");
}

function bizTagType(value) {
  const map = {
    PROFILE: "primary",
    APPLY: "success",
    TRAINING: "warning",
    CONSULT: "info",
    POLICY: "danger"
  };
  return map[value] || "info";
}

function formatActionType(value) {
  const map = {
    CREATE: "新增",
    UPDATE: "更新",
    AUDIT: "审核",
    REPLY: "回复",
    STATUS_CHANGE: "状态变更"
  };
  return map[value] || (value || "-");
}

function buildDistrictChart() {
  if (!districtChartRef.value) {
    return;
  }
  if (!districtChartInstance) {
    districtChartInstance = echarts.init(districtChartRef.value);
  }
  const xData = districtRows.value.map((item) => item.deptName || "-");
  const unemployedData = districtRows.value.map((item) => Number(item.unemployedTotal || 0));
  const employedData = districtRows.value.map((item) => Number(item.employedTotal || 0));
  const rateData = districtRows.value.map((item) => Number(item.unemploymentRatePct || 0));
  districtChartInstance.setOption({
    tooltip: { trigger: "axis" },
    legend: { data: ["待就业", "已就业", "失业率"] },
    grid: { left: "3%", right: "4%", bottom: "3%", containLabel: true },
    xAxis: [{ type: "category", data: xData }],
    yAxis: [
      { type: "value", name: "人数" },
      { type: "value", name: "失业率(%)", min: 0, max: 100 }
    ],
    series: [
      { name: "待就业", type: "bar", data: unemployedData, barMaxWidth: 28 },
      { name: "已就业", type: "bar", data: employedData, barMaxWidth: 28 },
      { name: "失业率", type: "line", yAxisIndex: 1, data: rateData, smooth: true }
    ]
  });
}

function buildMonthChart() {
  if (!monthChartRef.value) {
    return;
  }
  if (!monthChartInstance) {
    monthChartInstance = echarts.init(monthChartRef.value);
  }
  const sorted = [...monthRows.value].sort((a, b) => String(a.statMonth || "").localeCompare(String(b.statMonth || "")));
  const xData = sorted.map((item) => item.statMonth || "-");
  const applyData = sorted.map((item) => Number(item.applyTotal || 0));
  const hiredData = sorted.map((item) => Number(item.hiredTotal || 0));
  const rateData = sorted.map((item) => Number(item.hireRatePct || 0));
  monthChartInstance.setOption({
    tooltip: { trigger: "axis" },
    legend: { data: ["申请数", "录用数", "成功率"] },
    grid: { left: "3%", right: "4%", bottom: "3%", containLabel: true },
    xAxis: [{ type: "category", data: xData }],
    yAxis: [
      { type: "value", name: "数量" },
      { type: "value", name: "成功率(%)", min: 0, max: 100 }
    ],
    series: [
      { name: "申请数", type: "bar", data: applyData, barMaxWidth: 28 },
      { name: "录用数", type: "bar", data: hiredData, barMaxWidth: 28 },
      { name: "成功率", type: "line", yAxisIndex: 1, data: rateData, smooth: true }
    ]
  });
}

function handleResize() {
  districtChartInstance?.resize();
  monthChartInstance?.resize();
  flowTrendChartInstance?.resize();
}

function buildFlowTrendChart() {
  if (!flowTrendChartRef.value) {
    return;
  }
  if (!flowTrendChartInstance) {
    flowTrendChartInstance = echarts.init(flowTrendChartRef.value);
  }
  const sorted = [...flowTrendRows.value].sort((a, b) => String(a.statTime || "").localeCompare(String(b.statTime || "")));
  const xData = sorted.map((item) => item.statTime || "-");
  const totalData = sorted.map((item) => Number(item.totalCount || 0));
  const profileData = sorted.map((item) => Number(item.profileCount || 0));
  const applyData = sorted.map((item) => Number(item.applyCount || 0));
  const trainingData = sorted.map((item) => Number(item.trainingCount || 0));
  const consultData = sorted.map((item) => Number(item.consultCount || 0));
  const policyData = sorted.map((item) => Number(item.policyCount || 0));
  flowTrendChartInstance.setOption({
    tooltip: { trigger: "axis" },
    legend: { data: ["总量", "档案", "申请", "培训", "咨询", "政策"] },
    grid: { left: "3%", right: "4%", bottom: "3%", containLabel: true },
    xAxis: [{ type: "category", data: xData }],
    yAxis: [{ type: "value", name: "次数" }],
    series: [
      { name: "总量", type: "line", data: totalData, smooth: true, lineStyle: { width: 3 } },
      { name: "档案", type: "line", data: profileData, smooth: true },
      { name: "申请", type: "line", data: applyData, smooth: true },
      { name: "培训", type: "line", data: trainingData, smooth: true },
      { name: "咨询", type: "line", data: consultData, smooth: true },
      { name: "政策", type: "line", data: policyData, smooth: true }
    ]
  });
}

function buildFlowQueryParams(withPage = true) {
  const params = {
    bizType: flowQuery.bizType || undefined,
    actionType: flowQuery.actionType || undefined,
    userName: flowQuery.userName || undefined,
    operatorName: flowQuery.operatorName || undefined
  };
  if (withPage) {
    params.pageNum = flowQuery.pageNum;
    params.pageSize = flowQuery.pageSize;
  }
  if (flowDateRange.value?.length === 2) {
    params.params = {
      beginTime: flowDateRange.value[0],
      endTime: flowDateRange.value[1]
    };
  }
  return params;
}

function loadFlowLog() {
  loadingFlow.value = true;
  listFlowLogReport(buildFlowQueryParams()).then((res) => {
    flowRows.value = res.rows || [];
    flowTotal.value = res.total || 0;
  }).finally(() => {
    loadingFlow.value = false;
  });
}

function loadFlowTrend() {
  loadingFlowTrend.value = true;
  getFlowTrendReport({
    ...buildFlowQueryParams(false),
    statType: flowTrendType.value
  }).then((res) => {
    flowTrendRows.value = res.data || [];
    nextTick(() => buildFlowTrendChart());
  }).finally(() => {
    loadingFlowTrend.value = false;
  });
}

function handleFlowQuery() {
  flowQuery.pageNum = 1;
  loadFlowLog();
  loadFlowTrend();
}

function resetFlowQuery() {
  flowQuery.bizType = "";
  flowQuery.actionType = "";
  flowQuery.userName = "";
  flowQuery.operatorName = "";
  flowQuery.pageNum = 1;
  flowDateRange.value = [];
  flowTrendType.value = "day";
  loadFlowLog();
  loadFlowTrend();
}

function handleFlowExport() {
  proxy.download("employment/admin/report/flowLog/export", {
    ...buildFlowQueryParams(false)
  }, `flow_log_${new Date().getTime()}.xlsx`);
}

function getData() {
  getReportOverview().then((res) => {
    overview.value = res.data || {};
  });
  getAgeReport().then((res) => {
    ageRows.value = res.data || [];
  });
  loadingDistrict.value = true;
  getDistrictReport().then((res) => {
    districtRows.value = res.data || [];
    nextTick(() => buildDistrictChart());
  }).finally(() => {
    loadingDistrict.value = false;
  });
  loadingMonth.value = true;
  getApplyMonthReport().then((res) => {
    monthRows.value = res.data || [];
    nextTick(() => buildMonthChart());
  }).finally(() => {
    loadingMonth.value = false;
  });
  loadFlowLog();
  loadFlowTrend();
}

onMounted(() => {
  window.addEventListener("resize", handleResize);
});

onUnmounted(() => {
  window.removeEventListener("resize", handleResize);
  districtChartInstance?.dispose();
  monthChartInstance?.dispose();
  flowTrendChartInstance?.dispose();
  districtChartInstance = undefined;
  monthChartInstance = undefined;
  flowTrendChartInstance = undefined;
});

getData();
</script>

<style scoped>
.report-page {
  background: #f5f8fc;
}

.metric-card {
  border-left: 4px solid #2f7eff;
}

.metric-title {
  color: #64748b;
  font-size: 13px;
}

.metric-value {
  margin-top: 6px;
  font-size: 28px;
  font-weight: 700;
  color: #0f172a;
}

.age-row {
  margin-bottom: 14px;
}

.age-label {
  margin-bottom: 6px;
  color: #334155;
}

.report-chart {
  width: 100%;
  height: 320px;
}

.report-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.report-head-actions {
  display: flex;
  align-items: center;
  gap: 10px;
}

.flow-filter {
  margin-bottom: 8px;
}

.flow-trend-chart {
  height: 300px;
  margin-bottom: 10px;
}
</style>
