package com.bishe.system.domain.employment;

import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.bishe.common.core.domain.BaseEntity;

public class EmpPolicy extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long policyId;
    private String title;
    private String policyTag;
    private String policyTagName;
    private String coverUrl;
    private String summary;
    private String content;
    private String sourceOrg;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private Date publishTime;

    private String auditStatus;
    private String status;

    public Long getPolicyId()
    {
        return policyId;
    }

    public void setPolicyId(Long policyId)
    {
        this.policyId = policyId;
    }

    public String getTitle()
    {
        return title;
    }

    public void setTitle(String title)
    {
        this.title = title;
    }

    public String getPolicyTag()
    {
        return policyTag;
    }

    public void setPolicyTag(String policyTag)
    {
        this.policyTag = policyTag;
    }

    public String getPolicyTagName()
    {
        return policyTagName;
    }

    public void setPolicyTagName(String policyTagName)
    {
        this.policyTagName = policyTagName;
    }

    public String getCoverUrl()
    {
        return coverUrl;
    }

    public void setCoverUrl(String coverUrl)
    {
        this.coverUrl = coverUrl;
    }

    public String getSummary()
    {
        return summary;
    }

    public void setSummary(String summary)
    {
        this.summary = summary;
    }

    public String getContent()
    {
        return content;
    }

    public void setContent(String content)
    {
        this.content = content;
    }

    public String getSourceOrg()
    {
        return sourceOrg;
    }

    public void setSourceOrg(String sourceOrg)
    {
        this.sourceOrg = sourceOrg;
    }

    public Date getPublishTime()
    {
        return publishTime;
    }

    public void setPublishTime(Date publishTime)
    {
        this.publishTime = publishTime;
    }

    public String getAuditStatus()
    {
        return auditStatus;
    }

    public void setAuditStatus(String auditStatus)
    {
        this.auditStatus = auditStatus;
    }

    public String getStatus()
    {
        return status;
    }

    public void setStatus(String status)
    {
        this.status = status;
    }
}
