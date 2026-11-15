package com.bishe.framework.web.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;
import com.bishe.common.constant.CacheConstants;
import com.bishe.common.constant.Constants;
import com.bishe.common.constant.UserConstants;
import com.bishe.common.core.domain.entity.SysUser;
import com.bishe.common.core.domain.model.RegisterBody;
import com.bishe.common.core.redis.RedisCache;
import com.bishe.common.exception.ServiceException;
import com.bishe.common.exception.user.CaptchaException;
import com.bishe.common.exception.user.CaptchaExpireException;
import com.bishe.common.utils.DateUtils;
import com.bishe.common.utils.MessageUtils;
import com.bishe.common.utils.SecurityUtils;
import com.bishe.common.utils.StringUtils;
import com.bishe.framework.manager.AsyncManager;
import com.bishe.framework.manager.factory.AsyncFactory;
import com.bishe.system.domain.employment.EmpUserProfile;
import com.bishe.system.service.ISysConfigService;
import com.bishe.system.service.ISysUserService;
import com.bishe.system.service.employment.IEmpService;

/**
 * Registration service.
 */
@Component
public class SysRegisterService
{
    @Autowired
    private ISysUserService userService;

    @Autowired
    private ISysConfigService configService;

    @Autowired
    private RedisCache redisCache;

    @Autowired
    private IEmpService empService;

    /**
     * Register a user.
     */
    @Transactional(rollbackFor = Exception.class)
    public String register(RegisterBody registerBody)
    {
        String msg = "";
        String username = registerBody.getUsername();
        String password = registerBody.getPassword();
        SysUser sysUser = new SysUser();
        sysUser.setUserName(username);

        if (configService.selectCaptchaEnabled())
        {
            validateCaptcha(username, registerBody.getCode(), registerBody.getUuid());
        }

        if (StringUtils.isEmpty(username))
        {
            msg = "\u7528\u6237\u540d\u4e0d\u80fd\u4e3a\u7a7a";
        }
        else if (StringUtils.isEmpty(password))
        {
            msg = "\u7528\u6237\u5bc6\u7801\u4e0d\u80fd\u4e3a\u7a7a";
        }
        else if (username.length() < UserConstants.USERNAME_MIN_LENGTH
                || username.length() > UserConstants.USERNAME_MAX_LENGTH)
        {
            msg = "\u8d26\u6237\u957f\u5ea6\u5fc5\u987b\u57282\u523020\u4e2a\u5b57\u7b26\u4e4b\u95f4";
        }
        else if (password.length() < UserConstants.PASSWORD_MIN_LENGTH
                || password.length() > UserConstants.PASSWORD_MAX_LENGTH)
        {
            msg = "\u5bc6\u7801\u957f\u5ea6\u5fc5\u987b\u57285\u523020\u4e2a\u5b57\u7b26\u4e4b\u95f4";
        }
        else if (!userService.checkUserNameUnique(sysUser))
        {
            msg = "\u4fdd\u5b58\u7528\u6237'" + username + "'\u5931\u8d25\uff0c\u6ce8\u518c\u8d26\u53f7\u5df2\u5b58\u5728";
        }
        else
        {
            sysUser.setNickName(username);
            sysUser.setPwdUpdateDate(DateUtils.getNowDate());
            sysUser.setPassword(SecurityUtils.encryptPassword(password));
            if (!userService.registerUser(sysUser))
            {
                msg = "\u6ce8\u518c\u5931\u8d25\uff0c\u8bf7\u8054\u7cfb\u7cfb\u7edf\u7ba1\u7406\u5458";
            }
            else
            {
                createEmploymentProfile(sysUser, registerBody);
                AsyncManager.me().execute(
                        AsyncFactory.recordLogininfor(username, Constants.REGISTER, MessageUtils.message("user.register.success")));
            }
        }
        return msg;
    }

    /**
     * Validate captcha.
     */
    public void validateCaptcha(String username, String code, String uuid)
    {
        String verifyKey = CacheConstants.CAPTCHA_CODE_KEY + StringUtils.nvl(uuid, "");
        String captcha = redisCache.getCacheObject(verifyKey);
        redisCache.deleteObject(verifyKey);
        if (captcha == null)
        {
            throw new CaptchaExpireException();
        }
        if (!code.equalsIgnoreCase(captcha))
        {
            throw new CaptchaException();
        }
    }

    private void createEmploymentProfile(SysUser sysUser, RegisterBody registerBody)
    {
        EmpUserProfile profile = new EmpUserProfile();
        profile.setUserId(sysUser.getUserId());
        profile.setRealName(sysUser.getNickName());
        profile.setGender("2");
        profile.setEmploymentStatus(normalizeEmploymentStatus(registerBody.getEmploymentStatus()));
        profile.setAuditStatus("0");
        profile.setCreateBy(sysUser.getUserName());
        if (empService.insertProfile(profile) <= 0)
        {
            throw new ServiceException("\u6ce8\u518c\u5931\u8d25\uff0c\u4eba\u5458\u6863\u6848\u521b\u5efa\u5931\u8d25");
        }
    }

    private String normalizeEmploymentStatus(String employmentStatus)
    {
        if (StringUtils.equalsAny(employmentStatus, "0", "1", "2"))
        {
            return employmentStatus;
        }
        return "0";
    }
}
