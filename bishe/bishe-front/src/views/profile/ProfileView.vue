<template>
  <div class="profile-container">
    <el-row :gutter="24">
      <!-- 左侧：个人名片 -->
      <el-col :lg="8" :md="24">
        <div class="profile-sidebar">
          <div class="user-info-card">
            <div class="user-card-header">
              <div class="avatar-wrapper">
                <el-avatar :size="100" :src="avatarUrl" class="main-avatar">
                  <el-icon :size="40"><UserFilled /></el-icon>
                </el-avatar>
                <el-upload
                  class="avatar-uploader"
                  :show-file-list="false"
                  accept="image/*"
                  :before-upload="beforeAvatarUpload"
                  :http-request="uploadAvatarRequest"
                >
                  <div class="upload-mask">
                    <el-icon><Camera /></el-icon>
                  </div>
                </el-upload>
              </div>
              <h2 class="user-realname">{{ form.realName || '新用户' }}</h2>
              <p class="user-account">ID: {{ auth.user?.userName }}</p>
            </div>
            
            <div class="status-indicators">
              <div class="status-item">
                <div class="status-label">审核状态</div>
                <el-tag :type="getAuditType(form.auditStatus)" effect="light">
                  {{ getAuditStatusLabel(form.auditStatus) }}
                </el-tag>
              </div>
              <div class="status-item">
                <div class="status-label">就业状态</div>
                <el-tag :type="getEmploymentType(form.employmentStatus)" effect="light">
                  {{ getEmploymentStatusLabel(form.employmentStatus) }}
                </el-tag>
              </div>
            </div>

            <div class="user-summary-list">
              <div class="summary-item">
                <el-icon><Postcard /></el-icon>
                <span>{{ form.education || '未填写学历' }}</span>
              </div>
              <div class="summary-item">
                <el-icon><Iphone /></el-icon>
                <span>{{ form.phone || '未绑定手机' }}</span>
              </div>
              <div class="summary-item">
                <el-icon><Location /></el-icon>
                <span class="text-truncate">{{ form.address || '未填写地址' }}</span>
              </div>
            </div>
          </div>

          <!-- 个人简介卡片 -->
          <div class="intro-card mt20">
            <h3><el-icon><Document /></el-icon> 个人自传</h3>
            <p class="intro-text">{{ form.introduction || '这个用户很懒，什么都没有留下...' }}</p>
          </div>
        </div>
      </el-col>

      <!-- 右侧：详情编辑区 -->
      <el-col :lg="16" :md="24">
        <div class="profile-main-content">
          <div class="content-header">
            <div class="header-title">
              <h3><el-icon><Setting /></el-icon> 档案详细信息</h3>
              <p>完善您的档案，有助于我们为您推荐更合适的岗位</p>
            </div>
            <el-button type="primary" class="save-btn" :loading="loading" @click="submit">
              <el-icon class="mr4"><Checked /></el-icon> 保存并同步
            </el-button>
          </div>

          <el-form :model="form" label-position="top" class="modern-profile-form">
            <div class="form-section">
              <h4 class="section-title">基础资料</h4>
              <el-row :gutter="20">
                <el-col :span="12">
                  <el-form-item label="真实姓名">
                    <el-input v-model="form.realName" placeholder="请输入您的姓名" />
                  </el-form-item>
                </el-col>
                <el-col :span="12">
                  <el-form-item label="联系电话">
                    <el-input v-model="form.phone" placeholder="您的手机号码" />
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <el-form-item label="年龄">
                    <el-input-number v-model="form.age" :min="16" :max="80" controls-position="right" style="width: 100%" />
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <el-form-item label="性别">
                    <el-select v-model="form.gender" style="width: 100%">
                      <el-option label="男" value="0" />
                      <el-option label="女" value="1" />
                      <el-option label="未知" value="2" />
                    </el-select>
                  </el-form-item>
                </el-col>
                <el-col :span="8">
                  <el-form-item label="学历">
                    <el-select v-model="form.education" clearable placeholder="请选择学历" style="width: 100%">
                      <el-option v-for="item in educationOptions" :key="item.value" :label="item.label" :value="item.value" />
                    </el-select>
                  </el-form-item>
                </el-col>
                <el-col :span="24">
                  <el-form-item label="常用联系地址">
                    <el-input v-model="form.address" placeholder="详细居住地址" />
                  </el-form-item>
                </el-col>
              </el-row>
            </div>

            <div class="form-section mt30">
              <h4 class="section-title">专业技能 & 证书</h4>
              <el-form-item label="擅长技能标签">
                <el-select
                  v-model="selectedSkillTags"
                  multiple
                  filterable
                  clearable
                  collapse-tags
                  collapse-tags-tooltip
                  placeholder="添加您的专业技能，例如：会计、驾驶、电工..."
                  style="width: 100%"
                  @change="handleSkillTagsChange"
                >
                  <el-option v-for="item in skillTagOptions" :key="item.value" :label="item.label" :value="item.value" />
                </el-select>
              </el-form-item>
              
              <el-form-item label="资质证书展示">
                <div class="certificate-uploader-grid">
                  <div v-for="(url, index) in certificateList" :key="url" class="cert-card">
                    <el-image
                      :src="normalizeFileUrl(url)"
                      :preview-src-list="certificatePreviewList"
                      :initial-index="index"
                      fit="cover"
                      class="cert-img"
                      preview-teleported
                    />
                    <div class="cert-delete" @click="removeCertificate(url)">
                      <el-icon><Delete /></el-icon>
                    </div>
                  </div>
                  <el-upload
                    class="cert-add-card"
                    :show-file-list="false"
                    accept="image/*"
                    :before-upload="beforeCertificateUpload"
                    :http-request="uploadCertificateRequest"
                  >
                    <el-icon :size="28"><Plus /></el-icon>
                    <span>上传证书</span>
                  </el-upload>
                </div>
              </el-form-item>

              <el-form-item label="简历附件">
                <div class="resume-upload-row">
                  <el-upload
                    :show-file-list="false"
                    accept=".pdf,.doc,.docx"
                    :before-upload="beforeResumeUpload"
                    :http-request="uploadResumeRequest"
                  >
                    <el-button type="primary" plain>
                      <el-icon class="mr4"><Plus /></el-icon> 上传简历附件
                    </el-button>
                  </el-upload>
                  <div v-if="form.resumeAttachmentUrl" class="resume-file-box">
                    <el-link :href="normalizeFileUrl(form.resumeAttachmentUrl)" type="primary" target="_blank">
                      {{ getResumeFileName(form.resumeAttachmentUrl) }}
                    </el-link>
                    <el-button link type="danger" @click="clearResumeAttachment">移除</el-button>
                  </div>
                  <span v-else class="resume-placeholder">支持 PDF / DOC / DOCX，建议 10MB 以内</span>
                </div>
              </el-form-item>
            </div>

            <div class="form-section mt30">
              <h4 class="section-title">个人自述</h4>
              <el-form-item label="自我评价 / 工作经历">
                <el-input 
                  v-model="form.introduction" 
                  type="textarea" 
                  rows="5" 
                  placeholder="请简要介绍您的工作背景、专业优势或职业规划..." 
                />
              </el-form-item>
            </div>
          </el-form>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { computed, reactive, ref } from "vue";
import { ElMessage } from "element-plus";
import { getDictByType, getProfile, saveProfile, uploadCommonFile, uploadCommonImage } from "@/api/front";
import { uploadAvatar } from "@/api/auth";
import { useAuthStore } from "@/store/auth";
import { UserFilled, Camera, Postcard, Iphone, Location, Document, Setting, Checked, Delete, Plus } from '@element-plus/icons-vue'

const loading = ref(false);
const auth = useAuthStore();
const apiBase = import.meta.env.VITE_APP_BASE_API || "http://localhost:8080";
const skillTagOptions = ref([]);
const educationOptions = ref([]);
const auditStatusOptions = ref([]);
const employmentStatusOptions = ref([]);
const selectedSkillTags = ref([]);
const IMAGE_FILE_PATTERN = /\.(png|jpe?g|gif|bmp|webp)$/i;
const RESUME_FILE_PATTERN = /\.(pdf|doc|docx)$/i;

const form = reactive({
  realName: "",
  age: undefined,
  gender: "2",
  phone: "",
  education: "",
  idCard: "",
  skillTags: "",
  certificateUrls: "",
  resumeAttachmentUrl: "",
  employmentStatus: "0",
  auditStatus: "0",
  address: "",
  introduction: ""
});

const avatarUrl = computed(() => {
  const avatar = auth.user?.avatar;
  if (!avatar) return "";
  if (/^https?:\/\//.test(avatar)) return avatar;
  return `${apiBase}${avatar.startsWith("/") ? "" : "/"}${avatar}`;
});

const certificateList = computed(() => {
  return (form.certificateUrls || "")
    .split(",")
    .map((item) => normalizeStoragePath(item))
    .filter((item) => !!item && isImageFilePath(item));
});

const certificatePreviewList = computed(() => certificateList.value.map((item) => normalizeFileUrl(item)));

async function loadData() {
  const res = await getProfile();
  Object.assign(form, res.data || {});
  selectedSkillTags.value = (form.skillTags || "")
    .split(",")
    .map((item) => item.trim())
    .filter((item) => !!item);
  mergeSkillTagsToOptions(selectedSkillTags.value);
  mergeEducationToOptions(form.education);
}

async function loadSkillTagOptions() {
  const res = await getDictByType("emp_skill_tag");
  const list = res?.data || [];
  skillTagOptions.value = list.map((item) => ({ label: item.dictLabel, value: item.dictLabel }));
}

async function loadEducationOptions() {
  const res = await getDictByType("emp_education");
  const list = res?.data || [];
  educationOptions.value = list.map((item) => ({ label: item.dictLabel, value: item.dictLabel }));
}

async function loadAuditStatusOptions() {
  const res = await getDictByType("emp_audit_status");
  const list = res?.data || [];
  auditStatusOptions.value = list.map((item) => ({ label: item.dictLabel, value: item.dictValue }));
}

async function loadEmploymentStatusOptions() {
  const res = await getDictByType("emp_profile_status");
  const list = res?.data || [];
  employmentStatusOptions.value = list.map((item) => ({ label: item.dictLabel, value: item.dictValue }));
}

function getAuditStatusLabel(value) {
  const match = auditStatusOptions.value.find((item) => item.value === value);
  return match ? match.label : (value || "待审核");
}

function getEmploymentStatusLabel(value) {
  const match = employmentStatusOptions.value.find((item) => item.value === value);
  return match ? match.label : (value || "待就业");
}

function getAuditType(status) {
  if (status === '0') return 'warning';
  if (status === '1') return 'success';
  return 'danger';
}

function getEmploymentType(status) {
  if (status === '0') return 'info';
  if (status === '1') return 'success';
  return 'warning';
}

function mergeSkillTagsToOptions(tags) {
  const exists = new Set(skillTagOptions.value.map((item) => item.value));
  const append = tags.filter((tag) => !exists.has(tag)).map((tag) => ({ label: tag, value: tag }));
  if (append.length) skillTagOptions.value = [...skillTagOptions.value, ...append];
}

function mergeEducationToOptions(education) {
  const value = String(education || "").trim();
  if (!value) return;
  const exists = educationOptions.value.some((item) => item.value === value);
  if (!exists) educationOptions.value = [...educationOptions.value, { label: value, value }];
}

function handleSkillTagsChange(values) {
  form.skillTags = (values || []).join(",");
}

async function submit() {
  loading.value = true;
  try {
    const payload = { ...form, certificateUrls: certificateList.value.join(",") };
    await saveProfile(payload);
    ElMessage.success("个人档案已更新并提交审核");
    await loadData();
  } finally {
    loading.value = false;
  }
}

function beforeAvatarUpload(file) {
  const isImage = (file.type || "").startsWith("image/");
  if (!isImage) { ElMessage.error("仅支持图片格式"); return false; }
  if (file.size / 1024 / 1024 > 2) { ElMessage.error("头像大小不能超过 2MB"); return false; }
  return true;
}

async function uploadAvatarRequest(option) {
  try {
    const res = await uploadAvatar(option.file);
    if (res?.imgUrl) {
      auth.user = { ...(auth.user || {}), avatar: res.imgUrl };
    } else {
      await auth.fetchUser();
    }
    ElMessage.success("头像更新成功");
    option.onSuccess?.();
  } catch (error) {
    option.onError?.(error);
  }
}

function beforeCertificateUpload(file) {
  const isImage = (file.type || "").startsWith("image/");
  if (!isImage) { ElMessage.error("仅支持图片格式"); return false; }
  if (file.size / 1024 / 1024 > 5) { ElMessage.error("证书图片不能超过 5MB"); return false; }
  return true;
}

async function uploadCertificateRequest(option) {
  try {
    const res = await uploadCommonImage(option.file);
    const filePath = normalizeStoragePath(res?.fileName || res?.url);
    const merged = new Set(certificateList.value);
    merged.add(filePath);
    form.certificateUrls = Array.from(merged).join(",");
    ElMessage.success("资质证书上传成功");
    option.onSuccess?.(res);
  } catch (error) {
    option.onError?.(error);
  }
}

function beforeResumeUpload(file) {
  const fileName = String(file?.name || "");
  if (!RESUME_FILE_PATTERN.test(fileName.toLowerCase())) {
    ElMessage.error("仅支持上传 PDF、DOC、DOCX 格式简历");
    return false;
  }
  if (file.size / 1024 / 1024 > 10) {
    ElMessage.error("简历附件大小不能超过 10MB");
    return false;
  }
  return true;
}

async function uploadResumeRequest(option) {
  try {
    const res = await uploadCommonFile(option.file);
    const filePath = normalizeStoragePath(res?.fileName || res?.url);
    if (!filePath || !RESUME_FILE_PATTERN.test(filePath.toLowerCase())) {
      ElMessage.error("上传成功但文件格式不符合要求");
      option.onError?.(new Error("invalid resume file"));
      return;
    }
    form.resumeAttachmentUrl = filePath;
    ElMessage.success("简历附件上传成功");
    option.onSuccess?.(res);
  } catch (error) {
    option.onError?.(error);
  }
}

function clearResumeAttachment() {
  form.resumeAttachmentUrl = "";
}

function getResumeFileName(path) {
  const raw = String(path || "");
  if (!raw) return "简历附件";
  const segments = raw.split("/");
  return segments[segments.length - 1] || "简历附件";
}

function removeCertificate(url) {
  form.certificateUrls = certificateList.value.filter((item) => item !== url).join(",");
}

function normalizeFileUrl(url) {
  if (!url) return "";
  if (/^https?:\/\//.test(url)) return url;
  return `${apiBase}${url.startsWith("/") ? "" : "/"}${url}`;
}

function normalizeStoragePath(url) {
  const raw = String(url || "").trim();
  if (!raw) return "";
  let value = raw;
  if (/^https?:\/\//.test(value)) {
    try { value = new URL(value).pathname || ""; } catch (e) { return ""; }
  }
  if (!value) return "";
  value = value.split("?")[0].trim();
  if (value.startsWith("profile/upload/")) value = `/${value}`;
  return value;
}

function isImageFilePath(path) {
  return IMAGE_FILE_PATTERN.test(String(path || "").toLowerCase());
}

async function init() {
  await loadSkillTagOptions();
  await loadEducationOptions();
  await loadAuditStatusOptions();
  await loadEmploymentStatusOptions();
  await loadData();
}

init();
</script>

<style scoped>
.profile-container {
  max-width: 1440px;
  margin: 0 auto;
}

.mt20 { margin-top: 20px; }
.mt30 { margin-top: 30px; }
.mr4 { margin-right: 4px; }

/* 个人名片侧边栏 */
.profile-sidebar {
  position: sticky;
  top: 100px;
}

.user-info-card {
  background: white;
  border-radius: 24px;
  padding: 40px 32px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
  text-align: center;
}

.avatar-wrapper {
  position: relative;
  display: inline-block;
  margin-bottom: 24px;
}

.main-avatar {
  border: 4px solid #f8fafc;
  box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1);
}

.avatar-uploader {
  position: absolute;
  bottom: 0;
  right: 0;
}

.upload-mask {
  width: 32px;
  height: 32px;
  background: #3b82f6;
  color: white;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  border: 2px solid white;
  transition: all 0.2s;
}

.upload-mask:hover {
  transform: scale(1.1);
  background: #2563eb;
}

.user-realname {
  margin: 0;
  font-size: 24px;
  font-weight: 800;
  color: #1e293b;
}

.user-account {
  margin: 8px 0 24px;
  color: #94a3b8;
  font-size: 14px;
}

.status-indicators {
  display: flex;
  justify-content: center;
  gap: 20px;
  padding: 20px 0;
  border-top: 1px solid #f1f5f9;
  border-bottom: 1px solid #f1f5f9;
  margin-bottom: 24px;
}

.status-item {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.status-label {
  font-size: 12px;
  color: #94a3b8;
  font-weight: 600;
}

.user-summary-list {
  text-align: left;
}

.summary-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px 0;
  color: #64748b;
  font-size: 14px;
}

.summary-item .el-icon {
  color: #3b82f6;
  font-size: 18px;
}

.intro-card {
  background: white;
  border-radius: 24px;
  padding: 24px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
}

.intro-card h3 {
  margin: 0 0 16px;
  font-size: 16px;
  font-weight: 800;
  color: #1e293b;
  display: flex;
  align-items: center;
  gap: 8px;
}

.intro-text {
  font-size: 14px;
  color: #64748b;
  line-height: 1.6;
  margin: 0;
}

/* 主内容区 */
.profile-main-content {
  background: white;
  border-radius: 24px;
  padding: 40px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.03);
}

.content-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 40px;
}

.header-title h3 {
  margin: 0;
  font-size: 22px;
  font-weight: 800;
  color: #1e293b;
  display: flex;
  align-items: center;
  gap: 10px;
}

.header-title p {
  margin: 8px 0 0;
  color: #94a3b8;
  font-size: 15px;
}

.save-btn {
  height: 48px;
  padding: 0 32px;
  border-radius: 14px;
  font-weight: 700;
  box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
}

.form-section {
  padding-bottom: 30px;
}

.section-title {
  margin: 0 0 24px;
  font-size: 17px;
  font-weight: 800;
  color: #334155;
  position: relative;
  padding-left: 14px;
}

.section-title::before {
  content: '';
  position: absolute;
  left: 0;
  top: 4px;
  bottom: 4px;
  width: 4px;
  background: #3b82f6;
  border-radius: 2px;
}

/* 证书上传格 */
.certificate-uploader-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap: 16px;
}

.cert-card {
  position: relative;
  height: 120px;
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid #e2e8f0;
}

.cert-img {
  width: 100%;
  height: 100%;
}

.cert-delete {
  position: absolute;
  top: 6px;
  right: 6px;
  width: 24px;
  height: 24px;
  background: rgba(239, 68, 68, 0.9);
  color: white;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  opacity: 0;
  transition: opacity 0.2s;
}

.cert-card:hover .cert-delete {
  opacity: 1;
}

.cert-add-card {
  height: 120px;
  border: 2px dashed #cbd5e1;
  border-radius: 12px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  cursor: pointer;
  color: #64748b;
  transition: all 0.2s;
}

.cert-add-card:hover {
  border-color: #3b82f6;
  color: #3b82f6;
  background: #eff6ff;
}

.resume-upload-row {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
}

.resume-file-box {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 6px 10px;
  border: 1px solid #dbeafe;
  background: #eff6ff;
  border-radius: 10px;
}

.resume-placeholder {
  color: #94a3b8;
  font-size: 13px;
}

@media (max-width: 1024px) {
  .profile-sidebar { position: static; margin-bottom: 30px; }
  .content-header { flex-direction: column; gap: 20px; }
  .save-btn { width: 100%; }
}
</style>
