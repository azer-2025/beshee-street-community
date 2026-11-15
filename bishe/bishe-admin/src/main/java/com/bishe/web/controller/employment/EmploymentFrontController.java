package com.bishe.web.controller.employment;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.bishe.common.annotation.Anonymous;
import com.bishe.common.core.controller.BaseController;
import com.bishe.common.core.domain.AjaxResult;
import com.bishe.common.core.domain.entity.SysUser;
import com.bishe.common.core.domain.model.LoginUser;
import com.bishe.common.core.page.TableDataInfo;
import com.bishe.common.utils.SecurityUtils;
import com.bishe.common.utils.StringUtils;
import com.bishe.system.domain.employment.EmpConsultation;
import com.bishe.system.domain.employment.EmpPolicy;
import com.bishe.system.domain.employment.EmpPosition;
import com.bishe.system.domain.employment.EmpPositionApply;
import com.bishe.system.domain.employment.EmpServiceCategory;
import com.bishe.system.domain.employment.EmpTraining;
import com.bishe.system.domain.employment.EmpTrainingRecord;
import com.bishe.system.domain.employment.EmpUserProfile;
import com.bishe.system.domain.employment.dto.EmpResetPasswordRequest;
import com.bishe.system.service.ISysUserService;
import com.bishe.system.service.employment.IEmpService;

@RestController
@RequestMapping("/employment/front")
public class EmploymentFrontController extends BaseController
{
    @Autowired
    private IEmpService empService;

    @Autowired
    private ISysUserService userService;

    @GetMapping("/profile")
    public AjaxResult myProfile()
    {
        Long userId = getUserId();
        LoginUser loginUser = getLoginUser();
        SysUser user = loginUser.getUser();
        EmpUserProfile profile = empService.selectProfileByUserId(userId);
        if (profile == null)
        {
            profile = new EmpUserProfile();
            profile.setUserId(userId);
            profile.setUserName(getUsername());
            profile.setRealName(user.getNickName());
            profile.setGender(StringUtils.isEmpty(user.getSex()) ? "2" : user.getSex());
            profile.setPhone(user.getPhonenumber());
            profile.setEmploymentStatus("0");
            profile.setAuditStatus("0");
        }
        else
        {
            if (StringUtils.isEmpty(profile.getUserName()))
            {
                profile.setUserName(getUsername());
            }
            if (StringUtils.isEmpty(profile.getRealName()))
            {
                profile.setRealName(user.getNickName());
            }
            if (StringUtils.isEmpty(profile.getGender()))
            {
                profile.setGender(StringUtils.isEmpty(user.getSex()) ? "2" : user.getSex());
            }
            if (StringUtils.isEmpty(profile.getPhone()))
            {
                profile.setPhone(user.getPhonenumber());
            }
            if (StringUtils.isEmpty(profile.getEmploymentStatus()))
            {
                profile.setEmploymentStatus("0");
            }
            if (StringUtils.isEmpty(profile.getAuditStatus()))
            {
                profile.setAuditStatus("0");
            }
        }
        return success(profile);
    }

    @PutMapping("/profile")
    public AjaxResult saveProfile(@RequestBody EmpUserProfile profile)
    {
        Long userId = getUserId();
        EmpUserProfile dbProfile = empService.selectProfileByUserId(userId);
        profile.setUserId(userId);
        profile.setAuditStatus("0");
        if (dbProfile == null)
        {
            profile.setCreateBy(getUsername());
            return toAjax(empService.insertProfile(profile));
        }
        profile.setProfileId(dbProfile.getProfileId());
        profile.setUpdateBy(getUsername());
        return toAjax(empService.updateProfile(profile));
    }

    @Anonymous
    @PostMapping("/password/reset")
    public AjaxResult resetPassword(@RequestBody EmpResetPasswordRequest request)
    {
        if (StringUtils.isEmpty(request.getUserName()) || StringUtils.isEmpty(request.getPhone())
                || StringUtils.isEmpty(request.getNewPassword()))
        {
            return error("用户名、手机号和新密码不能为空");
        }
        SysUser user = userService.selectUserByUserName(request.getUserName());
        if (user == null)
        {
            return error("用户不存在");
        }
        if (!StringUtils.equals(request.getPhone(), user.getPhonenumber()))
        {
            return error("手机号校验失败");
        }
        String newPassword = SecurityUtils.encryptPassword(request.getNewPassword());
        return toAjax(userService.resetUserPwd(user.getUserId(), newPassword));
    }

    @GetMapping("/categories/{categoryType}")
    public AjaxResult frontCategories(@PathVariable String categoryType)
    {
        List<EmpServiceCategory> list = empService.selectEnabledCategoryList(categoryType);
        return success(list);
    }

    @GetMapping("/positions/list")
    public TableDataInfo positions(EmpPosition position)
    {
        startPage();
        List<EmpPosition> list = empService.selectFrontPositionList(position);
        return getDataTable(list);
    }

    @PostMapping("/positions/apply")
    public AjaxResult applyPosition(@RequestBody EmpPositionApply apply)
    {
        apply.setUserId(getUserId());
        apply.setApplyStatus("0");
        apply.setCreateBy(getUsername());
        int rows = empService.applyPosition(apply);
        if (rows <= 0)
        {
            return error("岗位申请提交失败");
        }
        AjaxResult result = success("岗位申请已提交");
        result.put("rows", rows);
        return result;
    }

    @GetMapping("/positions/myApply")
    public TableDataInfo myApply()
    {
        startPage();
        List<EmpPositionApply> list = empService.selectMyApplyList(getUserId());
        return getDataTable(list);
    }

    @GetMapping("/trainings/list")
    public TableDataInfo trainings(EmpTraining training)
    {
        startPage();
        List<EmpTraining> list = empService.selectFrontTrainingList(training);
        return getDataTable(list);
    }

    @PostMapping("/trainings/signup/{trainingId}")
    public AjaxResult signupTraining(@PathVariable Long trainingId)
    {
        EmpTrainingRecord record = new EmpTrainingRecord();
        record.setTrainingId(trainingId);
        record.setUserId(getUserId());
        record.setRecordStatus("0");
        record.setCreateBy(getUsername());
        int rows = empService.signupTraining(record);
        if (rows <= 0)
        {
            return error("培训报名失败");
        }
        AjaxResult result = success("培训报名成功");
        result.put("rows", rows);
        return result;
    }

    @GetMapping("/trainings/myRecords")
    public TableDataInfo myTrainingRecords()
    {
        startPage();
        List<EmpTrainingRecord> list = empService.selectMyTrainingRecordList(getUserId());
        return getDataTable(list);
    }

    @GetMapping("/consultations/my")
    public TableDataInfo myConsultations()
    {
        startPage();
        List<EmpConsultation> list = empService.selectMyConsultationList(getUserId());
        return getDataTable(list);
    }

    @GetMapping("/consultations/{consultId}")
    public AjaxResult consultationDetail(@PathVariable Long consultId)
    {
        EmpConsultation consultation = empService.selectConsultationById(consultId);
        if (consultation == null || !getUserId().equals(consultation.getUserId()))
        {
            return error("咨询记录不存在");
        }
        return success(consultation);
    }

    @PostMapping("/consultations")
    public AjaxResult addConsultation(@RequestBody EmpConsultation consultation)
    {
        if (StringUtils.isEmpty(consultation.getQuestionContent()))
        {
            return error("咨询问题不能为空");
        }
        consultation.setConsultType(normalizeConsultType(consultation.getConsultType()));
        consultation.setUserId(getUserId());
        consultation.setConsultStatus("0");
        consultation.setAuditStatus("0");
        consultation.setCreateBy(getUsername());
        return toAjax(empService.insertConsultation(consultation));
    }

    @GetMapping("/policies/list")
    public TableDataInfo policies(EmpPolicy policy)
    {
        startPage();
        List<EmpPolicy> list = empService.selectFrontPolicyList(policy);
        return getDataTable(list);
    }

    @GetMapping("/policies/{policyId}")
    public AjaxResult policyDetail(@PathVariable Long policyId)
    {
        EmpPolicy policy = empService.selectPolicyById(policyId);
        if (policy == null || !StringUtils.equals("1", policy.getAuditStatus()) || !StringUtils.equals("0", policy.getStatus()))
        {
            return error("政策不存在或未发布");
        }
        return success(policy);
    }

    @GetMapping("/currentUser")
    public AjaxResult currentUser()
    {
        LoginUser loginUser = getLoginUser();
        return success(loginUser.getUser());
    }

    private String normalizeConsultType(String consultType)
    {
        if (StringUtils.isEmpty(consultType))
        {
            return "OTHER";
        }
        String value = consultType.trim();
        if ("JOB".equalsIgnoreCase(value) || "岗位咨询".equals(value) || "求职咨询".equals(value))
        {
            return "JOB";
        }
        if ("TRAINING".equalsIgnoreCase(value) || "培训咨询".equals(value))
        {
            return "TRAINING";
        }
        if ("POLICY".equalsIgnoreCase(value) || "政策咨询".equals(value))
        {
            return "POLICY";
        }
        return "OTHER";
    }
}
