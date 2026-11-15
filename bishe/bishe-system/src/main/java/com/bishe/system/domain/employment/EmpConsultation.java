package com.bishe.system.domain.employment;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.bishe.common.core.domain.BaseEntity;

public class EmpConsultation extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long consultId;
    private Long userId;
    private String userName;
    private String consultType;
    private String questionContent;
    private String answerContent;
    private Long answerBy;
    private String answerByName;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date answerTime;

    private String consultStatus;
    private String auditStatus;
    private String auditRemark;

    public Long getConsultId()
    {
        return consultId;
    }

    public void setConsultId(Long consultId)
    {
        this.consultId = consultId;
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

    public String getConsultType()
    {
        return consultType;
    }

    public void setConsultType(String consultType)
    {
        this.consultType = consultType;
    }

    public String getQuestionContent()
    {
        return questionContent;
    }

    public void setQuestionContent(String questionContent)
    {
        this.questionContent = questionContent;
    }

    public String getAnswerContent()
    {
        return answerContent;
    }

    public void setAnswerContent(String answerContent)
    {
        this.answerContent = answerContent;
    }

    public Long getAnswerBy()
    {
        return answerBy;
    }

    public void setAnswerBy(Long answerBy)
    {
        this.answerBy = answerBy;
    }

    public String getAnswerByName()
    {
        return answerByName;
    }

    public void setAnswerByName(String answerByName)
    {
        this.answerByName = answerByName;
    }

    public Date getAnswerTime()
    {
        return answerTime;
    }

    public void setAnswerTime(Date answerTime)
    {
        this.answerTime = answerTime;
    }

    public String getConsultStatus()
    {
        return consultStatus;
    }

    public void setConsultStatus(String consultStatus)
    {
        this.consultStatus = consultStatus;
    }

    public String getAuditStatus()
    {
        return auditStatus;
    }

    public void setAuditStatus(String auditStatus)
    {
        this.auditStatus = auditStatus;
    }

    public String getAuditRemark()
    {
        return auditRemark;
    }

    public void setAuditRemark(String auditRemark)
    {
        this.auditRemark = auditRemark;
    }
}
