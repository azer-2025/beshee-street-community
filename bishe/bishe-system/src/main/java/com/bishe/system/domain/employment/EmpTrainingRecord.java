package com.bishe.system.domain.employment;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.bishe.common.core.domain.BaseEntity;

public class EmpTrainingRecord extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long recordId;
    private Long trainingId;
    private Long userId;
    private String userName;
    private String trainingTitle;
    private String recordStatus;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date signupTime;

    public Long getRecordId()
    {
        return recordId;
    }

    public void setRecordId(Long recordId)
    {
        this.recordId = recordId;
    }

    public Long getTrainingId()
    {
        return trainingId;
    }

    public void setTrainingId(Long trainingId)
    {
        this.trainingId = trainingId;
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

    public String getTrainingTitle()
    {
        return trainingTitle;
    }

    public void setTrainingTitle(String trainingTitle)
    {
        this.trainingTitle = trainingTitle;
    }

    public String getRecordStatus()
    {
        return recordStatus;
    }

    public void setRecordStatus(String recordStatus)
    {
        this.recordStatus = recordStatus;
    }

    public Date getSignupTime()
    {
        return signupTime;
    }

    public void setSignupTime(Date signupTime)
    {
        this.signupTime = signupTime;
    }
}
