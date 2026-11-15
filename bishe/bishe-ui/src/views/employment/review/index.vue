<template>
  <div class="app-container">
    <el-tabs v-model="activeTab" @tab-change="loadTab">
      <el-tab-pane label="岗位审核" name="position">
        <div class="mb8">
          <el-button type="primary" plain icon="Plus" @click="openPositionDialog()" v-hasPermi="['employment:review:positionAudit']">新增岗位</el-button>
        </div>
        <el-table v-loading="loading.position" :data="positionList">
          <el-table-column label="岗位" prop="positionName" min-width="180" :show-overflow-tooltip="true" />
          <el-table-column label="企业" prop="companyName" min-width="160" :show-overflow-tooltip="true" />
          <el-table-column label="分类" prop="categoryName" width="140" />
          <el-table-column label="薪资" prop="salaryRange" width="120" />
          <el-table-column label="审核" prop="auditStatus" width="100">
            <template #default="scope"><dict-tag :options="emp_audit_status" :value="scope.row.auditStatus" /></template>
          </el-table-column>
          <el-table-column label="操作" width="280">
            <template #default="scope">
              <el-button link type="primary" @click="openPositionDialog(scope.row)">编辑</el-button>
              <el-button link type="success" @click="auditPositionRow(scope.row, '1')">通过</el-button>
              <el-button link type="warning" @click="auditPositionRow(scope.row, '2')">驳回</el-button>
              <el-button link type="danger" @click="removePosition(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="培训审核" name="training">
        <div class="mb8">
          <el-button type="primary" plain icon="Plus" @click="openTrainingDialog()" v-hasPermi="['employment:review:positionAudit']">新增培训</el-button>
        </div>
        <el-table v-loading="loading.training" :data="trainingList">
          <el-table-column label="主题" prop="title" min-width="180" :show-overflow-tooltip="true" />
          <el-table-column label="分类" prop="categoryName" width="140" />
          <el-table-column label="讲师" prop="teacherName" width="120" />
          <el-table-column label="时间" prop="startTime" width="170" />
          <el-table-column label="审核" prop="auditStatus" width="100">
            <template #default="scope"><dict-tag :options="emp_audit_status" :value="scope.row.auditStatus" /></template>
          </el-table-column>
          <el-table-column label="操作" width="280">
            <template #default="scope">
              <el-button link type="primary" @click="openTrainingDialog(scope.row)">编辑</el-button>
              <el-button link type="success" @click="auditTrainingRow(scope.row, '1')">通过</el-button>
              <el-button link type="warning" @click="auditTrainingRow(scope.row, '2')">驳回</el-button>
              <el-button link type="danger" @click="removeTraining(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="培训记录处理" name="trainingRecord">
        <div class="mb8">
          <el-button type="primary" plain icon="Plus" @click="openTrainingRecordDialog()" v-hasPermi="['employment:review:positionAudit']">新增记录</el-button>
        </div>
        <el-table v-loading="loading.trainingRecord" :data="trainingRecordList">
          <el-table-column label="用户" prop="userName" width="120" />
          <el-table-column label="培训" prop="trainingTitle" min-width="180" :show-overflow-tooltip="true" />
          <el-table-column label="状态" prop="recordStatus" width="110">
            <template #default="scope">
              <el-tag size="small" :type="getTrainingRecordStatusType(scope.row.recordStatus)">
                {{ getTrainingRecordStatusText(scope.row.recordStatus) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="报名时间" prop="signupTime" width="170" />
          <el-table-column label="操作" width="320">
            <template #default="scope">
              <el-button link type="primary" @click="openTrainingRecordDialog(scope.row)">编辑</el-button>
              <el-button link type="success" @click="setTrainingRecordStatus(scope.row, '1')">完成</el-button>
              <el-button link type="warning" @click="setTrainingRecordStatus(scope.row, '2')">缺席</el-button>
              <el-button link type="danger" @click="removeTrainingRecord(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="咨询审核" name="consult">
        <div class="mb8">
          <el-button type="primary" plain icon="Plus" @click="openConsultDialog()" v-hasPermi="['employment:review:consultAudit']">新增咨询</el-button>
        </div>
        <el-table v-loading="loading.consult" :data="consultList">
          <el-table-column label="用户" prop="userName" width="120" />
          <el-table-column label="类型" prop="consultType" width="120">
            <template #default="scope"><dict-tag :options="emp_consult_type" :value="scope.row.consultType" /></template>
          </el-table-column>
          <el-table-column label="问题" prop="questionContent" min-width="220" :show-overflow-tooltip="true" />
          <el-table-column label="咨询状态" prop="consultStatus" width="110">
            <template #default="scope"><dict-tag :options="emp_consult_status" :value="scope.row.consultStatus" /></template>
          </el-table-column>
          <el-table-column label="审核" prop="auditStatus" width="100">
            <template #default="scope"><dict-tag :options="emp_audit_status" :value="scope.row.auditStatus" /></template>
          </el-table-column>
          <el-table-column label="操作" width="340">
            <template #default="scope">
              <el-button link type="primary" @click="openConsultDialog(scope.row)">编辑</el-button>
              <el-button link type="primary" @click="replyConsultRow(scope.row)">回复</el-button>
              <el-button link type="success" @click="auditConsultRow(scope.row, '1')">通过</el-button>
              <el-button link type="warning" @click="auditConsultRow(scope.row, '2')">驳回</el-button>
              <el-button link type="danger" @click="removeConsult(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="政策审核" name="policy">
        <div class="mb8">
          <el-button type="primary" plain icon="Plus" @click="openPolicyDialog()" v-hasPermi="['employment:review:policyAudit']">新增政策</el-button>
        </div>
        <el-table v-loading="loading.policy" :data="policyList">
          <el-table-column label="标题" prop="title" min-width="220" :show-overflow-tooltip="true" />
          <el-table-column label="封面" width="100" align="center">
            <template #default="scope">
              <image-preview v-if="scope.row.coverUrl" :src="scope.row.coverUrl" :width="48" :height="48" />
              <span v-else>-</span>
            </template>
          </el-table-column>
          <el-table-column label="标签" prop="policyTagName" width="140" />
          <el-table-column label="发布单位" prop="sourceOrg" width="180" />
          <el-table-column label="审核" prop="auditStatus" width="100">
            <template #default="scope"><dict-tag :options="emp_audit_status" :value="scope.row.auditStatus" /></template>
          </el-table-column>
          <el-table-column label="操作" width="280">
            <template #default="scope">
              <el-button link type="primary" @click="openPolicyDialog(scope.row)">编辑</el-button>
              <el-button link type="success" @click="auditPolicyRow(scope.row, '1')">通过</el-button>
              <el-button link type="warning" @click="auditPolicyRow(scope.row, '2')">驳回</el-button>
              <el-button link type="danger" @click="removePolicy(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="申请处理" name="apply">
        <div class="mb8">
          <el-button type="primary" plain icon="Plus" @click="openApplyDialog()" v-hasPermi="['employment:review:positionAudit']">新增申请</el-button>
        </div>
        <el-table v-loading="loading.apply" :data="applyList">
          <el-table-column label="用户" prop="userName" width="120" />
          <el-table-column label="岗位" prop="positionName" min-width="180" />
          <el-table-column label="企业" prop="companyName" min-width="160" />
          <el-table-column label="状态" prop="applyStatus" width="110">
            <template #default="scope"><dict-tag :options="emp_apply_status" :value="scope.row.applyStatus" /></template>
          </el-table-column>
          <el-table-column label="申请时间" prop="applyTime" width="170" />
          <el-table-column label="操作" width="340">
            <template #default="scope">
              <el-button link type="primary" @click="openApplyDialog(scope.row)">编辑</el-button>
              <el-button link type="primary" @click="setApplyStatus(scope.row, '1')">面试中</el-button>
              <el-button link type="success" @click="setApplyStatus(scope.row, '2')">录用</el-button>
              <el-button link type="danger" @click="setApplyStatus(scope.row, '3')">不通过</el-button>
              <el-button link type="danger" @click="removeApply(scope.row)">删除</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>

    <el-dialog :title="positionForm.positionId ? '编辑岗位' : '新增岗位'" v-model="positionOpen" width="680px">
      <el-form :model="positionForm" label-width="90px">
        <el-form-item label="岗位名称"><el-input v-model="positionForm.positionName" /></el-form-item>
        <el-form-item label="企业名称"><el-input v-model="positionForm.companyName" /></el-form-item>
        <el-form-item label="岗位分类">
          <el-select v-model="positionForm.categoryCode" placeholder="请选择分类">
            <el-option v-for="item in jobCategoryOptions" :key="item.categoryCode" :label="item.categoryName" :value="item.categoryCode" />
          </el-select>
        </el-form-item>
        <el-form-item label="薪资范围">
          <el-row :gutter="10" style="width: 100%">
            <el-col :span="11">
              <el-input-number v-model="salaryMin" :min="0" :precision="0" controls-position="right" style="width: 100%" placeholder="最低薪资" />
            </el-col>
            <el-col :span="2" style="text-align: center; line-height: 32px">~</el-col>
            <el-col :span="11">
              <el-input-number v-model="salaryMax" :min="0" :precision="0" controls-position="right" style="width: 100%" placeholder="最高薪资" />
            </el-col>
          </el-row>
          <div style="color: #909399; font-size: 12px; margin-top: 6px">单位：元/月</div>
        </el-form-item>
        <el-form-item label="工作地点"><el-input v-model="positionForm.workAddress" /></el-form-item>
        <el-form-item label="岗位要求"><el-input v-model="positionForm.requirementText" type="textarea" rows="3" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitPosition">确 定</el-button>
        <el-button @click="positionOpen = false">取 消</el-button>
      </template>
    </el-dialog>

    <el-dialog :title="trainingForm.trainingId ? '编辑培训' : '新增培训'" v-model="trainingOpen" width="760px">
      <el-form :model="trainingForm" label-width="90px">
        <el-form-item label="培训主题"><el-input v-model="trainingForm.title" /></el-form-item>
        <el-form-item label="培训分类">
          <el-select v-model="trainingForm.categoryCode" placeholder="请选择分类">
            <el-option v-for="item in trainingCategoryOptions" :key="item.categoryCode" :label="item.categoryName" :value="item.categoryCode" />
          </el-select>
        </el-form-item>
        <el-form-item label="讲师名称"><el-input v-model="trainingForm.teacherName" /></el-form-item>
        <el-form-item label="培训地点"><el-input v-model="trainingForm.location" /></el-form-item>
        <el-form-item label="培训时间">
          <el-row :gutter="10" style="width: 100%">
            <el-col :span="12">
              <el-date-picker v-model="trainingForm.startTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" placeholder="开始时间" style="width: 100%" />
            </el-col>
            <el-col :span="12">
              <el-date-picker v-model="trainingForm.endTime" type="datetime" value-format="YYYY-MM-DD HH:mm:ss" placeholder="结束时间" style="width: 100%" />
            </el-col>
          </el-row>
        </el-form-item>
        <el-form-item label="报名名额"><el-input-number v-model="trainingForm.quota" :min="1" :max="9999" style="width: 100%" /></el-form-item>
        <el-form-item label="状态">
          <el-radio-group v-model="trainingForm.status">
            <el-radio value="0">可报名</el-radio>
            <el-radio value="1">已结束</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="简介"><el-input v-model="trainingForm.introduction" type="textarea" rows="4" /></el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitTraining">确 定</el-button>
        <el-button @click="trainingOpen = false">取 消</el-button>
      </template>
    </el-dialog>

    <el-dialog :title="trainingRecordForm.recordId ? '编辑培训记录' : '新增培训记录'" v-model="trainingRecordOpen" width="620px">
      <el-form :model="trainingRecordForm" label-width="90px">
        <el-form-item label="培训计划">
          <el-select v-model="trainingRecordForm.trainingId" placeholder="请选择培训" style="width: 100%" filterable>
            <el-option v-for="item in trainingList" :key="item.trainingId" :label="`${item.title}（ID:${item.trainingId}）`" :value="item.trainingId" />
          </el-select>
        </el-form-item>
        <el-form-item label="选择用户">
          <el-select
            v-model="trainingRecordForm.userId"
            filterable
            remote
            reserve-keyword
            clearable
            placeholder="请输入用户名搜索"
            :remote-method="searchTrainingRecordUsers"
            :loading="trainingRecordUserLoading"
            style="width: 100%"
          >
            <el-option
              v-for="item in trainingRecordUserOptions"
              :key="item.userId"
              :label="`${item.userName}（ID:${item.userId}）`"
              :value="item.userId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="记录状态">
          <el-select v-model="trainingRecordForm.recordStatus" placeholder="请选择状态" style="width: 100%">
            <el-option v-for="item in trainingRecordStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitTrainingRecord">确 定</el-button>
        <el-button @click="trainingRecordOpen = false">取 消</el-button>
      </template>
    </el-dialog>

    <el-dialog :title="policyForm.policyId ? '编辑政策' : '新增政策'" v-model="policyOpen" width="760px">
      <el-form :model="policyForm" label-width="90px">
        <el-form-item label="政策标题"><el-input v-model="policyForm.title" /></el-form-item>
        <el-form-item label="政策标签">
          <el-select v-model="policyForm.policyTag" placeholder="请选择政策标签">
            <el-option v-for="item in policyTagOptions" :key="item.categoryCode" :label="item.categoryName" :value="item.categoryCode" />
          </el-select>
        </el-form-item>
        <el-form-item label="发布单位"><el-input v-model="policyForm.sourceOrg" /></el-form-item>
        <el-form-item label="摘要"><el-input v-model="policyForm.summary" type="textarea" rows="2" /></el-form-item>
        <el-form-item label="封面图">
          <image-upload
            v-model="policyForm.coverUrl"
            action="/common/upload/image"
            :limit="1"
            :file-size="5"
            :file-type="['png', 'jpg', 'jpeg']"
          />
        </el-form-item>
        <el-form-item label="正文">
          <editor v-model="policyForm.content" :min-height="260" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitPolicy">确 定</el-button>
        <el-button @click="policyOpen = false">取 消</el-button>
      </template>
    </el-dialog>

    <el-dialog :title="applyForm.applyId ? '编辑申请' : '新增申请'" v-model="applyOpen" width="620px">
      <el-form :model="applyForm" label-width="90px">
        <el-form-item label="岗位">
          <el-select v-model="applyForm.positionId" placeholder="请选择岗位" style="width: 100%" filterable>
            <el-option v-for="item in positionList" :key="item.positionId" :label="`${item.positionName}（${item.companyName}）`" :value="item.positionId" />
          </el-select>
        </el-form-item>
        <el-form-item label="用户">
          <el-select
            v-model="applyForm.userId"
            filterable
            remote
            reserve-keyword
            clearable
            placeholder="请输入用户名搜索"
            :remote-method="searchApplyUsers"
            :loading="applyUserLoading"
            style="width: 100%"
          >
            <el-option
              v-for="item in applyUserOptions"
              :key="item.userId"
              :label="`${item.userName}（ID:${item.userId}）`"
              :value="item.userId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="申请状态">
          <el-select v-model="applyForm.applyStatus" placeholder="请选择状态" style="width: 100%">
            <el-option v-for="item in emp_apply_status" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="补充说明">
          <el-input v-model="applyForm.resumeNote" type="textarea" :rows="2" />
        </el-form-item>
        <el-form-item label="审核备注">
          <el-input v-model="applyForm.auditRemark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitApply">确 定</el-button>
        <el-button @click="applyOpen = false">取 消</el-button>
      </template>
    </el-dialog>

    <el-dialog :title="consultForm.consultId ? '编辑咨询' : '新增咨询'" v-model="consultOpen" width="700px">
      <el-form :model="consultForm" label-width="90px">
        <el-form-item label="用户">
          <el-select
            v-model="consultForm.userId"
            filterable
            remote
            reserve-keyword
            clearable
            placeholder="请输入用户名搜索"
            :remote-method="searchConsultUsers"
            :loading="consultUserLoading"
            style="width: 100%"
          >
            <el-option
              v-for="item in consultUserOptions"
              :key="item.userId"
              :label="`${item.userName}（ID:${item.userId}）`"
              :value="item.userId"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="咨询类型">
          <el-select v-model="consultForm.consultType" placeholder="请选择类型" style="width: 100%">
            <el-option v-for="item in emp_consult_type" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="咨询问题">
          <el-input v-model="consultForm.questionContent" type="textarea" :rows="4" />
        </el-form-item>
        <el-form-item label="咨询状态">
          <el-select v-model="consultForm.consultStatus" placeholder="请选择状态" style="width: 100%">
            <el-option v-for="item in emp_consult_status" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="审核状态">
          <el-select v-model="consultForm.auditStatus" placeholder="请选择审核状态" style="width: 100%">
            <el-option v-for="item in emp_audit_status" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="审核备注">
          <el-input v-model="consultForm.auditRemark" type="textarea" :rows="2" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitConsult">确 定</el-button>
        <el-button @click="consultOpen = false">取 消</el-button>
      </template>
    </el-dialog>

    <el-dialog title="回复咨询" v-model="consultReplyOpen" width="820px">
      <el-form :model="consultReplyForm" label-width="90px">
        <el-form-item label="咨询问题">
          <el-input :model-value="consultReplyForm.questionContent" type="textarea" :rows="3" readonly />
        </el-form-item>
        <el-form-item label="回复内容">
          <editor v-model="consultReplyForm.answerContent" :min-height="260" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitConsultReply">确 定</el-button>
        <el-button @click="consultReplyOpen = false">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="EmploymentReview">
import { listCategory } from "@/api/employment/category";
import { listUser } from "@/api/system/user";
import {
  addApply,
  addConsult,
  addPolicy,
  addPosition,
  addTrainingRecord,
  addTraining,
  auditConsult,
  auditPolicy,
  auditPosition,
  auditTraining,
  delApply,
  delConsult,
  delTrainingRecord,
  delPolicy,
  delPosition,
  delTraining,
  listApply,
  listConsult,
  listPolicy,
  listPosition,
  listTraining,
  listTrainingRecord,
  replyConsult,
  updateApply,
  updateApplyStatus,
  updateConsult,
  updatePolicy,
  updatePosition,
  updateTrainingRecord,
  updateTraining,
  updateTrainingRecordStatus
} from "@/api/employment/review";

const { proxy } = getCurrentInstance();
const route = useRoute();
const { emp_audit_status, emp_apply_status, emp_consult_status, emp_consult_type, emp_training_status } = proxy.useDict(
  "emp_audit_status",
  "emp_apply_status",
  "emp_consult_status",
  "emp_consult_type",
  "emp_training_status"
);

const activeTab = ref("position");
const loading = reactive({ position: false, training: false, trainingRecord: false, consult: false, policy: false, apply: false });

const positionList = ref([]);
const trainingList = ref([]);
const trainingRecordList = ref([]);
const consultList = ref([]);
const policyList = ref([]);
const applyList = ref([]);

const jobCategoryOptions = ref([]);
const trainingCategoryOptions = ref([]);
const policyTagOptions = ref([]);
const trainingRecordUserOptions = ref([]);
const trainingRecordUserLoading = ref(false);
const applyUserOptions = ref([]);
const applyUserLoading = ref(false);
const consultUserOptions = ref([]);
const consultUserLoading = ref(false);

const positionOpen = ref(false);
const trainingOpen = ref(false);
const trainingRecordOpen = ref(false);
const policyOpen = ref(false);
const applyOpen = ref(false);
const consultOpen = ref(false);
const consultReplyOpen = ref(false);

const positionForm = ref({});
const trainingForm = ref({});
const trainingRecordForm = ref({});
const policyForm = ref({});
const applyForm = ref({});
const consultForm = ref({});
const consultReplyForm = ref({ consultId: undefined, questionContent: "", answerContent: "" });

const salaryMin = ref(undefined);
const salaryMax = ref(undefined);
const trainingRecordStatusOptions = [
  { label: "已报名", value: "0" },
  { label: "已完成", value: "1" },
  { label: "缺席", value: "2" }
];
const reviewTabSet = new Set(["position", "training", "trainingRecord", "consult", "policy", "apply"]);

function normalizeReviewTab(tab) {
  const value = String(tab || "").trim();
  return reviewTabSet.has(value) ? value : "";
}

function syncActiveTabFromRoute() {
  const tab = normalizeReviewTab(route.query.tab);
  if (tab) {
    activeTab.value = tab;
  }
}

function parseSalaryRange(salaryRange) {
  const raw = String(salaryRange || "").trim();
  if (!raw) return { min: undefined, max: undefined };
  const match = raw.match(/(\d+)\s*[-~]\s*(\d+)/);
  if (!match) return { min: undefined, max: undefined };
  return { min: Number(match[1]), max: Number(match[2]) };
}

function syncSalaryInputsFromForm() {
  const { min, max } = parseSalaryRange(positionForm.value.salaryRange);
  salaryMin.value = min;
  salaryMax.value = max;
}

function syncSalaryRangeToForm() {
  if (salaryMin.value === undefined || salaryMax.value === undefined) {
    positionForm.value.salaryRange = "";
    return;
  }
  positionForm.value.salaryRange = `${Number(salaryMin.value)}-${Number(salaryMax.value)}`;
}

async function loadCategories() {
  const [jobRes, trainingRes, policyRes] = await Promise.all([
    listCategory({ categoryType: "1", status: "0", pageNum: 1, pageSize: 200 }),
    listCategory({ categoryType: "2", status: "0", pageNum: 1, pageSize: 200 }),
    listCategory({ categoryType: "3", status: "0", pageNum: 1, pageSize: 200 })
  ]);
  jobCategoryOptions.value = jobRes.rows || [];
  trainingCategoryOptions.value = trainingRes.rows || [];
  policyTagOptions.value = policyRes.rows || [];
}

function loadPositions() {
  loading.position = true;
  listPosition({ pageNum: 1, pageSize: 50 }).then((res) => {
    positionList.value = res.rows || [];
  }).finally(() => {
    loading.position = false;
  });
}

function loadTrainings() {
  loading.training = true;
  listTraining({ pageNum: 1, pageSize: 50 }).then((res) => {
    trainingList.value = res.rows || [];
  }).finally(() => {
    loading.training = false;
  });
}

function loadTrainingRecords() {
  loading.trainingRecord = true;
  listTrainingRecord({ pageNum: 1, pageSize: 50 }).then((res) => {
    trainingRecordList.value = res.rows || [];
  }).finally(() => {
    loading.trainingRecord = false;
  });
}

function loadConsults() {
  loading.consult = true;
  listConsult({ pageNum: 1, pageSize: 50 }).then((res) => {
    consultList.value = res.rows || [];
  }).finally(() => {
    loading.consult = false;
  });
}

function loadPolicies() {
  loading.policy = true;
  listPolicy({ pageNum: 1, pageSize: 50 }).then((res) => {
    policyList.value = res.rows || [];
  }).finally(() => {
    loading.policy = false;
  });
}

function loadApplies() {
  loading.apply = true;
  listApply({ pageNum: 1, pageSize: 50 }).then((res) => {
    applyList.value = res.rows || [];
  }).finally(() => {
    loading.apply = false;
  });
}

function loadTab() {
  if (activeTab.value === "position") loadPositions();
  if (activeTab.value === "training") loadTrainings();
  if (activeTab.value === "trainingRecord") loadTrainingRecords();
  if (activeTab.value === "consult") loadConsults();
  if (activeTab.value === "policy") loadPolicies();
  if (activeTab.value === "apply") loadApplies();
}

function openPositionDialog(row) {
  positionForm.value = row
    ? { ...row }
    : { auditStatus: "0", publishStatus: "0", positionName: "", companyName: "", categoryCode: "", salaryRange: "", workAddress: "", requirementText: "" };
  syncSalaryInputsFromForm();
  positionOpen.value = true;
}

function submitPosition() {
  if (salaryMin.value === undefined || salaryMax.value === undefined) {
    proxy.$modal.msgError("请填写完整薪资范围");
    return;
  }
  if (Number(salaryMin.value) > Number(salaryMax.value)) {
    proxy.$modal.msgError("最低薪资不能大于最高薪资");
    return;
  }
  syncSalaryRangeToForm();
  const api = positionForm.value.positionId ? updatePosition : addPosition;
  api(positionForm.value).then(() => {
    proxy.$modal.msgSuccess(positionForm.value.positionId ? "修改成功" : "新增成功");
    positionOpen.value = false;
    loadPositions();
  });
}

function auditPositionRow(row, status) {
  auditPosition({ id: row.positionId, auditStatus: status, auditRemark: status === "1" ? "通过" : "驳回" }).then(() => {
    proxy.$modal.msgSuccess("审核完成");
    loadPositions();
  });
}

function removePosition(row) {
  proxy.$modal.confirm(`确认删除岗位 ${row.positionName} 吗？`).then(() => delPosition(row.positionId)).then(() => {
    proxy.$modal.msgSuccess("删除成功");
    loadPositions();
  });
}

function openTrainingDialog(row) {
  trainingForm.value = row
    ? { ...row }
    : { status: "0", auditStatus: "0", quota: 30, signupCount: 0, title: "", categoryCode: "", teacherName: "", location: "", introduction: "" };
  trainingOpen.value = true;
}

function submitTraining() {
  if (!trainingForm.value.title) {
    proxy.$modal.msgError("Please input training title");
    return;
  }
  if (!trainingForm.value.categoryCode) {
    proxy.$modal.msgError("Please select training category");
    return;
  }
  if (!trainingForm.value.startTime || !trainingForm.value.endTime) {
    proxy.$modal.msgError("Please select complete training time");
    return;
  }
  if (String(trainingForm.value.startTime) >= String(trainingForm.value.endTime)) {
    proxy.$modal.msgError("End time must be later than start time");
    return;
  }
  const api = trainingForm.value.trainingId ? updateTraining : addTraining;
  api(trainingForm.value).then(() => {
    proxy.$modal.msgSuccess(trainingForm.value.trainingId ? "修改成功" : "新增成功");
    trainingOpen.value = false;
    loadTrainings();
  });
}

function auditTrainingRow(row, status) {
  auditTraining({ id: row.trainingId, auditStatus: status, auditRemark: status === "1" ? "通过" : "驳回" }).then(() => {
    proxy.$modal.msgSuccess("审核完成");
    loadTrainings();
  });
}

function removeTraining(row) {
  proxy.$modal.confirm(`确认删除培训 ${row.title} 吗？`).then(() => delTraining(row.trainingId)).then(() => {
    proxy.$modal.msgSuccess("删除成功");
    loadTrainings();
  });
}

function setTrainingRecordStatus(row, status) {
  updateTrainingRecordStatus({ recordId: row.recordId, recordStatus: status }).then(() => {
    proxy.$modal.msgSuccess("记录状态已更新");
    loadTrainingRecords();
  });
}

function openTrainingRecordDialog(row) {
  Promise.all([ensureTrainingOptions(), ensureTrainingRecordUserOptions()]).then(() => {
    trainingRecordForm.value = row
      ? { recordId: row.recordId, trainingId: row.trainingId, userId: row.userId, recordStatus: row.recordStatus || "0" }
      : { recordId: undefined, trainingId: undefined, userId: undefined, recordStatus: "0" };
    if (row?.userId) {
      ensureTrainingRecordUserItem(row.userId, row.userName);
    }
    trainingRecordOpen.value = true;
  });
}

function ensureTrainingOptions() {
  if (trainingList.value.length > 0) {
    return Promise.resolve();
  }
  return listTraining({ pageNum: 1, pageSize: 500 }).then((res) => {
    trainingList.value = res.rows || [];
  });
}

function ensureTrainingRecordUserOptions() {
  if (trainingRecordUserOptions.value.length > 0) {
    return Promise.resolve();
  }
  return searchTrainingRecordUsers("");
}

function searchTrainingRecordUsers(keyword) {
  trainingRecordUserLoading.value = true;
  return listUser({
    pageNum: 1,
    pageSize: 20,
    userName: String(keyword || "").trim(),
    status: "0"
  }).then((res) => {
    const rows = res.rows || [];
    trainingRecordUserOptions.value = rows.map((item) => ({
      userId: Number(item.userId),
      userName: item.userName
    }));
  }).finally(() => {
    trainingRecordUserLoading.value = false;
  });
}

function ensureTrainingRecordUserItem(userId, userName) {
  const id = Number(userId);
  if (!id) {
    return;
  }
  const exists = trainingRecordUserOptions.value.some((item) => Number(item.userId) === id);
  if (!exists) {
    trainingRecordUserOptions.value.unshift({
      userId: id,
      userName: userName || `用户${id}`
    });
  }
}

function ensurePositionOptions() {
  if (positionList.value.length > 0) {
    return Promise.resolve();
  }
  return listPosition({ pageNum: 1, pageSize: 500 }).then((res) => {
    positionList.value = res.rows || [];
  });
}

function searchUsers(keyword, optionsRef, loadingRef) {
  loadingRef.value = true;
  return listUser({
    pageNum: 1,
    pageSize: 20,
    userName: String(keyword || "").trim(),
    status: "0"
  }).then((res) => {
    const rows = res.rows || [];
    optionsRef.value = rows.map((item) => ({
      userId: Number(item.userId),
      userName: item.userName
    }));
  }).finally(() => {
    loadingRef.value = false;
  });
}

function ensureUserItem(optionsRef, userId, userName) {
  const id = Number(userId);
  if (!id) {
    return;
  }
  const exists = optionsRef.value.some((item) => Number(item.userId) === id);
  if (!exists) {
    optionsRef.value.unshift({
      userId: id,
      userName: userName || `用户${id}`
    });
  }
}

function searchApplyUsers(keyword) {
  return searchUsers(keyword, applyUserOptions, applyUserLoading);
}

function ensureApplyUserOptions() {
  if (applyUserOptions.value.length > 0) {
    return Promise.resolve();
  }
  return searchApplyUsers("");
}

function ensureApplyUserItem(userId, userName) {
  ensureUserItem(applyUserOptions, userId, userName);
}

function searchConsultUsers(keyword) {
  return searchUsers(keyword, consultUserOptions, consultUserLoading);
}

function ensureConsultUserOptions() {
  if (consultUserOptions.value.length > 0) {
    return Promise.resolve();
  }
  return searchConsultUsers("");
}

function ensureConsultUserItem(userId, userName) {
  ensureUserItem(consultUserOptions, userId, userName);
}

function submitTrainingRecord() {
  if (!trainingRecordForm.value.trainingId) {
    proxy.$modal.msgError("请选择培训计划");
    return;
  }
  if (!trainingRecordForm.value.userId) {
    proxy.$modal.msgError("请填写用户ID");
    return;
  }
  const payload = {
    ...trainingRecordForm.value,
    trainingId: Number(trainingRecordForm.value.trainingId),
    userId: Number(trainingRecordForm.value.userId)
  };
  const api = payload.recordId ? updateTrainingRecord : addTrainingRecord;
  api(payload).then(() => {
    proxy.$modal.msgSuccess(payload.recordId ? "修改成功" : "新增成功");
    trainingRecordOpen.value = false;
    loadTrainingRecords();
  });
}

function removeTrainingRecord(row) {
  proxy.$modal.confirm(`确认删除培训记录 ID=${row.recordId} 吗？`).then(() => delTrainingRecord(row.recordId)).then(() => {
    proxy.$modal.msgSuccess("删除成功");
    loadTrainingRecords();
  });
}

function getTrainingRecordStatusText(status) {
  if (status === "0") return "已报名";
  if (status === "1") return "已完成";
  if (status === "2") return "缺席";
  return "未知";
}

function getTrainingRecordStatusType(status) {
  if (status === "0") return "info";
  if (status === "1") return "success";
  if (status === "2") return "danger";
  return "info";
}

function openPolicyDialog(row) {
  policyForm.value = row ? { ...row } : { auditStatus: "0", status: "0", coverUrl: "", content: "" };
  policyOpen.value = true;
}

function submitPolicy() {
  const title = String(policyForm.value.title || "").trim();
  const policyTag = String(policyForm.value.policyTag || "").trim();
  const sourceOrg = String(policyForm.value.sourceOrg || "").trim();
  const contentText = String(policyForm.value.content || "")
    .replace(/<p><br><\/p>/gi, "")
    .replace(/&nbsp;/gi, "")
    .replace(/<[^>]+>/g, "")
    .trim();

  if (!title) {
    proxy.$modal.msgError("请填写政策标题");
    return;
  }
  if (!policyTag) {
    proxy.$modal.msgError("请选择政策标签");
    return;
  }
  if (!sourceOrg) {
    proxy.$modal.msgError("请填写发布单位");
    return;
  }
  if (!contentText) {
    proxy.$modal.msgError("请填写政策正文");
    return;
  }

  const api = policyForm.value.policyId ? updatePolicy : addPolicy;
  api(policyForm.value).then(() => {
    proxy.$modal.msgSuccess(policyForm.value.policyId ? "修改成功" : "新增成功");
    policyOpen.value = false;
    loadPolicies();
  });
}

function auditPolicyRow(row, status) {
  auditPolicy({ id: row.policyId, auditStatus: status, auditRemark: status === "1" ? "通过" : "驳回" }).then(() => {
    proxy.$modal.msgSuccess("审核完成");
    loadPolicies();
  });
}

function removePolicy(row) {
  proxy.$modal.confirm(`确认删除政策 ${row.title} 吗？`).then(() => delPolicy(row.policyId)).then(() => {
    proxy.$modal.msgSuccess("删除成功");
    loadPolicies();
  });
}

function openConsultDialog(row) {
  ensureConsultUserOptions().then(() => {
    consultForm.value = row
      ? {
          consultId: row.consultId,
          userId: row.userId,
          consultType: row.consultType || "",
          questionContent: row.questionContent || "",
          consultStatus: row.consultStatus || "0",
          auditStatus: row.auditStatus || "0",
          auditRemark: row.auditRemark || ""
        }
      : { consultId: undefined, userId: undefined, consultType: "", questionContent: "", consultStatus: "0", auditStatus: "0", auditRemark: "" };
    if (row?.userId) {
      ensureConsultUserItem(row.userId, row.userName);
    }
    consultOpen.value = true;
  });
}

function submitConsult() {
  if (!consultForm.value.userId) {
    proxy.$modal.msgError("请选择用户");
    return;
  }
  if (!consultForm.value.consultType) {
    proxy.$modal.msgError("请选择咨询类型");
    return;
  }
  if (!String(consultForm.value.questionContent || "").trim()) {
    proxy.$modal.msgError("请填写咨询问题");
    return;
  }
  const payload = {
    ...consultForm.value,
    userId: Number(consultForm.value.userId)
  };
  const api = payload.consultId ? updateConsult : addConsult;
  api(payload).then(() => {
    proxy.$modal.msgSuccess(payload.consultId ? "修改成功" : "新增成功");
    consultOpen.value = false;
    loadConsults();
  });
}

function removeConsult(row) {
  proxy.$modal.confirm(`确认删除咨询 ID=${row.consultId} 吗？`).then(() => delConsult(row.consultId)).then(() => {
    proxy.$modal.msgSuccess("删除成功");
    loadConsults();
  });
}

function auditConsultRow(row, status) {
  auditConsult({ id: row.consultId, auditStatus: status, auditRemark: status === "1" ? "通过" : "驳回" }).then(() => {
    proxy.$modal.msgSuccess("审核完成");
    loadConsults();
  });
}

function replyConsultRow(row) {
  consultReplyForm.value = {
    consultId: row.consultId,
    questionContent: row.questionContent || "",
    answerContent: row.answerContent || ""
  };
  consultReplyOpen.value = true;
}

function submitConsultReply() {
  const contentText = String(consultReplyForm.value.answerContent || "")
    .replace(/<p><br><\/p>/gi, "")
    .replace(/&nbsp;/gi, "")
    .replace(/<[^>]+>/g, "")
    .trim();
  if (!contentText) {
    proxy.$modal.msgError("请填写回复内容");
    return;
  }
  replyConsult({
    consultId: consultReplyForm.value.consultId,
    answerContent: consultReplyForm.value.answerContent
  }).then(() => {
    proxy.$modal.msgSuccess("回复成功");
    consultReplyOpen.value = false;
    loadConsults();
  });
}

function openApplyDialog(row) {
  Promise.all([ensurePositionOptions(), ensureApplyUserOptions()]).then(() => {
    applyForm.value = row
      ? {
          applyId: row.applyId,
          positionId: row.positionId,
          userId: row.userId,
          applyStatus: row.applyStatus || "0",
          resumeNote: row.resumeNote || "",
          auditRemark: row.auditRemark || ""
        }
      : { applyId: undefined, positionId: undefined, userId: undefined, applyStatus: "0", resumeNote: "", auditRemark: "" };
    if (row?.userId) {
      ensureApplyUserItem(row.userId, row.userName);
    }
    applyOpen.value = true;
  });
}

function submitApply() {
  if (!applyForm.value.positionId) {
    proxy.$modal.msgError("请选择岗位");
    return;
  }
  if (!applyForm.value.userId) {
    proxy.$modal.msgError("请选择用户");
    return;
  }
  const payload = {
    ...applyForm.value,
    positionId: Number(applyForm.value.positionId),
    userId: Number(applyForm.value.userId)
  };
  const api = payload.applyId ? updateApply : addApply;
  api(payload).then(() => {
    proxy.$modal.msgSuccess(payload.applyId ? "修改成功" : "新增成功");
    applyOpen.value = false;
    loadApplies();
  });
}

function removeApply(row) {
  proxy.$modal.confirm(`确认删除申请 ID=${row.applyId} 吗？`).then(() => delApply(row.applyId)).then(() => {
    proxy.$modal.msgSuccess("删除成功");
    loadApplies();
  });
}

function setApplyStatus(row, status) {
  const remarkMap = { "1": "进入面试", "2": "通过录用", "3": "审核未通过" };
  updateApplyStatus({ applyId: row.applyId, applyStatus: status, auditRemark: remarkMap[status] || "状态已更新" }).then(() => {
    proxy.$modal.msgSuccess("状态已更新");
    loadApplies();
  });
}

syncActiveTabFromRoute();
watch(() => route.query.tab, () => {
  const oldTab = activeTab.value;
  syncActiveTabFromRoute();
  if (activeTab.value !== oldTab) {
    loadTab();
  }
});
loadCategories();
loadTab();
</script>
