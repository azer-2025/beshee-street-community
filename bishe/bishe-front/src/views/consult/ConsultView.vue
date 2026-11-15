<template>
  <div class="consult-container">
    <el-row :gutter="24">
      <!-- 发起咨询区 -->
      <el-col :lg="8" :md="24">
        <div class="consult-sidebar">
          <div class="consult-form-card">
            <div class="card-header">
              <div class="icon-circle"><el-icon :size="24"><ChatLineRound /></el-icon></div>
              <div class="header-text">
                <h3>发起新咨询</h3>
                <p>专业老师为您在线解答疑问</p>
              </div>
            </div>
            
            <el-form :model="form" label-position="top" class="modern-consult-form">
              <el-form-item label="咨询类型">
                <el-select v-model="form.consultType" placeholder="请选择咨询领域" style="width: 100%">
                  <el-option v-for="item in consultTypeOptions" :key="item.value" :label="item.label" :value="item.value" />
                </el-select>
              </el-form-item>
              <el-form-item label="问题内容描述">
                <el-input 
                  v-model="form.questionContent" 
                  type="textarea" 
                  rows="6" 
                  placeholder="请详细描述您在求职、培训或政策方面遇到的问题..." 
                />
              </el-form-item>
              <div class="form-footer">
                <el-button type="primary" class="submit-consult-btn" :loading="submitLoading" @click="submit">
                  <el-icon class="mr4"><Promotion /></el-icon> 提交咨询申请
                </el-button>
              </div>
            </el-form>
            
            <div class="consult-tips">
              <h4><el-icon><InfoFilled /></el-icon> 咨询贴士</h4>
              <ul>
                <li>描述越详细，老师回复越精准</li>
                <li>通常在1-3个工作日内获得答复</li>
                <li>您可以在右侧查看回复进度</li>
              </ul>
            </div>
          </div>
        </div>
      </el-col>

      <!-- 咨询记录区 -->
      <el-col :lg="16" :md="24">
        <div class="consult-history">
          <div class="history-header">
            <div class="title-with-badge">
              <h2>咨询记录列表</h2>
              <div class="badge-count">{{ consultList.length }}</div>
            </div>
            <div class="filter-tabs">
              <el-tag effect="plain" round class="active-tab">全部记录</el-tag>
            </div>
          </div>

          <div class="history-list" v-loading="loadingList">
            <template v-if="consultList.length > 0">
              <div v-for="item in consultList" :key="item.consultId" class="consult-card-item">
                <div class="card-item-header">
                  <div class="type-and-time">
                    <el-tag size="small" effect="dark" class="type-tag">{{ getConsultTypeLabel(item.consultType) }}</el-tag>
                    <span class="publish-time"><el-icon class="mr4"><Clock /></el-icon> {{ item.createTime || '刚刚' }}</span>
                  </div>
                  <div class="status-tags">
                    <el-tag :type="getStatusType(item.consultStatus)" size="small" class="mr8">
                      {{ getStatusText(item.consultStatus) }}
                    </el-tag>
                    <el-tag :type="getAuditType(item.auditStatus)" size="small">
                      审核: {{ getAuditText(item.auditStatus) }}
                    </el-tag>
                  </div>
                </div>
                
                <div class="question-section">
                  <div class="section-label q">问</div>
                  <div class="section-content">{{ item.questionContent }}</div>
                </div>
                
                <div class="answer-section" v-if="item.consultStatus === '1'">
                  <div class="section-label a">答</div>
                  <div class="answer-body">
                    <div class="answer-content rich-answer" v-html="renderAnswerContent(item.answerContent)"></div>
                    <div class="answer-meta">回复时间：{{ item.updateTime || '近期' }}</div>
                  </div>
                </div>
                <div class="pending-answer" v-else>
                  <el-icon class="is-loading"><Loading /></el-icon> 老师正在研判中，请稍后查看回复...
                </div>
              </div>
            </template>
            <el-empty v-else description="暂无咨询记录，有问题尽管问吧！" />
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { reactive, ref } from "vue";
import { ElMessage } from "element-plus";
import { addConsultation, getDictByType, getMyConsultations } from "@/api/front";
import { ChatLineRound, Promotion, InfoFilled, Clock, Loading } from '@element-plus/icons-vue'

const form = reactive({ consultType: "", questionContent: "" });
const consultTypeOptions = ref([]);
const listQuery = reactive({ pageNum: 1, pageSize: 20 });
const consultList = ref([]);
const loadingList = ref(false);
const submitLoading = ref(false);
const apiBase = (import.meta.env.VITE_API_BASE || import.meta.env.VITE_APP_BASE_API || "http://localhost:8080").replace(/\/$/, "");

function getConsultTypeLabel(value) {
  const row = consultTypeOptions.value.find((item) => item.value === value);
  return row ? row.label : (value || "综合咨询");
}

function getStatusText(status) {
  if (status === '0') return '等待回复';
  if (status === '1') return '已回复';
  return '已关闭';
}

function getStatusType(status) {
  if (status === '0') return 'info';
  if (status === '1') return 'success';
  return 'warning';
}

function getAuditText(status) {
  if (status === '0') return '待审';
  if (status === '1') return '通过';
  return '驳回';
}

function getAuditType(status) {
  if (status === '0') return 'warning';
  if (status === '1') return 'success';
  return 'danger';
}

async function loadConsultTypeOptions() {
  const res = await getDictByType("emp_consult_type");
  const list = res?.data || [];
  consultTypeOptions.value = list.map((item) => ({
    label: item.dictLabel,
    value: item.dictValue
  }));
  if (!form.consultType && consultTypeOptions.value.length > 0) {
    form.consultType = consultTypeOptions.value[0].value;
  }
}

async function loadList() {
  loadingList.value = true;
  try {
    const res = await getMyConsultations(listQuery);
    consultList.value = res.rows || [];
  } finally {
    loadingList.value = false;
  }
}

async function submit() {
  if (!form.consultType) {
    ElMessage.warning("请选择咨询类型");
    return;
  }
  if (!form.questionContent) {
    ElMessage.warning("请填写问题内容");
    return;
  }
  submitLoading.value = true;
  try {
    await addConsultation(form);
    ElMessage.success("咨询已成功送达教师工作台");
    form.questionContent = "";
    await loadList();
  } finally {
    submitLoading.value = false;
  }
}

function normalizeFileUrl(url) {
  const raw = String(url || "").trim();
  if (!raw) return "";

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
  value = value.replace(/^\/?(dev-api|prod-api)(?=\/)/, "");

  return `${apiBase}${value.startsWith("/") ? "" : "/"}${value}`;
}

function renderAnswerContent(content) {
  const html = String(content || "");
  if (!html) return "";

  return html.replace(/(<img\b[^>]*\bsrc\s*=\s*)(['"]?)([^'">\s]+)(\2)/gi, (match, prefix, quote, src) => {
    const normalized = normalizeFileUrl(src) || src;
    const wrappedQuote = quote || '"';
    return `${prefix}${wrappedQuote}${normalized}${wrappedQuote}`;
  });
}

async function init() {
  await loadConsultTypeOptions();
  await loadList();
}

init();
</script>

<style scoped>
.consult-container {
  max-width: 1440px;
  margin: 0 auto;
}

.mr4 { margin-right: 4px; }
.mr8 { margin-right: 8px; }

/* 侧边栏与表单 */
.consult-sidebar {
  position: sticky;
  top: 100px;
}

.consult-form-card {
  background: white;
  border-radius: 24px;
  padding: 32px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
}

.card-header {
  display: flex;
  gap: 16px;
  margin-bottom: 30px;
}

.icon-circle {
  width: 54px;
  height: 54px;
  background: #fff7ed;
  color: #f59e0b;
  border-radius: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
}

.header-text h3 {
  margin: 0;
  font-size: 20px;
  font-weight: 800;
  color: #1e293b;
}

.header-text p {
  margin: 4px 0 0;
  color: #64748b;
  font-size: 14px;
}

.submit-consult-btn {
  width: 100%;
  height: 48px;
  border-radius: 12px;
  font-weight: 700;
  font-size: 15px;
  background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
  border: none;
  box-shadow: 0 4px 12px rgba(245, 158, 11, 0.3);
}

.consult-tips {
  margin-top: 32px;
  padding-top: 24px;
  border-top: 1px solid #f1f5f9;
}

.consult-tips h4 {
  margin: 0 0 12px;
  font-size: 15px;
  color: #1e293b;
  display: flex;
  align-items: center;
  gap: 6px;
}

.consult-tips ul {
  padding-left: 20px;
  margin: 0;
  color: #64748b;
  font-size: 13px;
  line-height: 2;
}

/* 历史记录列表 */
.consult-history {
  background: white;
  border-radius: 24px;
  padding: 32px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
  min-height: 600px;
}

.history-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 30px;
}

.title-with-badge {
  display: flex;
  align-items: center;
  gap: 12px;
}

.title-with-badge h2 {
  margin: 0;
  font-size: 24px;
  font-weight: 800;
  color: #1e293b;
}

.badge-count {
  background: #f1f5f9;
  color: #475569;
  padding: 2px 10px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 700;
}

.consult-card-item {
  background: #f8fafc;
  border-radius: 20px;
  padding: 24px;
  margin-bottom: 24px;
  border: 1px solid #f1f5f9;
  transition: all 0.3s;
}

.consult-card-item:hover {
  background: white;
  box-shadow: 0 10px 15px -3px rgba(0,0,0,0.05);
  border-color: #e2e8f0;
}

.card-item-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}

.type-tag {
  border-radius: 8px;
  font-weight: 700;
  padding: 0 12px;
}

.publish-time {
  font-size: 13px;
  color: #94a3b8;
  margin-left: 12px;
}

.question-section {
  display: flex;
  gap: 12px;
  margin-bottom: 20px;
}

.section-label {
  width: 24px;
  height: 24px;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 900;
  flex-shrink: 0;
}

.section-label.q { background: #dbeafe; color: #1e40af; }
.section-label.a { background: #dcfce7; color: #15803d; }

.section-content {
  font-size: 16px;
  font-weight: 600;
  color: #1e293b;
  line-height: 1.5;
}

.answer-section {
  display: flex;
  gap: 12px;
  background: white;
  padding: 20px;
  border-radius: 16px;
  border: 1px solid #ecfdf5;
}

.answer-content {
  font-size: 15px;
  color: #475569;
  line-height: 1.6;
  margin-bottom: 12px;
}

.rich-answer :deep(p) {
  margin: 0 0 10px;
}

.rich-answer :deep(img) {
  max-width: 100% !important;
  height: auto !important;
  border-radius: 8px;
}

.answer-meta {
  font-size: 12px;
  color: #94a3b8;
}

.pending-answer {
  margin-left: 36px;
  font-size: 14px;
  color: #94a3b8;
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 12px;
  background: white;
  border-radius: 12px;
  border: 1px dashed #e2e8f0;
}

@media (max-width: 1024px) {
  .consult-sidebar { position: static; margin-bottom: 30px; }
}
</style>
