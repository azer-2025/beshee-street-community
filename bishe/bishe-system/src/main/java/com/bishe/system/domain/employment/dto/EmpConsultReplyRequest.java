package com.bishe.system.domain.employment.dto;

public class EmpConsultReplyRequest
{
    private Long consultId;
    private String answerContent;

    public Long getConsultId()
    {
        return consultId;
    }

    public void setConsultId(Long consultId)
    {
        this.consultId = consultId;
    }

    public String getAnswerContent()
    {
        return answerContent;
    }

    public void setAnswerContent(String answerContent)
    {
        this.answerContent = answerContent;
    }
}
