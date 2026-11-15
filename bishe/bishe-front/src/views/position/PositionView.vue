<template>
  <div class="position-container">
    <!-- 岗位检索区 -->
    <div class="section-header">
      <div class="header-content">
        <h2 class="section-title">岗位申请管理</h2>
        <p class="section-subtitle">发现最适合你的职业机会</p>
      </div>
      <div class="header-filters">
        <el-form :inline="true" :model="query" class="modern-search-form">
          <el-form-item>
            <el-input 
              v-model="query.positionName" 
              placeholder="搜索心仪岗位..." 
              clearable 
              class="search-input"
              prefix-icon="Search"
            />
          </el-form-item>
          <el-form-item>
            <el-select v-model="query.categoryCode" placeholder="所有岗位分类" clearable class="category-select" style="width: 180px">
              <el-option v-for="item in categories" :key="item.categoryCode" :label="item.categoryName" :value="item.categoryCode" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" class="search-btn" @click="search">
              <el-icon><Search /></el-icon> 检索岗位
            </el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>

    <!-- 岗位卡片网格 -->
    <div class="positions-grid" v-loading="loadingPosition">
      <el-row :gutter="20">
        <el-col v-for="item in positionList" :key="item.positionId" :xs="24" :sm="12" :md="8" :lg="6" class="mb20">
          <div class="position-item-card">
            <div class="card-top">
              <div class="company-logo">
                <el-icon :size="24" color="#3b82f6"><OfficeBuilding /></el-icon>
              </div>
              <div class="salary">{{ item.salaryRange }}</div>
            </div>
            <div class="card-main">
              <h3 class="job-title">{{ item.positionName }}</h3>
              <div class="company-name">{{ item.companyName }}</div>
              <div class="job-tags">
                <el-tag size="small" effect="plain" type="info">{{ item.categoryName }}</el-tag>
                <el-tag size="small" effect="plain" type="info" class="ml8">全职</el-tag>
              </div>
              <div class="location">
                <el-icon><Location /></el-icon> {{ item.workAddress }}
              </div>
            </div>
            <div class="card-actions">
              <el-button type="primary" class="apply-btn" @click="openApply(item)">立即申请</el-button>
            </div>
          </div>
        </el-col>
      </el-row>
      <el-empty v-if="positionList.length === 0 && !loadingPosition" description="没有找到匹配的岗位" />
      
      <div class="pagination-center mt20" v-if="positionTotal > 0">
        <el-pagination 
          background 
          layout="prev, pager, next" 
          :current-page="query.pageNum" 
          :page-size="query.pageSize" 
          :total="positionTotal" 
          @current-change="changePositionPage" 
        />
      </div>
    </div>

    <!-- 我的投递记录 -->
    <div class="my-records-section mt40">
      <div class="section-title-bar">
        <h3>我的投递记录</h3>
        <el-tag type="success" size="small">{{ myApplyList.length }} 条记录</el-tag>
      </div>
      
      <el-card class="records-card" shadow="never">
        <el-table :data="myApplyList" v-loading="loadingApply" style="width: 100%">
          <el-table-column label="申请岗位" min-width="180">
            <template #default="scope">
              <div class="job-cell">
                <div class="job-name">{{ scope.row.positionName }}</div>
                <div class="comp-name">{{ scope.row.companyName }}</div>
              </div>
            </template>
          </el-table-column>
          <el-table-column label="当前状态" width="130" align="center">
            <template #default="scope">
              <el-tag v-if="scope.row.applyStatus === '0'" type="info" effect="light">已投递</el-tag>
              <el-tag v-else-if="scope.row.applyStatus === '1'" type="warning" effect="light">面试中</el-tag>
              <el-tag v-else-if="scope.row.applyStatus === '2'" type="success" effect="light">已录用</el-tag>
              <el-tag v-else type="danger" effect="light">未通过</el-tag>
            </template>
          </el-table-column>
          <el-table-column label="企业反馈" min-width="200">
            <template #default="scope">
              <span class="remark-text">{{ scope.row.auditRemark || '企业审核中，请耐心等待...' }}</span>
            </template>
          </el-table-column>
          <el-table-column label="申请时间" width="180" prop="applyTime" sortable />
        </el-table>
      </el-card>
    </div>

    <!-- 申请对话框 -->
    <el-dialog v-model="applyOpen" title="确认投递意向" width="480px" custom-class="modern-dialog">
      <div class="apply-confirm-body">
        <div class="confirm-job-info">
          <div class="confirm-icon"><el-icon><CircleCheckFilled /></el-icon></div>
          <div class="confirm-text">
            <h4>您正在申请：{{ applyForm.positionName }}</h4>
            <p>请确认您的简历信息准确无误，您可以补充额外的说明。</p>
          </div>
        </div>
        <el-form :model="applyForm" label-position="top">
          <el-form-item label="个人补充说明 (选填)">
            <el-input 
              v-model="applyForm.resumeNote" 
              type="textarea" 
              rows="5" 
              placeholder="可填写工作经历、专业技能或求职意愿，增加录用机会..." 
            />
          </el-form-item>
        </el-form>
      </div>
      <template #footer>
        <div class="dialog-footer-center">
          <el-button @click="applyOpen = false" size="large">放弃申请</el-button>
          <el-button type="primary" :loading="applyLoading" @click="submitApply" size="large" class="submit-apply-btn">确认投递简历</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { ElMessage } from "element-plus";
import { applyPosition, getCategories, getMyApplies, getPositions, getProfile } from "@/api/front";
import { Search, OfficeBuilding, Location, CircleCheckFilled } from '@element-plus/icons-vue'

const categories = ref([]);
const loadingPosition = ref(false);
const loadingApply = ref(false);
const applyLoading = ref(false);

const query = reactive({ pageNum: 1, pageSize: 8, positionName: "", categoryCode: "" });
const positionList = ref([]);
const positionTotal = ref(0);

const applyQuery = reactive({ pageNum: 1, pageSize: 8 });
const myApplyList = ref([]);

const applyOpen = ref(false);
const applyForm = reactive({ positionId: undefined, positionName: "", resumeNote: "" });

async function loadCategories() {
  const res = await getCategories("1");
  categories.value = res.data || [];
}

async function loadPositions() {
  loadingPosition.value = true;
  try {
    const res = await getPositions(query);
    positionList.value = res.rows || [];
    positionTotal.value = res.total || 0;
  } finally {
    loadingPosition.value = false;
  }
}

async function loadMyApplies() {
  loadingApply.value = true;
  try {
    const res = await getMyApplies(applyQuery);
    myApplyList.value = res.rows || [];
  } finally {
    loadingApply.value = false;
  }
}

function search() {
  query.pageNum = 1;
  loadPositions();
}

function changePositionPage(page) {
  query.pageNum = page;
  loadPositions();
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

async function openApply(row) {
  try {
    const profileRes = await getProfile();
    const profile = profileRes?.data || {};
    if (profile.auditStatus !== "1") {
      ElMessage.warning("个人档案未审核通过，暂不能投递简历");
      return;
    }
    if (!String(profile.resumeAttachmentUrl || "").trim()) {
      ElMessage.warning("请先在个人信息中上传简历附件再投递");
      return;
    }
  } catch (e) {
    return;
  }
  applyForm.positionId = row.positionId;
  applyForm.positionName = row.positionName;
  applyForm.resumeNote = "";
  applyOpen.value = true;
}

async function submitApply() {
  applyLoading.value = true;
  try {
    await applyPosition({ positionId: applyForm.positionId, resumeNote: applyForm.resumeNote });
    ElMessage.success("申请成功！您的简历已投递至企业HR");
    applyOpen.value = false;
    await loadPositions();
    await loadMyApplies();
  } finally {
    applyLoading.value = false;
  }
}

loadCategories();
loadPositions();
loadMyApplies();
</script>

<style scoped>
.position-container {
  max-width: 1440px;
  margin: 0 auto;
}

.mb20 { margin-bottom: 20px; }
.mt20 { margin-top: 20px; }
.mt40 { margin-top: 40px; }
.ml8 { margin-left: 8px; }

/* 头部样式 */
.section-header {
  background: white;
  padding: 32px;
  border-radius: 24px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
  margin-bottom: 30px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.section-title {
  margin: 0;
  font-size: 26px;
  font-weight: 800;
  color: #1e293b;
}

.section-subtitle {
  margin: 8px 0 0;
  color: #64748b;
  font-size: 15px;
}

.modern-search-form {
  display: flex;
  align-items: center;
}

.search-input {
  width: 260px;
}

.search-input :deep(.el-input__wrapper) {
  border-radius: 12px;
  background: #f8fafc;
}

.category-select {
  width: 180px;
}

.category-select :deep(.el-input__wrapper) {
  border-radius: 12px;
  background: #f8fafc;
}

.search-btn {
  height: 40px;
  border-radius: 12px;
  background: linear-gradient(135deg, #4f46e5 0%, #3b82f6 100%);
  border: none;
  font-weight: 600;
  padding: 0 24px;
}

/* 岗位卡片 */
.position-item-card {
  background: white;
  border-radius: 20px;
  padding: 24px;
  height: 100%;
  display: flex;
  flex-direction: column;
  transition: all 0.3s;
  border: 1px solid #f1f5f9;
}

.position-item-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 25px -5px rgba(0,0,0,0.05);
  border-color: #3b82f6;
}

.card-top {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 16px;
}

.company-logo {
  width: 48px;
  height: 48px;
  background: #eff6ff;
  border-radius: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.salary {
  font-size: 16px;
  font-weight: 800;
  color: #ef4444;
}

.card-main {
  flex: 1;
}

.job-title {
  margin: 0 0 6px;
  font-size: 19px;
  font-weight: 800;
  color: #1e293b;
}

.company-name {
  font-size: 14px;
  color: #64748b;
  margin-bottom: 16px;
}

.job-tags {
  margin-bottom: 16px;
}

.location {
  font-size: 13px;
  color: #94a3b8;
  display: flex;
  align-items: center;
  gap: 4px;
}

.card-actions {
  margin-top: 24px;
}

.apply-btn {
  width: 100%;
  border-radius: 12px;
  height: 44px;
  font-weight: 700;
  background: #eff6ff;
  color: #3b82f6;
  border: 1px solid #dbeafe;
}

.position-item-card:hover .apply-btn {
  background: #3b82f6;
  color: white;
  border-color: #3b82f6;
}

/* 投递记录表格 */
.section-title-bar {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 16px;
}

.section-title-bar h3 {
  margin: 0;
  font-size: 20px;
  font-weight: 800;
  color: #1e293b;
}

.records-card {
  border-radius: 20px;
  border: none;
  box-shadow: 0 4px 15px rgba(0,0,0,0.02);
}

.job-cell .job-name {
  font-weight: 700;
  color: #1e293b;
  font-size: 15px;
}

.job-cell .comp-name {
  font-size: 13px;
  color: #64748b;
  margin-top: 2px;
}

.remark-text {
  font-size: 13px;
  color: #475569;
}

.pagination-center {
  display: flex;
  justify-content: center;
}

/* 申请弹窗 */
.confirm-job-info {
  display: flex;
  gap: 16px;
  background: #f0f7ff;
  padding: 16px;
  border-radius: 16px;
  margin-bottom: 24px;
}

.confirm-icon {
  font-size: 32px;
  color: #3b82f6;
}

.confirm-text h4 {
  margin: 0 0 4px;
  font-size: 17px;
  color: #1e293b;
}

.confirm-text p {
  margin: 0;
  font-size: 13px;
  color: #64748b;
}

.dialog-footer-center {
  display: flex;
  justify-content: center;
  gap: 16px;
  width: 100%;
}

.submit-apply-btn {
  padding: 0 32px;
  background: linear-gradient(135deg, #4f46e5 0%, #3b82f6 100%);
  border: none;
}

@media (max-width: 1024px) {
  .section-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 20px;
  }
  .search-input { width: 100%; }
  .category-select { width: 100%; }
}
</style>
