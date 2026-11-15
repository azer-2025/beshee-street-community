<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="用户名" prop="userName">
        <el-input v-model="queryParams.userName" placeholder="请输入用户名" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="姓名" prop="realName">
        <el-input v-model="queryParams.realName" placeholder="请输入姓名" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="审核状态" prop="auditStatus">
        <el-select v-model="queryParams.auditStatus" placeholder="请选择审核状态" clearable style="width: 200px">
          <el-option v-for="item in emp_audit_status" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['employment:profile:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['employment:profile:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['employment:profile:remove']">删除</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="profileList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="档案ID" prop="profileId" width="90" align="center" />
      <el-table-column label="用户名" prop="userName" width="120" />
      <el-table-column label="姓名" prop="realName" width="120" />
      <el-table-column label="性别" prop="gender" width="100">
        <template #default="scope">
          <dict-tag :options="sys_user_sex" :value="scope.row.gender" />
        </template>
      </el-table-column>
      <el-table-column label="年龄" prop="age" width="80" />
      <el-table-column label="学历" prop="education" width="120" />
      <el-table-column label="技能标签" prop="skillTags" :show-overflow-tooltip="true">
        <template #default="scope">
          {{ formatSkillTags(scope.row.skillTags) }}
        </template>
      </el-table-column>
      <el-table-column label="证书图片" width="120" align="center">
        <template #default="scope">
          <image-preview
            v-if="scope.row.certificateUrls"
            :src="scope.row.certificateUrls"
            :width="48"
            :height="48"
          />
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="简历附件" width="180">
        <template #default="scope">
          <el-link
            v-if="scope.row.resumeAttachmentUrl"
            :href="resumeAttachmentHref(scope.row.resumeAttachmentUrl)"
            target="_blank"
            type="primary"
          >
            查看附件
          </el-link>
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="就业状态" prop="employmentStatus" width="120">
        <template #default="scope">
          <dict-tag :options="emp_profile_status" :value="scope.row.employmentStatus" />
        </template>
      </el-table-column>
      <el-table-column label="审核状态" prop="auditStatus" width="120">
        <template #default="scope">
          <dict-tag :options="emp_audit_status" :value="scope.row.auditStatus" />
        </template>
      </el-table-column>
      <el-table-column label="更新时间" prop="updateTime" width="160" />
      <el-table-column label="操作" width="260" fixed="right">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['employment:profile:edit']">修改</el-button>
          <el-button link type="success" icon="CircleCheck" @click="handleAudit(scope.row, '1')" v-hasPermi="['employment:profile:audit']">通过</el-button>
          <el-button link type="warning" icon="CircleClose" @click="handleAudit(scope.row, '2')" v-hasPermi="['employment:profile:audit']">驳回</el-button>
          <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['employment:profile:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="getList"
    />

    <el-dialog :title="title" v-model="open" width="760px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-row :gutter="12">
          <el-col :span="12">
            <el-form-item label="用户ID" prop="userId">
              <el-input v-model="form.userId" placeholder="请输入系统用户ID" :disabled="form.profileId !== undefined" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="姓名" prop="realName">
              <el-input v-model="form.realName" placeholder="请输入姓名" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="性别" prop="gender">
              <el-select v-model="form.gender" placeholder="请选择性别">
                <el-option v-for="item in sys_user_sex" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="年龄" prop="age">
              <el-input-number v-model="form.age" :min="16" :max="80" style="width: 100%" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="手机号" prop="phone">
              <el-input v-model="form.phone" placeholder="请输入手机号" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="学历" prop="education">
              <el-input v-model="form.education" placeholder="请输入学历" />
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="就业状态" prop="employmentStatus">
              <el-select v-model="form.employmentStatus" placeholder="请选择就业状态">
                <el-option v-for="item in emp_profile_status" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="12">
            <el-form-item label="审核状态" prop="auditStatus">
              <el-select v-model="form.auditStatus" placeholder="请选择审核状态">
                <el-option v-for="item in emp_audit_status" :key="item.value" :label="item.label" :value="item.value" />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="技能标签" prop="skillTags">
              <el-select
                v-model="skillTagValueList"
                multiple
                filterable
                clearable
                allow-create
                default-first-option
                collapse-tags
                collapse-tags-tooltip
                placeholder="请选择技能标签"
                style="width: 100%"
              >
                <el-option
                  v-for="item in skillTagOptions"
                  :key="item.value"
                  :label="item.label"
                  :value="item.value"
                />
              </el-select>
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="证书图片" prop="certificateUrls">
              <image-upload
                v-model="form.certificateUrls"
                action="/common/upload/image"
                :limit="6"
                :file-size="5"
                :file-type="['png', 'jpg', 'jpeg']"
              />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="简历附件" prop="resumeAttachmentUrl">
              <file-upload
                v-model="form.resumeAttachmentUrl"
                action="/common/upload"
                :limit="1"
                :file-size="10"
                :file-type="['pdf', 'doc', 'docx']"
              />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="地址" prop="address">
              <el-input v-model="form.address" placeholder="请输入联系地址" />
            </el-form-item>
          </el-col>
          <el-col :span="24">
            <el-form-item label="个人简介" prop="introduction">
              <el-input v-model="form.introduction" type="textarea" rows="3" placeholder="请输入个人简介" />
            </el-form-item>
          </el-col>
        </el-row>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="open = false">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="EmploymentProfile">
import { addProfile, auditProfile, delProfile, getProfile, listProfile, updateProfile } from "@/api/employment/profile";

const { proxy } = getCurrentInstance();
const { sys_user_sex, emp_profile_status, emp_audit_status, emp_skill_tag } = proxy.useDict("sys_user_sex", "emp_profile_status", "emp_audit_status", "emp_skill_tag");

const loading = ref(false);
const showSearch = ref(true);
const open = ref(false);
const title = ref("");
const total = ref(0);
const profileList = ref([]);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const baseUrl = import.meta.env.VITE_APP_BASE_API || "";

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    userName: undefined,
    realName: undefined,
    auditStatus: undefined
  },
  form: {},
  rules: {
    userId: [{ required: true, message: "用户ID不能为空", trigger: "blur" }],
    realName: [{ required: true, message: "姓名不能为空", trigger: "blur" }]
  }
});

const { queryParams, form, rules } = toRefs(data);

const skillTagValueList = computed({
  get() {
    const raw = String(form.value?.skillTags || "");
    return raw
      .split(",")
      .map((item) => item.trim())
      .filter((item) => !!item);
  },
  set(values) {
    form.value.skillTags = (values || []).map((item) => String(item || "").trim()).filter((item) => !!item).join(",");
  }
});

const skillTagOptions = computed(() => {
  const base = (emp_skill_tag.value || []).map((item) => ({
    label: item.label,
    value: item.value
  }));
  const exists = new Set(base.map((item) => item.value));
  const extra = skillTagValueList.value
    .filter((value) => !exists.has(value))
    .map((value) => ({ label: value, value }));
  return [...base, ...extra];
});

const skillTagLabelMap = computed(() => {
  const map = new Map();
  (emp_skill_tag.value || []).forEach((item) => {
    map.set(String(item.value || ""), String(item.label || ""));
    map.set(String(item.label || ""), String(item.label || ""));
  });
  return map;
});

function formatSkillTags(rawValue) {
  const value = String(rawValue || "").trim();
  if (!value) return "-";
  const labels = value
    .split(",")
    .map((item) => item.trim())
    .filter((item) => !!item)
    .map((item) => skillTagLabelMap.value.get(item) || item);
  return labels.length ? labels.join("、") : "-";
}

function reset() {
    form.value = {
    profileId: undefined,
    userId: undefined,
    realName: undefined,
    gender: "2",
    age: undefined,
    phone: undefined,
    education: undefined,
      skillTags: "",
      certificateUrls: "",
      resumeAttachmentUrl: "",
      employmentStatus: "0",
    auditStatus: "0",
    address: undefined,
    introduction: undefined
  };
  proxy.resetForm("formRef");
}

function resumeAttachmentHref(url) {
  const value = String(url || "").trim();
  if (!value) return "";
  if (/^https?:\/\//i.test(value)) return value;
  return `${baseUrl}${value.startsWith("/") ? "" : "/"}${value}`;
}

function getList() {
  loading.value = true;
  listProfile(queryParams.value).then((res) => {
    profileList.value = res.rows;
    total.value = res.total;
    loading.value = false;
  });
}

function handleQuery() {
  queryParams.value.pageNum = 1;
  getList();
}

function resetQuery() {
  proxy.resetForm("queryRef");
  handleQuery();
}

function handleSelectionChange(selection) {
  ids.value = selection.map((item) => item.profileId);
  single.value = selection.length !== 1;
  multiple.value = selection.length === 0;
}

function handleAdd() {
  reset();
  open.value = true;
  title.value = "新增人员档案";
}

function handleUpdate(row) {
  const profileId = row?.profileId || ids.value[0];
  if (!profileId) {
    return;
  }
  reset();
  getProfile(profileId).then((res) => {
    form.value = res.data;
    open.value = true;
    title.value = "编辑人员档案";
  });
}

function submitForm() {
  proxy.$refs.formRef.validate((valid) => {
    if (!valid) {
      return;
    }
    const api = form.value.profileId ? updateProfile : addProfile;
    api(form.value).then(() => {
      proxy.$modal.msgSuccess(form.value.profileId ? "修改成功" : "新增成功");
      open.value = false;
      getList();
    });
  });
}

function handleDelete(row) {
  const profileIds = row?.profileId || ids.value;
  if (!profileIds || (Array.isArray(profileIds) && profileIds.length === 0)) {
    return;
  }
  proxy.$modal.confirm(`确认删除档案 ${profileIds} 吗？`).then(() => delProfile(profileIds)).then(() => {
    proxy.$modal.msgSuccess("删除成功");
    getList();
  });
}

function handleAudit(row, auditStatus) {
  const data = {
    id: row.profileId,
    auditStatus,
    auditRemark: auditStatus === "1" ? "审核通过" : "审核驳回"
  };
  auditProfile(data).then(() => {
    proxy.$modal.msgSuccess("审核完成");
    getList();
  });
}

getList();
</script>
