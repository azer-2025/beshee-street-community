package com.bishe.common.core.domain.model;

/**
 * Register request body.
 */
public class RegisterBody extends LoginBody
{
    /**
     * Employment status (0 pending/unemployment registration, 1 tracking, 2 employed).
     */
    private String employmentStatus;

    public String getEmploymentStatus()
    {
        return employmentStatus;
    }

    public void setEmploymentStatus(String employmentStatus)
    {
        this.employmentStatus = employmentStatus;
    }
}
