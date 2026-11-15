<template>
  <div class="training-container">
    <!-- 头部横幅 -->
    <div class="training-header">
      <div class="header-left">
        <h2 class="page-title">技能培训报名</h2>
        <p class="page-desc">提升职业技能，开启无限可能</p>
      </div>
      <div class="header-right">
        <el-form :inline="true" :model="query" class="modern-filter">
          <el-form-item>
            <el-input 
              v-model="query.title" 
              placeholder="搜索培训课程..." 
              clearable 
              class="search-input"
              prefix-icon="Reading"
            />
          </el-form-item>
          <el-form-item>
            <el-select v-model="query.categoryCode" placeholder="所有课程分类" clearable class="cat-select" style="width: 180px">
              <el-option v-for="item in categories" :key="item.categoryCode" :label="item.categoryName" :value="item.categoryCode" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" class="search-btn" @click="search">
              <el-icon><Search /></el-icon> 查找课程
            </el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>

    <el-row :gutter="24">
      <!-- 课程网格 -->
      <el-col :lg="17" :md="24">
        <div class="courses-grid" v-loading="loadingTraining">
          <el-row :gutter="20">
            <el-col v-for="item in trainingList" :key="item.trainingId" :xs="24" :sm="12" :md="12" class="mb24">
              <div class="course-card">
                <div class="course-badge" :class="{ 'full': isTrainingFull(item) }">
                  {{ isTrainingFull(item) ? '名额已满' : '火热报名' }}
                </div>
                <div class="course-content">
                  <h3 class="course-title">{{ item.title }}</h3>
                  <div class="course-meta">
                    <div class="meta-item"><el-icon><User /></el-icon> <span>讲师：{{ item.teacherName }}</span></div>
                    <div class="meta-item"><el-icon><Location /></el-icon> <span>地点：{{ item.location }}</span></div>
                    <div class="meta-item"><el-icon><Clock /></el-icon> <span>周期：{{ formatShortDate(item.startTime) }} 至 {{ formatShortDate(item.endTime) }}</span></div>
                  </div>
                  
                  <div class="enrollment-status">
                    <div class="status-top">
                      <span class="label">报名进度</span>
                      <span class="count">{{ item.signupCount }} / {{ item.quota || '∞' }}</span>
                    </div>
                    <el-progress 
                      :percentage="calculatePercentage(item)" 
                      :status="isTrainingFull(item) ? 'exception' : ''"
                      :show-text="false" 
                      :stroke-width="8"
                    />
                  </div>
                  
                  <div class="course-footer">
                    <el-button 
                      type="primary" 
                      class="signup-btn" 
                      :disabled="isTrainingFull(item)" 
                      @click="signup(item)"
                    >
                      {{ isTrainingFull(item) ? '报名已截止' : '立即报名参加' }}
                    </el-button>
                  </div>
                </div>
              </div>
            </el-col>
          </el-row>
          <el-empty v-if="trainingList.length === 0 && !loadingTraining" description="暂无相关培训课程" />
        </div>
      </el-col>

      <!-- 我的报名侧边栏 -->
      <el-col :lg="7" :md="24">
        <div class="my-training-sidebar">
          <div class="sidebar-header">
            <h3>我的报名记录</h3>
            <div class="count-chip">{{ recordList.length }}</div>
          </div>
          
          <div class="records-list" v-loading="loadingRecord">
            <div v-for="rec in recordList" :key="rec.trainingId" class="record-item">
              <div class="status-indicator" :class="getStatusClass(rec.recordStatus)"></div>
              <div class="record-info">
                <div class="rec-title">{{ rec.trainingTitle }}</div>
                <div class="rec-meta">
                  <span>{{ rec.signupTime }}</span>
                  <el-tag size="small" :type="getStatusType(rec.recordStatus)">
                    {{ getStatusText(rec.recordStatus) }}
                  </el-tag>
                </div>
              </div>
            </div>
            <el-empty v-if="recordList.length === 0 && !loadingRecord" description="暂无报名记录" :image-size="80" />
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { ElMessage } from "element-plus";
import { getCategories, getMyTrainingRecords, getTrainings, signupTraining } from "@/api/front";
import { Search, Reading, User, Location, Clock } from '@element-plus/icons-vue'

const categories = ref([]);
const query = reactive({ pageNum: 1, pageSize: 20, title: "", categoryCode: "" });
const trainingList = ref([]);
const recordQuery = reactive({ pageNum: 1, pageSize: 20 });
const recordList = ref([]);
const loadingTraining = ref(false);
const loadingRecord = ref(false);

async function loadCategories() {
  const res = await getCategories("2");
  categories.value = res.data || [];
}

async function loadTrainings() {
  loadingTraining.value = true;
  try {
    const res = await getTrainings(query);
    trainingList.value = res.rows || [];
  } finally {
    loadingTraining.value = false;
  }
}

async function loadRecords() {
  loadingRecord.value = true;
  try {
    const res = await getMyTrainingRecords(recordQuery);
    recordList.value = res.rows || [];
  } finally {
    loadingRecord.value = false;
  }
}

function search() {
  query.pageNum = 1;
  loadTrainings();
}

function isTrainingFull(row) {
  const quota = Number(row?.quota || 0);
  const signupCount = Number(row?.signupCount || 0);
  return quota > 0 && signupCount >= quota;
}

function calculatePercentage(row) {
  const quota = Number(row?.quota || 0);
  if (quota <= 0) return 0;
  const count = Number(row?.signupCount || 0);
  return Math.min(Math.round((count / quota) * 100), 100);
}

async function signup(row) {
  if (isTrainingFull(row)) {
    ElMessage.warning("该培训名额已满");
    return;
  }
  await signupTraining(row.trainingId);
  ElMessage.success("报名成功，期待在课堂见到你！");
  await loadTrainings();
  await loadRecords();
}

function formatShortDate(dateStr) {
  if (!dateStr) return '';
  return dateStr.split(' ')[0];
}

function getStatusText(status) {
  if (status === '0') return '已报名';
  if (status === '1') return '已完成';
  if (status === '2') return '缺席';
  return '未知状态';
}

function getStatusType(status) {
  if (status === '0') return 'info';
  if (status === '1') return 'success';
  if (status === '2') return 'danger';
  return 'info';
}

function getStatusClass(status) {
  if (status === '0') return 'blue';
  if (status === '1') return 'green';
  if (status === '2') return 'red';
  return 'blue';
}

loadCategories();
loadTrainings();
loadRecords();
</script>

<style scoped>
.training-container {
  max-width: 1440px;
  margin: 0 auto;
}

.mb24 { margin-bottom: 24px; }

/* 头部样式 */
.training-header {
  background: white;
  padding: 40px;
  border-radius: 24px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
  margin-bottom: 30px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.page-title {
  margin: 0;
  font-size: 28px;
  font-weight: 800;
  color: #1e293b;
}

.page-desc {
  margin: 8px 0 0;
  color: #64748b;
  font-size: 16px;
}

.search-input {
  width: 260px;
}

.search-input :deep(.el-input__wrapper) {
  border-radius: 12px;
  background: #f8fafc;
}

.cat-select {
  width: 180px;
}

.cat-select :deep(.el-input__wrapper) {
  border-radius: 12px;
  background: #f8fafc;
}

.search-btn {
  height: 40px;
  border-radius: 12px;
  font-weight: 700;
  background: linear-gradient(135deg, #4f46e5 0%, #3b82f6 100%);
  border: none;
  padding: 0 24px;
}

/* 课程卡片 */
.course-card {
  background: white;
  border-radius: 20px;
  border: 1px solid #f1f5f9;
  position: relative;
  overflow: hidden;
  transition: all 0.3s;
  height: 100%;
}

.course-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 25px -5px rgba(0,0,0,0.05);
  border-color: #3b82f6;
}

.course-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  background: #f0fdf4;
  color: #166534;
  font-size: 12px;
  font-weight: 700;
  padding: 4px 12px;
  border-radius: 20px;
  z-index: 1;
}

.course-badge.full {
  background: #fef2f2;
  color: #991b1b;
}

.course-content {
  padding: 24px;
}

.course-title {
  margin: 0 0 16px;
  font-size: 20px;
  font-weight: 800;
  color: #1e293b;
  line-height: 1.4;
}

.course-meta {
  margin-bottom: 24px;
}

.meta-item {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  color: #64748b;
  font-size: 14px;
}

.enrollment-status {
  margin-bottom: 24px;
}

.status-top {
  display: flex;
  justify-content: space-between;
  margin-bottom: 8px;
  font-size: 13px;
  font-weight: 600;
}

.status-top .label { color: #94a3b8; }
.status-top .count { color: #3b82f6; }

.signup-btn {
  width: 100%;
  height: 44px;
  border-radius: 12px;
  font-weight: 700;
  letter-spacing: 0.5px;
}

/* 侧边栏样式 */
.my-training-sidebar {
  background: white;
  border-radius: 24px;
  padding: 24px;
  box-shadow: 0 4px 15px rgba(0,0,0,0.02);
  position: sticky;
  top: 100px;
}

.sidebar-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
}

.sidebar-header h3 {
  margin: 0;
  font-size: 18px;
  font-weight: 800;
  color: #1e293b;
}

.count-chip {
  background: #eff6ff;
  color: #3b82f6;
  width: 28px;
  height: 28px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 700;
  font-size: 14px;
}

.record-item {
  display: flex;
  gap: 16px;
  padding: 16px 0;
  border-bottom: 1px solid #f1f5f9;
}

.record-item:last-child {
  border-bottom: none;
}

.status-indicator {
  width: 4px;
  border-radius: 2px;
  height: 40px;
  flex-shrink: 0;
}

.status-indicator.blue { background: #3b82f6; }
.status-indicator.orange { background: #f59e0b; }
.status-indicator.green { background: #10b981; }
.status-indicator.red { background: #ef4444; }

.record-info {
  flex: 1;
}

.rec-title {
  font-size: 15px;
  font-weight: 700;
  color: #1e293b;
  margin-bottom: 6px;
}

.rec-meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  color: #94a3b8;
  font-size: 12px;
}

@media (max-width: 1200px) {
  .training-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 20px;
  }
  .search-input { width: 100%; }
  .cat-select { width: 100%; }
}
</style>
