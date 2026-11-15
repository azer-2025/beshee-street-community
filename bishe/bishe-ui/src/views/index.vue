<template>
  <div class="app-container home">
    <!-- 欢迎栏 -->
    <div class="welcome-banner">
      <div class="banner-text">
        <h1>您好，{{ userStore.name }}！</h1>
        <p>欢迎回到街道待就业人员管理服务系统，今天又是充满活力的一天。</p>
      </div>
      <div class="banner-img">
        <el-icon :size="100" color="#fff"><Sunny /></el-icon>
      </div>
    </div>

    <!-- 统计卡片 -->
    <el-row :gutter="20" class="stat-cards">
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card">
          <template #header>
            <div class="card-header">
              <span>待就业人员</span>
              <el-tag type="primary">总数</el-tag>
            </div>
          </template>
          <div class="stat-value">1,284</div>
          <div class="stat-footer">
            较上月 <span class="up">+12% <el-icon><CaretTop /></el-icon></span>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card">
          <template #header>
            <div class="card-header">
              <span>今日申请</span>
              <el-tag type="success">实时</el-tag>
            </div>
          </template>
          <div class="stat-value">42</div>
          <div class="stat-footer">
            较昨日 <span class="up">+5% <el-icon><CaretTop /></el-icon></span>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card">
          <template #header>
            <div class="card-header">
              <span>培训任务</span>
              <el-tag type="warning">进行中</el-tag>
            </div>
          </template>
          <div class="stat-value">15</div>
          <div class="stat-footer">
            <span>本周新增 3 项</span>
          </div>
        </el-card>
      </el-col>
      <el-col :span="6">
        <el-card shadow="hover" class="stat-card">
          <template #header>
            <div class="card-header">
              <span>未处理咨询</span>
              <el-tag type="danger">加急</el-tag>
            </div>
          </template>
          <div class="stat-value">8</div>
          <div class="stat-footer">
            <span>需立即跟进</span>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 内容区域 -->
    <el-row :gutter="20" class="content-row">
      <!-- 快捷入口 -->
      <el-col :span="16">
        <el-card class="main-card">
          <template #header>
            <div class="card-header">
              <span class="title">快捷办公入口</span>
            </div>
          </template>
          <div class="quick-links">
            <div class="link-item" @click="router.push('/system/user')">
              <div class="icon-box blue"><el-icon><User /></el-icon></div>
              <span>用户管理</span>
            </div>
            <div class="link-item" @click="router.push({ path: '/employment/review', query: { tab: 'apply' } })">
              <div class="icon-box green"><el-icon><Suitcase /></el-icon></div>
              <span>岗位申请</span>
            </div>
            <div class="link-item" @click="router.push({ path: '/employment/review', query: { tab: 'trainingRecord' } })">
              <div class="icon-box orange"><el-icon><Reading /></el-icon></div>
              <span>培训记录</span>
            </div>
            <div class="link-item" @click="router.push({ path: '/employment/review', query: { tab: 'consult' } })">
              <div class="icon-box red"><el-icon><ChatDotRound /></el-icon></div>
              <span>互动咨询</span>
            </div>
            <div class="link-item" @click="router.push({ path: '/employment/review', query: { tab: 'policy' } })">
              <div class="icon-box purple"><el-icon><Document /></el-icon></div>
              <span>政策资讯</span>
            </div>
            <div class="link-item" @click="router.push('/system/role')">
              <div class="icon-box cyan"><el-icon><Key /></el-icon></div>
              <span>角色权限</span>
            </div>
          </div>
        </el-card>

        <el-card class="main-card mt20">
          <template #header>
            <div class="card-header">
              <span class="title">系统公告</span>
              <el-button link type="primary" @click="goNoticePage">查看更多</el-button>
            </div>
          </template>
          <div class="notice-list" v-loading="noticeLoading">
            <template v-if="noticeList.length > 0">
              <div class="notice-item" v-for="item in noticeList" :key="item.noticeId">
                <el-tag :type="getNoticeTagType(item.noticeType)" size="small">
                  {{ getNoticeTypeLabel(item.noticeType) }}
                </el-tag>
                <span class="notice-title" :title="item.noticeTitle" @click="openNoticePage(item)">{{ item.noticeTitle }}</span>
                <span class="notice-time">{{ formatNoticeDate(item.createTime) }}</span>
              </div>
            </template>
            <el-empty v-else description="暂无系统公告" :image-size="56" />
          </div>
        </el-card>
      </el-col>

      <!-- 侧边信息 -->
      <el-col :span="8">
        <el-card class="side-card">
          <template #header>
            <div class="card-header">
              <span class="title">工作助手</span>
            </div>
          </template>
          <div class="calendar-placeholder">
            <el-calendar v-model="currentDate" />
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="Index">
import { listNotice } from '@/api/system/notice'
import useUserStore from '@/store/modules/user'

const userStore = useUserStore()
const router = useRouter()
const currentDate = ref(new Date())
const { proxy } = getCurrentInstance()
const { sys_notice_type } = proxy.useDict('sys_notice_type')
const noticeLoading = ref(false)
const noticeList = ref([])

function goNoticePage() {
  router.push('/system/notice')
}

function openNoticePage(item) {
  const noticeTitle = String(item?.noticeTitle || '').trim()
  if (!noticeTitle) {
    goNoticePage()
    return
  }
  router.push({
    path: '/system/notice',
    query: { noticeTitle }
  })
}

function getNoticeTypeLabel(noticeType) {
  const item = (sys_notice_type.value || []).find((dict) => String(dict.value) === String(noticeType))
  return item?.label || '公告'
}

function getNoticeTagType(noticeType) {
  const type = String(noticeType || '')
  if (type === '2') return 'warning'
  if (type === '3') return 'success'
  return ''
}

function formatNoticeDate(dateStr) {
  const value = String(dateStr || '').trim()
  if (!value) return '--'
  return value.split(' ')[0]
}

async function loadNoticeList() {
  noticeLoading.value = true
  try {
    const res = await listNotice({
      pageNum: 1,
      pageSize: 5,
      status: '0'
    })
    noticeList.value = res?.rows || []
  } finally {
    noticeLoading.value = false
  }
}

onMounted(() => {
  loadNoticeList()
})
</script>

<style scoped lang="scss">
.home {
  padding: 20px;
  background-color: #f5f7fa;
  min-height: calc(100vh - 84px);

  .mt20 { margin-top: 20px; }

  .welcome-banner {
    background: linear-gradient(135deg, #409eff 0%, #1a73e8 100%);
    border-radius: 12px;
    padding: 30px 40px;
    color: white;
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);

    h1 {
      margin: 0;
      font-size: 28px;
      font-weight: 600;
    }
    p {
      margin: 10px 0 0;
      opacity: 0.9;
      font-size: 16px;
    }
  }

  .stat-cards {
    margin-bottom: 24px;

    .stat-card {
      border: none;
      border-radius: 12px;
      transition: all 0.3s;
      
      &:hover {
        transform: translateY(-5px);
      }

      .card-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        font-weight: 600;
        color: #606266;
      }

      .stat-value {
        font-size: 30px;
        font-weight: bold;
        color: #303133;
        margin: 10px 0;
      }

      .stat-footer {
        font-size: 14px;
        color: #909399;

        .up { color: #f56c6c; font-weight: 600; }
        .down { color: #67c23a; font-weight: 600; }
      }
    }
  }

  .main-card, .side-card {
    border-radius: 12px;
    border: none;

    .card-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      .title {
        font-size: 18px;
        font-weight: 600;
        color: #303133;
        position: relative;
        padding-left: 12px;
        &::before {
          content: '';
          position: absolute;
          left: 0;
          top: 4px;
          bottom: 4px;
          width: 4px;
          background: #409eff;
          border-radius: 2px;
        }
      }
    }
  }

  .quick-links {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 20px;
    padding: 10px 0;

    .link-item {
      display: flex;
      flex-direction: column;
      align-items: center;
      cursor: pointer;
      transition: all 0.2s;
      padding: 15px;
      border-radius: 8px;

      &:hover {
        background-color: #f0f7ff;
        .icon-box { transform: scale(1.1); }
      }

      .icon-box {
        width: 54px;
        height: 54px;
        border-radius: 16px;
        display: flex;
        justify-content: center;
        align-items: center;
        margin-bottom: 10px;
        color: white;
        font-size: 24px;
        transition: all 0.3s;

        &.blue { background: #e0f2ff; color: #409eff; }
        &.green { background: #e7faf0; color: #67c23a; }
        &.orange { background: #fff3e6; color: #e6a23c; }
        &.red { background: #ffeded; color: #f56c6c; }
        &.purple { background: #f5f0ff; color: #722ed1; }
        &.cyan { background: #e6fffb; color: #13c2c2; }
      }

      span {
        font-size: 14px;
        color: #606266;
        font-weight: 500;
      }
    }
  }

  .notice-list {
    .notice-item {
      display: flex;
      align-items: center;
      padding: 12px 0;
      border-bottom: 1px solid #f0f2f5;
      &:last-child { border-bottom: none; }

      .notice-title {
        flex: 1;
        margin-left: 12px;
        font-size: 14px;
        color: #606266;
        cursor: pointer;
        &:hover { color: #409eff; }
      }

      .notice-time {
        font-size: 13px;
        color: #909399;
      }
    }
  }

  :deep(.el-calendar) {
    --el-calendar-cell-width: 40px;
    border: none;
    .el-calendar-table .el-calendar-day {
      height: 50px;
      padding: 4px;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .el-calendar__header {
      padding: 12px 0;
      border-bottom: 1px solid #f0f2f5;
    }
    .el-calendar__body {
      padding: 12px 0 0;
    }
  }
}
</style>
