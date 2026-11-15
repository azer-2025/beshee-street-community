<template>
  <div class="app-container">
    <el-row :gutter="16">
      <el-col :xs="24" :md="12">
        <el-card shadow="never">
          <template #header>
            <span>角色覆盖分析</span>
          </template>
          <el-table :data="roleRows" v-loading="loadingRole">
            <el-table-column label="角色名称" prop="name" />
            <el-table-column label="人数" prop="value" width="120" align="center" />
          </el-table>
        </el-card>
      </el-col>
      <el-col :xs="24" :md="12">
        <el-card shadow="never">
          <template #header>
            <span>菜单权限覆盖分析</span>
          </template>
          <el-table :data="menuRows" v-loading="loadingMenu">
            <el-table-column label="权限菜单" prop="name" />
            <el-table-column label="授权角色数" prop="value" width="120" align="center" />
          </el-table>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="EmploymentPermission">
import { getMenuPermissionReport, getRolePermissionReport } from "@/api/employment/permission";

const loadingRole = ref(false);
const loadingMenu = ref(false);
const roleRows = ref([]);
const menuRows = ref([]);

function loadData() {
  loadingRole.value = true;
  loadingMenu.value = true;
  getRolePermissionReport().then((res) => {
    roleRows.value = res.data || [];
    loadingRole.value = false;
  });
  getMenuPermissionReport().then((res) => {
    menuRows.value = (res.data || []).slice(0, 30);
    loadingMenu.value = false;
  });
}

loadData();
</script>
