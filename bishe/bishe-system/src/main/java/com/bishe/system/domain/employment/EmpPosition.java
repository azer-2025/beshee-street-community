package com.bishe.system.domain.employment;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.bishe.common.core.domain.BaseEntity;

public class EmpPosition extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long positionId;
    private String positionName;
    private String companyName;
    private String categoryCode;
    private String categoryName;
    private String salaryRange;
    private String workAddress;
    private String contactName;
    private String contactPhone;
    private String requirementText;
    private String auditStatus;
    private String publishStatus;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date publishTime;

    public Long getPositionId()
    {
        return positionId;
    }

    public void setPositionId(Long positionId)
    {
        this.positionId = positionId;
    }

    public String getPositionName()
    {
        return positionName;
    }

    public void setPositionName(String positionName)
    {
        this.positionName = positionName;
    }

    public String getCompanyName()
    {
        return companyName;
    }

    public void setCompanyName(String companyName)
    {
        this.companyName = companyName;
    }

    public String getCategoryCode()
    {
        return categoryCode;
    }

    public void setCategoryCode(String categoryCode)
    {
        this.categoryCode = categoryCode;
    }

    public String getCategoryName()
    {
        return categoryName;
    }

    public void setCategoryName(String categoryName)
    {
        this.categoryName = categoryName;
    }

    public String getSalaryRange()
    {
        return salaryRange;
    }

    public void setSalaryRange(String salaryRange)
    {
        this.salaryRange = salaryRange;
    }

    public String getWorkAddress()
    {
        return workAddress;
    }

    public void setWorkAddress(String workAddress)
    {
        this.workAddress = workAddress;
    }

    public String getContactName()
    {
        return contactName;
    }

    public void setContactName(String contactName)
    {
        this.contactName = contactName;
    }

    public String getContactPhone()
    {
        return contactPhone;
    }

    public void setContactPhone(String contactPhone)
    {
        this.contactPhone = contactPhone;
    }

    public String getRequirementText()
    {
        return requirementText;
    }

    public void setRequirementText(String requirementText)
    {
        this.requirementText = requirementText;
    }

    public String getAuditStatus()
    {
        return auditStatus;
    }

    public void setAuditStatus(String auditStatus)
    {
        this.auditStatus = auditStatus;
    }

    public String getPublishStatus()
    {
        return publishStatus;
    }

    public void setPublishStatus(String publishStatus)
    {
        this.publishStatus = publishStatus;
    }

    public Date getPublishTime()
    {
        return publishTime;
    }

    public void setPublishTime(Date publishTime)
    {
        this.publishTime = publishTime;
    }
}
