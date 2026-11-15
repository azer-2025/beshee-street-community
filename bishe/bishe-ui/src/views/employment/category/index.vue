<template>
  <div class="app-container">
    <el-form ref="queryRef" :model="queryParams" :inline="true" v-show="showSearch">
      <el-form-item label="分类名称" prop="categoryName">
        <el-input v-model="queryParams.categoryName" placeholder="请输入分类名称" clearable style="width: 220px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="分类类型" prop="categoryType">
        <el-select v-model="queryParams.categoryType" placeholder="请选择分类类型" clearable style="width: 180px">
          <el-option v-for="item in emp_category_type" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
        <el-button icon="Refresh" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['employment:category:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate()" v-hasPermi="['employment:category:edit']">修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete()" v-hasPermi="['employment:category:remove']">删除</el-button>
      </el-col>
      <right-toolbar v-model:showSearch="showSearch" @queryTable="getList" />
    </el-row>

    <el-table v-loading="loading" :data="categoryList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
      <el-table-column label="ID" prop="categoryId" width="90" align="center" />
      <el-table-column label="分类类型" prop="categoryType" width="120">
        <template #default="scope">
          <dict-tag :options="emp_category_type" :value="scope.row.categoryType" />
        </template>
      </el-table-column>
      <el-table-column label="分类编码" prop="categoryCode" width="200">
        <template #default="scope">
          <span>{{ formatCategoryCode(scope.row) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="分类名称" prop="categoryName" />
      <el-table-column label="排序" prop="sortOrder" width="90" align="center" />
      <el-table-column label="状态" prop="status" width="100">
        <template #default="scope">
          <dict-tag :options="sys_normal_disable" :value="scope.row.status" />
        </template>
      </el-table-column>
      <el-table-column label="操作" width="180">
        <template #default="scope">
          <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['employment:category:edit']">修改</el-button>
          <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['employment:category:remove']">删除</el-button>
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

    <el-dialog :title="title" v-model="open" width="560px" append-to-body>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="分类类型" prop="categoryType">
          <el-select v-model="form.categoryType" placeholder="请选择分类类型" @change="handleCategoryTypeChange">
            <el-option v-for="item in emp_category_type" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>
        </el-form-item>
        <el-form-item label="分类编码" prop="categoryCode">
          <el-select v-model="form.categoryCode" placeholder="请选择分类编码" filterable clearable>
            <el-option
              v-for="item in categoryCodeOptions"
              :key="item.value"
              :label="`${item.label} (${item.value})`"
              :value="item.value"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="分类名称" prop="categoryName">
          <el-input v-model="form.categoryName" placeholder="请输入分类名称" />
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number v-model="form.sortOrder" :min="0" style="width: 100%" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio v-for="item in sys_normal_disable" :key="item.value" :value="item.value">{{ item.label }}</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="open = false">取 消</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="EmploymentCategory">
import { addCategory, delCategory, getCategory, listCategory, updateCategory } from "@/api/employment/category";

const { proxy } = getCurrentInstance();
const { emp_category_type, sys_normal_disable, emp_job_category_code, emp_training_category_code, emp_policy_tag_code } = proxy.useDict(
  "emp_category_type",
  "sys_normal_disable",
  "emp_job_category_code",
  "emp_training_category_code",
  "emp_policy_tag_code"
);

const loading = ref(false);
const showSearch = ref(true);
const total = ref(0);
const open = ref(false);
const title = ref("");
const categoryList = ref([]);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);

const data = reactive({
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    categoryType: undefined,
    categoryName: undefined
  },
  form: {},
  rules: {
    categoryType: [{ required: true, message: "请选择分类类型", trigger: "change" }],
    categoryCode: [{ required: true, message: "请选择分类编码", trigger: "change" }],
    categoryName: [{ required: true, message: "请输入分类名称", trigger: "blur" }]
  }
});

const { queryParams, form, rules } = toRefs(data);

const categoryCodeOptions = computed(() => {
  return getCategoryCodeOptions(form.value.categoryType);
});

function getCategoryCodeOptions(categoryType) {
  if (categoryType === "1") {
    return emp_job_category_code.value || [];
  }
  if (categoryType === "2") {
    return emp_training_category_code.value || [];
  }
  if (categoryType === "3") {
    return emp_policy_tag_code.value || [];
  }
  return [];
}

function formatCategoryCode(row) {
  const options = getCategoryCodeOptions(row.categoryType);
  const match = options.find((item) => item.value === row.categoryCode);
  return match ? `${match.label} (${row.categoryCode})` : row.categoryCode;
}

function handleCategoryTypeChange() {
  form.value.categoryCode = undefined;
}

watch(categoryCodeOptions, (options) => {
  if (!form.value.categoryCode || !options || options.length === 0) {
    return;
  }
  const exists = options.some((item) => item.value === form.value.categoryCode);
  if (!exists) {
    form.value.categoryCode = undefined;
  }
});

function reset() {
  form.value = {
    categoryId: undefined,
    categoryType: "1",
    categoryCode: undefined,
    categoryName: undefined,
    sortOrder: 0,
    status: "0"
  };
  proxy.resetForm("formRef");
}

function getList() {
  loading.value = true;
  listCategory(queryParams.value).then((res) => {
    categoryList.value = res.rows;
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
  ids.value = selection.map((item) => item.categoryId);
  single.value = selection.length !== 1;
  multiple.value = selection.length === 0;
}

function handleAdd() {
  reset();
  open.value = true;
  title.value = "新增服务分类";
}

function handleUpdate(row) {
  const categoryId = row?.categoryId || ids.value[0];
  if (!categoryId) {
    return;
  }
  reset();
  getCategory(categoryId).then((res) => {
    form.value = res.data;
    open.value = true;
    title.value = "修改服务分类";
  });
}

function submitForm() {
  proxy.$refs.formRef.validate((valid) => {
    if (!valid) {
      return;
    }
    const api = form.value.categoryId ? updateCategory : addCategory;
    api(form.value).then(() => {
      proxy.$modal.msgSuccess(form.value.categoryId ? "修改成功" : "新增成功");
      open.value = false;
      getList();
    });
  });
}

function handleDelete(row) {
  const categoryIds = row?.categoryId || ids.value;
  if (!categoryIds || (Array.isArray(categoryIds) && categoryIds.length === 0)) {
    return;
  }
  proxy.$modal.confirm(`确认删除分类 ${categoryIds} 吗？`).then(() => delCategory(categoryIds)).then(() => {
    proxy.$modal.msgSuccess("删除成功");
    getList();
  });
}

getList();
</script>
