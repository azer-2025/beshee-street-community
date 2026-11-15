package com.bishe.system.domain.employment;

import com.bishe.common.core.domain.BaseEntity;

public class EmpUserProfile extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    private Long profileId;
    private Long userId;
    private String userName;
    private String realName;
    private String gender;
    private Integer age;
    private String phone;
    private String education;
    private String skillTags;
    private String certificateUrls;
    private String resumeAttachmentUrl;
    private String employmentStatus;
    private String auditStatus;
    private String idCard;
    private String address;
    private String introduction;

    public Long getProfileId()
    {
        return profileId;
    }

    public void setProfileId(Long profileId)
    {
        this.profileId = profileId;
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

    public String getRealName()
    {
        return realName;
    }

    public void setRealName(String realName)
    {
        this.realName = realName;
    }

    public String getGender()
    {
        return gender;
    }

    public void setGender(String gender)
    {
        this.gender = gender;
    }

    public Integer getAge()
    {
        return age;
    }

    public void setAge(Integer age)
    {
        this.age = age;
    }

    public String getPhone()
    {
        return phone;
    }

    public void setPhone(String phone)
    {
        this.phone = phone;
    }

    public String getEducation()
    {
        return education;
    }

    public void setEducation(String education)
    {
        this.education = education;
    }

    public String getSkillTags()
    {
        return skillTags;
    }

    public void setSkillTags(String skillTags)
    {
        this.skillTags = skillTags;
    }

    public String getCertificateUrls()
    {
        return certificateUrls;
    }

    public void setCertificateUrls(String certificateUrls)
    {
        this.certificateUrls = certificateUrls;
    }

    public String getResumeAttachmentUrl()
    {
        return resumeAttachmentUrl;
    }

    public void setResumeAttachmentUrl(String resumeAttachmentUrl)
    {
        this.resumeAttachmentUrl = resumeAttachmentUrl;
    }

    public String getEmploymentStatus()
    {
        return employmentStatus;
    }

    public void setEmploymentStatus(String employmentStatus)
    {
        this.employmentStatus = employmentStatus;
    }

    public String getAuditStatus()
    {
        return auditStatus;
    }

    public void setAuditStatus(String auditStatus)
    {
        this.auditStatus = auditStatus;
    }

    public String getIdCard()
    {
        return idCard;
    }

    public void setIdCard(String idCard)
    {
        this.idCard = idCard;
    }

    public String getAddress()
    {
        return address;
    }

    public void setAddress(String address)
    {
        this.address = address;
    }

    public String getIntroduction()
    {
        return introduction;
    }

    public void setIntroduction(String introduction)
    {
        this.introduction = introduction;
    }
}
