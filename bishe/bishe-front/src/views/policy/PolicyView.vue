<template>
  <div class="policy-container">
    <!-- 顶部搜索与标题区 -->
    <div class="page-header-section">
      <div class="header-left">
        <h2 class="page-title">政策资讯管理</h2>
        <el-tag type="success" effect="light" class="title-tag">最新就业扶持与补贴政策</el-tag>
      </div>
      <div class="search-box">
        <el-form :inline="true" :model="query" class="modern-form">
          <el-form-item>
            <el-input 
              v-model="query.title" 
              placeholder="搜索政策标题..." 
              clearable 
              class="search-input"
              prefix-icon="Search"
            />
          </el-form-item>
          <el-form-item>
            <el-select v-model="query.policyTag" placeholder="全部分类" clearable class="tag-select" style="width: 180px">
              <el-option v-for="item in tags" :key="item.categoryCode" :label="item.categoryName" :value="item.categoryCode" />
            </el-select>
          </el-form-item>
          <el-form-item>
            <el-button type="primary" class="search-btn" @click="search">
              <el-icon><Search /></el-icon> 搜索
            </el-button>
          </el-form-item>
        </el-form>
      </div>
    </div>

    <!-- 政策列表区 -->
    <div v-loading="loading" class="policy-grid-wrapper">
      <el-row :gutter="24" v-if="policyList.length > 0">
        <el-col 
          v-for="item in policyList" 
          :key="item.policyId" 
          :xs="24" :sm="12" :md="8" :lg="6"
          class="mb24"
        >
          <div class="policy-card" @click="showDetail(item)">
            <div class="card-image-box">
              <el-image
                v-if="normalizeFileUrl(item.coverUrl)"
                :src="normalizeFileUrl(item.coverUrl)"
                fit="cover"
                class="card-img"
              >
                <template #error>
                  <div class="image-placeholder">
                    <el-icon :size="40" color="#cbd5e1"><Document /></el-icon>
                  </div>
                </template>
              </el-image>
              <div v-else class="image-placeholder">
                <el-icon :size="40" color="#cbd5e1"><Document /></el-icon>
              </div>
              <div class="card-tag">{{ item.policyTagName || '政策' }}</div>
            </div>
            <div class="card-body">
              <h3 class="card-title">{{ item.title }}</h3>
              <p class="card-summary">{{ item.summary || '暂无内容简介...' }}</p>
              <div class="card-meta">
                <span class="source"><el-icon><OfficeBuilding /></el-icon> {{ item.sourceOrg }}</span>
                <span class="time"><el-icon><Calendar /></el-icon> {{ formatShortDate(item.publishTime) }}</span>
              </div>
            </div>
            <div class="card-footer">
              <span class="view-btn">阅读详情 <el-icon><ArrowRight /></el-icon></span>
            </div>
          </div>
        </el-col>
      </el-row>
      
      <el-empty v-else-if="!loading" description="暂无相关政策资讯" />
    </div>

    <!-- 分页 -->
    <div class="pagination-container">
      <el-pagination 
        background 
        layout="prev, pager, next, total" 
        :current-page="query.pageNum" 
        :page-size="query.pageSize" 
        :total="total" 
        @current-change="changePage" 
      />
    </div>

    <!-- 详情抽屉 -->
    <el-drawer 
      v-model="detailOpen" 
      :title="detail.title" 
      size="600px"
      custom-class="policy-detail-drawer"
    >
      <div class="detail-container">
        <div class="detail-header">
          <h2 class="detail-title">{{ detail.title }}</h2>
          <div class="detail-meta">
            <el-tag size="small" type="info" class="mr8">{{ detail.policyTagName }}</el-tag>
            <span>发布单位：{{ detail.sourceOrg }}</span>
            <el-divider direction="vertical" />
            <span>发布时间：{{ detail.publishTime }}</span>
          </div>
        </div>
        
        <el-image
          v-if="normalizeFileUrl(detail.coverUrl)"
          :src="normalizeFileUrl(detail.coverUrl)"
          fit="cover"
          class="detail-banner"
          :preview-src-list="[normalizeFileUrl(detail.coverUrl)]"
          preview-teleported
        />

        <div class="detail-summary" v-if="detail.summary">
          <strong>导读：</strong>{{ detail.summary }}
        </div>

        <el-divider />

        <div class="detail-content rich-content" v-html="renderPolicyContent(detail.content)"></div>
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { getCategories, getPolicies, getPolicyDetail } from "@/api/front";
import { Search, Document, OfficeBuilding, Calendar, ArrowRight } from '@element-plus/icons-vue'

const tags = ref([]);
const loading = ref(false);
const total = ref(0);
const query = reactive({ pageNum: 1, pageSize: 8, title: "", policyTag: "" });
const policyList = ref([]);
const detailOpen = ref(false);
const detail = ref({});
const apiBase = (import.meta.env.VITE_API_BASE || import.meta.env.VITE_APP_BASE_API || "http://localhost:8080").replace(/\/$/, "");

async function loadTags() {
  const res = await getCategories("3");
  tags.value = res.data || [];
}

async function loadPolicies() {
  loading.value = true;
  try {
    const res = await getPolicies(query);
    policyList.value = res.rows || [];
    total.value = res.total || 0;
  } finally {
    loading.value = false;
  }
}

function search() {
  query.pageNum = 1;
  loadPolicies();
}

function changePage(page) {
  query.pageNum = page;
  loadPolicies();
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

async function showDetail(row) {
  const res = await getPolicyDetail(row.policyId);
  detail.value = res.data || {};
  detailOpen.value = true;
}

function normalizeFileUrl(url) {
  const raw = String(url || "").trim();
  if (!raw) return "";

  // Support accidental multi-value storage and pick the first non-empty value.
  let value = raw.replace(/[,\uFF0C]/g, ",");
  value = value.split(",").map((item) => item.trim()).find((item) => !!item) || "";
  if (!value) return "";

  if (/^(data|blob):/i.test(value)) return value;
  if (/^https?:\/\//i.test(value)) return value;

  value = value.split("?")[0].trim();
  if (!value) return "";

  if (value.startsWith("profile/upload/")) {
    value = `/${value}`;
  }
  // Avoid duplicate gateway prefix like /prod-api/prod-api/...
  value = value.replace(/^\/?(dev-api|prod-api)(?=\/)/, "");

  return `${apiBase}${value.startsWith("/") ? "" : "/"}${value}`;
}

function renderPolicyContent(content) {
  const html = String(content || "");
  if (!html) return "";

  // Normalize rich-text image src URLs to keep frontend rendering consistent.
  return html.replace(/(<img\b[^>]*\bsrc\s*=\s*)([\'\"]?)([^\'\">\s]+)(\2)/gi, (match, prefix, quote, src) => {
    const normalized = normalizeFileUrl(src) || src;
    const wrappedQuote = quote || '"';
    return `${prefix}${wrappedQuote}${normalized}${wrappedQuote}`;
  });
}

function formatShortDate(dateStr) {
  if (!dateStr) return '';
  return dateStr.split(' ')[0];
}

loadTags();
loadPolicies();
</script>

<style scoped>
.policy-container {
  max-width: 1440px;
  margin: 0 auto;
}

.mb24 { margin-bottom: 24px; }
.mr8 { margin-right: 8px; }

/* 头部样式 */
.page-header-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  background: #ffffff;
  padding: 24px 32px;
  border-radius: 20px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
  margin-bottom: 24px;
}

.page-title {
  margin: 0;
  font-size: 24px;
  font-weight: 800;
  color: #1e293b;
  letter-spacing: -0.5px;
}

.title-tag {
  margin-top: 8px;
  border: none;
  font-weight: 600;
}

.modern-form {
  display: flex;
  align-items: center;
}

.search-input {
  width: 280px;
}

.search-input :deep(.el-input__wrapper) {
  border-radius: 12px;
  box-shadow: 0 0 0 1px #e2e8f0 inset;
  background: #f8fafc;
}

.tag-select {
  width: 180px;
}

.tag-select :deep(.el-input__wrapper) {
  border-radius: 12px;
  box-shadow: 0 0 0 1px #e2e8f0 inset;
  background: #f8fafc;
}

.search-btn {
  height: 40px;
  border-radius: 12px;
  padding: 0 24px;
  font-weight: 600;
  background: linear-gradient(135deg, #4f46e5 0%, #3b82f6 100%);
  border: none;
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

/* 政策卡片网格 */
.policy-card {
  background: #ffffff;
  border-radius: 20px;
  overflow: hidden;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  cursor: pointer;
  height: 100%;
  display: flex;
  flex-direction: column;
  border: 1px solid rgba(226, 232, 240, 0.8);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.02);
}

.policy-card:hover {
  transform: translateY(-8px);
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  border-color: #3b82f6;
}

.card-image-box {
  position: relative;
  height: 180px;
  overflow: hidden;
}

.card-img {
  width: 100%;
  height: 100%;
  transition: transform 0.5s ease;
}

.policy-card:hover .card-img {
  transform: scale(1.1);
}

.image-placeholder {
  width: 100%;
  height: 100%;
  background: #f1f5f9;
  display: flex;
  align-items: center;
  justify-content: center;
}

.card-tag {
  position: absolute;
  top: 12px;
  left: 12px;
  background: rgba(15, 23, 42, 0.7);
  backdrop-filter: blur(4px);
  color: white;
  padding: 4px 12px;
  border-radius: 8px;
  font-size: 12px;
  font-weight: 600;
}

.card-body {
  padding: 20px;
  flex: 1;
}

.card-title {
  margin: 0 0 10px;
  font-size: 18px;
  font-weight: 700;
  color: #1e293b;
  line-height: 1.4;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-summary {
  font-size: 14px;
  color: #64748b;
  margin: 0 0 16px;
  line-height: 1.6;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-meta {
  display: flex;
  justify-content: space-between;
  font-size: 13px;
  color: #94a3b8;
}

.card-meta span {
  display: flex;
  align-items: center;
  gap: 4px;
}

.card-footer {
  padding: 16px 20px;
  border-top: 1px solid #f1f5f9;
  background: #f8fafc;
}

.view-btn {
  font-size: 14px;
  font-weight: 700;
  color: #3b82f6;
  display: flex;
  align-items: center;
  gap: 4px;
}

/* 分页 */
.pagination-container {
  display: flex;
  justify-content: center;
  margin-top: 32px;
  padding-bottom: 40px;
}

/* 详情抽屉样式 */
.detail-container {
  padding: 0 10px;
}

.detail-header {
  margin-bottom: 24px;
}

.detail-title {
  font-size: 28px;
  font-weight: 800;
  color: #1e293b;
  line-height: 1.3;
  margin-bottom: 16px;
}

.detail-meta {
  color: #64748b;
  font-size: 14px;
  display: flex;
  align-items: center;
}

.detail-banner {
  width: 100%;
  max-height: 320px;
  border-radius: 16px;
  margin-bottom: 24px;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1);
}

.detail-summary {
  background: #f8fafc;
  padding: 20px;
  border-left: 4px solid #3b82f6;
  border-radius: 0 12px 12px 0;
  color: #475569;
  font-size: 16px;
  line-height: 1.6;
}

.detail-content {
  font-size: 17px;
  line-height: 1.8;
  color: #334155;
}

.rich-content :deep(p) { margin: 0 0 16px; }
.rich-content :deep(img) { 
  max-width: 100% !important; 
  height: auto !important; 
  border-radius: 12px;
  margin: 12px 0;
}

@media (max-width: 768px) {
  .page-header-section {
    flex-direction: column;
    align-items: flex-start;
    gap: 20px;
  }
  .search-input { width: 100%; }
  .tag-select { width: 100%; }
}
</style>
