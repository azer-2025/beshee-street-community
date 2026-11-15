package com.bishe.system.domain.employment;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.bishe.common.annotation.Excel;
import com.bishe.common.core.domain.BaseEntity;

public class EmpFlowLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    @Excel(name = "日志ID")
    private Long flowId;

    @Excel(name = "业务类型", readConverterExp = "PROFILE=档案,APPLY=申请,TRAINING=培训,CONSULT=咨询,POLICY=政策")
    private String bizType;

    private Long bizId;

    private Long userId;

    @Excel(name = "目标用户")
    private String userName;

    @Excel(name = "动作类型", readConverterExp = "CREATE=新增,UPDATE=更新,AUDIT=审核,REPLY=回复,STATUS_CHANGE=状态变更")
    private String actionType;

    @Excel(name = "原状态")
    private String fromStatus;

    @Excel(name = "新状态")
    private String toStatus;

    @Excel(name = "动作详情")
    private String actionDetail;

    private Long operatorId;

    @Excel(name = "操作人")
    private String operatorName;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "操作时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date operateTime;

    /**
     * 趋势统计粒度：day-按天，week-按周
     */
    private String statType;

    public Long getFlowId()
    {
        return flowId;
    }

    public void setFlowId(Long flowId)
    {
        this.flowId = flowId;
    }

    public String getBizType()
    {
        return bizType;
    }

    public void setBizType(String bizType)
    {
        this.bizType = bizType;
    }

    public Long getBizId()
    {
        return bizId;
    }

    public void setBizId(Long bizId)
    {
        this.bizId = bizId;
    }

    public Long getUserId()
    {
        return userId;
    }

    public void setUserId(Long userId)
    {
        this.userId = userId;
    }

    public String getUserName()
    {
        return userName;
    }

    public void setUserName(String userName)
    {
        this.userName = userName;
    }

    public String getActionType()
    {
        return actionType;
    }

    public void setActionType(String actionType)
    {
        this.actionType = actionType;
    }

    public String getFromStatus()
    {
        return fromStatus;
    }

    public void setFromStatus(String fromStatus)
    {
        this.fromStatus = fromStatus;
    }

    public String getToStatus()
    {
        return toStatus;
    }

    public void setToStatus(String toStatus)
    {
        this.toStatus = toStatus;
    }

    public String getActionDetail()
    {
        return actionDetail;
    }

    public void setActionDetail(String actionDetail)
    {
        this.actionDetail = actionDetail;
    }

    public Long getOperatorId()
    {
        return operatorId;
    }

    public void setOperatorId(Long operatorId)
    {
        this.operatorId = operatorId;
    }

    public String getOperatorName()
    {
        return operatorName;
    }

    public void setOperatorName(String operatorName)
    {
        this.operatorName = operatorName;
    }

    public Date getOperateTime()
    {
        return operateTime;
    }

    public void setOperateTime(Date operateTime)
    {
        this.operateTime = operateTime;
    }

    public String getStatType()
    {
        return statType;
    }

    public void setStatType(String statType)
    {
        this.statType = statType;
    }
}
