package com.bishe.web.controller.employment;

import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import com.bishe.common.annotation.Log;
import com.bishe.common.core.controller.BaseController;
import com.bishe.common.core.domain.AjaxResult;
import com.bishe.common.core.page.TableDataInfo;
import com.bishe.common.enums.BusinessType;
import com.bishe.common.utils.poi.ExcelUtil;
import com.bishe.system.domain.employment.EmpConsultation;
import com.bishe.system.domain.employment.EmpFlowLog;
import com.bishe.system.domain.employment.EmpPolicy;
import com.bishe.system.domain.employment.EmpPosition;
import com.bishe.system.domain.employment.EmpPositionApply;
import com.bishe.system.domain.employment.EmpServiceCategory;
import com.bishe.system.domain.employment.EmpTraining;
import com.bishe.system.domain.employment.EmpTrainingRecord;
import com.bishe.system.domain.employment.EmpUserProfile;
import com.bishe.system.domain.employment.dto.EmpApplyStatusRequest;
import com.bishe.system.domain.employment.dto.EmpAuditRequest;
import com.bishe.system.domain.employment.dto.EmpConsultReplyRequest;
import com.bishe.system.service.employment.IEmpService;

@RestController
@RequestMapping("/employment/admin")
public class EmploymentAdminController extends BaseController
{
    @Autowired
    private IEmpService empService;

    @PreAuthorize("@ss.hasPermi('employment:profile:list')")
    @GetMapping("/profile/list")
    public TableDataInfo profileList(EmpUserProfile profile)
    {
        startPage();
        List<EmpUserProfile> list = empService.selectProfileList(profile);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('employment:profile:query')")
    @GetMapping("/profile/{profileId}")
    public AjaxResult getProfile(@PathVariable Long profileId)
    {
        return success(empService.selectProfileById(profileId));
    }

    @PreAuthorize("@ss.hasPermi('employment:profile:add')")
    @Log(title = "人员档案", businessType = BusinessType.INSERT)
    @PostMapping("/profile")
    public AjaxResult addProfile(@RequestBody EmpUserProfile profile)
    {
        profile.setCreateBy(getUsername());
        return toAjax(empService.insertProfile(profile));
    }

    @PreAuthorize("@ss.hasPermi('employment:profile:edit')")
    @Log(title = "人员档案", businessType = BusinessType.UPDATE)
    @PutMapping("/profile")
    public AjaxResult editProfile(@RequestBody EmpUserProfile profile)
    {
        profile.setUpdateBy(getUsername());
        return toAjax(empService.updateProfile(profile));
    }

    @PreAuthorize("@ss.hasPermi('employment:profile:remove')")
    @Log(title = "人员档案", businessType = BusinessType.DELETE)
    @DeleteMapping("/profile/{profileIds}")
    public AjaxResult removeProfile(@PathVariable Long[] profileIds)
    {
        return toAjax(empService.deleteProfileByIds(profileIds));
    }

    @PreAuthorize("@ss.hasPermi('employment:profile:audit')")
    @PutMapping("/profile/audit")
    public AjaxResult auditProfile(@RequestBody EmpAuditRequest request)
    {
        EmpUserProfile profile = new EmpUserProfile();
        profile.setProfileId(request.getId());
        profile.setAuditStatus(request.getAuditStatus());
        profile.setRemark(request.getAuditRemark());
        profile.setUpdateBy(getUsername());
        return toAjax(empService.updateProfile(profile));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:list')")
    @GetMapping("/position/list")
    public TableDataInfo positionList(EmpPosition position)
    {
        startPage();
        List<EmpPosition> list = empService.selectPositionList(position);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('employment:review:query')")
    @GetMapping("/position/{positionId}")
    public AjaxResult getPosition(@PathVariable Long positionId)
    {
        return success(empService.selectPositionById(positionId));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @Log(title = "岗位信息", businessType = BusinessType.INSERT)
    @PostMapping("/position")
    public AjaxResult addPosition(@RequestBody EmpPosition position)
    {
        position.setCreateBy(getUsername());
        return toAjax(empService.insertPosition(position));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @Log(title = "岗位信息", businessType = BusinessType.UPDATE)
    @PutMapping("/position")
    public AjaxResult editPosition(@RequestBody EmpPosition position)
    {
        position.setUpdateBy(getUsername());
        return toAjax(empService.updatePosition(position));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @PutMapping("/position/audit")
    public AjaxResult auditPosition(@RequestBody EmpAuditRequest request)
    {
        EmpPosition position = new EmpPosition();
        position.setPositionId(request.getId());
        position.setAuditStatus(request.getAuditStatus());
        position.setRemark(request.getAuditRemark());
        position.setUpdateBy(getUsername());
        return toAjax(empService.updatePosition(position));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @Log(title = "岗位信息", businessType = BusinessType.DELETE)
    @DeleteMapping("/position/{positionIds}")
    public AjaxResult removePosition(@PathVariable Long[] positionIds)
    {
        return toAjax(empService.deletePositionByIds(positionIds));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:list')")
    @GetMapping("/apply/list")
    public TableDataInfo applyList(EmpPositionApply apply)
    {
        startPage();
        List<EmpPositionApply> list = empService.selectApplyList(apply);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('employment:review:query')")
    @GetMapping("/apply/{applyId}")
    public AjaxResult getApply(@PathVariable Long applyId)
    {
        return success(empService.selectApplyById(applyId));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @Log(title = "岗位申请", businessType = BusinessType.INSERT)
    @PostMapping("/apply")
    public AjaxResult addApply(@RequestBody EmpPositionApply apply)
    {
        apply.setCreateBy(getUsername());
        return toAjax(empService.insertPositionApply(apply));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @Log(title = "岗位申请", businessType = BusinessType.UPDATE)
    @PutMapping("/apply")
    public AjaxResult editApply(@RequestBody EmpPositionApply apply)
    {
        apply.setUpdateBy(getUsername());
        return toAjax(empService.updatePositionApply(apply));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @PutMapping("/apply/status")
    public AjaxResult updateApplyStatus(@RequestBody EmpApplyStatusRequest request)
    {
        EmpPositionApply apply = new EmpPositionApply();
        apply.setApplyId(request.getApplyId());
        apply.setApplyStatus(request.getApplyStatus());
        apply.setAuditRemark(request.getAuditRemark());
        apply.setUpdateBy(getUsername());
        return toAjax(empService.updateApplyStatus(apply));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @Log(title = "岗位申请", businessType = BusinessType.DELETE)
    @DeleteMapping("/apply/{applyIds}")
    public AjaxResult removeApply(@PathVariable Long[] applyIds)
    {
        return toAjax(empService.deleteApplyByIds(applyIds));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:list')")
    @GetMapping("/training/list")
    public TableDataInfo trainingList(EmpTraining training)
    {
        startPage();
        List<EmpTraining> list = empService.selectTrainingList(training);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('employment:review:query')")
    @GetMapping("/training/{trainingId}")
    public AjaxResult getTraining(@PathVariable Long trainingId)
    {
        return success(empService.selectTrainingById(trainingId));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @Log(title = "培训计划", businessType = BusinessType.INSERT)
    @PostMapping("/training")
    public AjaxResult addTraining(@RequestBody EmpTraining training)
    {
        training.setCreateBy(getUsername());
        return toAjax(empService.insertTraining(training));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @Log(title = "培训计划", businessType = BusinessType.UPDATE)
    @PutMapping("/training")
    public AjaxResult editTraining(@RequestBody EmpTraining training)
    {
        training.setUpdateBy(getUsername());
        return toAjax(empService.updateTraining(training));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @PutMapping("/training/audit")
    public AjaxResult auditTraining(@RequestBody EmpAuditRequest request)
    {
        EmpTraining training = new EmpTraining();
        training.setTrainingId(request.getId());
        training.setAuditStatus(request.getAuditStatus());
        training.setRemark(request.getAuditRemark());
        training.setUpdateBy(getUsername());
        return toAjax(empService.updateTraining(training));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @DeleteMapping("/training/{trainingIds}")
    public AjaxResult removeTraining(@PathVariable Long[] trainingIds)
    {
        return toAjax(empService.deleteTrainingByIds(trainingIds));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:list')")
    @GetMapping("/trainingRecord/list")
    public TableDataInfo trainingRecordList(EmpTrainingRecord record)
    {
        startPage();
        List<EmpTrainingRecord> list = empService.selectTrainingRecordList(record);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('employment:review:query')")
    @GetMapping("/trainingRecord/{recordId}")
    public AjaxResult getTrainingRecord(@PathVariable Long recordId)
    {
        return success(empService.selectTrainingRecordById(recordId));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @Log(title = "培训记录", businessType = BusinessType.INSERT)
    @PostMapping("/trainingRecord")
    public AjaxResult addTrainingRecord(@RequestBody EmpTrainingRecord record)
    {
        record.setCreateBy(getUsername());
        return toAjax(empService.insertTrainingRecord(record));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @Log(title = "培训记录", businessType = BusinessType.UPDATE)
    @PutMapping("/trainingRecord")
    public AjaxResult editTrainingRecord(@RequestBody EmpTrainingRecord record)
    {
        record.setUpdateBy(getUsername());
        return toAjax(empService.updateTrainingRecord(record));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @Log(title = "培训记录", businessType = BusinessType.DELETE)
    @DeleteMapping("/trainingRecord/{recordIds}")
    public AjaxResult removeTrainingRecord(@PathVariable Long[] recordIds)
    {
        return toAjax(empService.deleteTrainingRecordByIds(recordIds));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:positionAudit')")
    @PutMapping("/trainingRecord/status")
    public AjaxResult updateTrainingRecordStatus(@RequestBody EmpTrainingRecord record)
    {
        record.setUpdateBy(getUsername());
        return toAjax(empService.updateTrainingRecordStatus(record));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:list')")
    @GetMapping("/consult/list")
    public TableDataInfo consultList(EmpConsultation consultation)
    {
        startPage();
        List<EmpConsultation> list = empService.selectConsultationList(consultation);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('employment:review:query')")
    @GetMapping("/consult/{consultId}")
    public AjaxResult getConsult(@PathVariable Long consultId)
    {
        return success(empService.selectConsultationById(consultId));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:consultAudit')")
    @Log(title = "互动咨询", businessType = BusinessType.INSERT)
    @PostMapping("/consult")
    public AjaxResult addConsult(@RequestBody EmpConsultation consultation)
    {
        consultation.setCreateBy(getUsername());
        return toAjax(empService.insertConsultation(consultation));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:consultAudit')")
    @Log(title = "互动咨询", businessType = BusinessType.UPDATE)
    @PutMapping("/consult")
    public AjaxResult editConsult(@RequestBody EmpConsultation consultation)
    {
        consultation.setUpdateBy(getUsername());
        return toAjax(empService.updateConsultation(consultation));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:consultAudit')")
    @PutMapping("/consult/audit")
    public AjaxResult auditConsult(@RequestBody EmpAuditRequest request)
    {
        EmpConsultation consultation = new EmpConsultation();
        consultation.setConsultId(request.getId());
        consultation.setAuditStatus(request.getAuditStatus());
        consultation.setAuditRemark(request.getAuditRemark());
        consultation.setUpdateBy(getUsername());
        return toAjax(empService.updateConsultationAudit(consultation));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:consultReply')")
    @PutMapping("/consult/reply")
    public AjaxResult replyConsult(@RequestBody EmpConsultReplyRequest request)
    {
        EmpConsultation consultation = new EmpConsultation();
        consultation.setConsultId(request.getConsultId());
        consultation.setAnswerContent(request.getAnswerContent());
        consultation.setConsultStatus("1");
        consultation.setAnswerBy(getUserId());
        consultation.setUpdateBy(getUsername());
        return toAjax(empService.replyConsultation(consultation));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:consultAudit')")
    @DeleteMapping("/consult/{consultIds}")
    public AjaxResult removeConsult(@PathVariable Long[] consultIds)
    {
        return toAjax(empService.deleteConsultationByIds(consultIds));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:list')")
    @GetMapping("/policy/list")
    public TableDataInfo policyList(EmpPolicy policy)
    {
        startPage();
        List<EmpPolicy> list = empService.selectPolicyList(policy);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('employment:review:query')")
    @GetMapping("/policy/{policyId}")
    public AjaxResult getPolicy(@PathVariable Long policyId)
    {
        return success(empService.selectPolicyById(policyId));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:policyAudit')")
    @Log(title = "政策资讯", businessType = BusinessType.INSERT)
    @PostMapping("/policy")
    public AjaxResult addPolicy(@RequestBody EmpPolicy policy)
    {
        policy.setCreateBy(getUsername());
        return toAjax(empService.insertPolicy(policy));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:policyAudit')")
    @Log(title = "政策资讯", businessType = BusinessType.UPDATE)
    @PutMapping("/policy")
    public AjaxResult editPolicy(@RequestBody EmpPolicy policy)
    {
        policy.setUpdateBy(getUsername());
        return toAjax(empService.updatePolicy(policy));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:policyAudit')")
    @PutMapping("/policy/audit")
    public AjaxResult auditPolicy(@RequestBody EmpAuditRequest request)
    {
        EmpPolicy policy = new EmpPolicy();
        policy.setPolicyId(request.getId());
        policy.setAuditStatus(request.getAuditStatus());
        policy.setRemark(request.getAuditRemark());
        policy.setUpdateBy(getUsername());
        return toAjax(empService.updatePolicyAudit(policy));
    }

    @PreAuthorize("@ss.hasPermi('employment:review:policyAudit')")
    @DeleteMapping("/policy/{policyIds}")
    public AjaxResult removePolicy(@PathVariable Long[] policyIds)
    {
        return toAjax(empService.deletePolicyByIds(policyIds));
    }

    @PreAuthorize("@ss.hasPermi('employment:category:list')")
    @GetMapping("/category/list")
    public TableDataInfo categoryList(EmpServiceCategory category)
    {
        startPage();
        List<EmpServiceCategory> list = empService.selectCategoryList(category);
        return getDataTable(list);
    }

    @PreAuthorize("@ss.hasPermi('employment:category:query')")
    @GetMapping("/category/{categoryId}")
    public AjaxResult getCategory(@PathVariable Long categoryId)
    {
        return success(empService.selectCategoryById(categoryId));
    }

    @PreAuthorize("@ss.hasPermi('employment:category:add')")
    @Log(title = "服务分类", businessType = BusinessType.INSERT)
    @PostMapping("/category")
    public AjaxResult addCategory(@RequestBody EmpServiceCategory category)
    {
        category.setCreateBy(getUsername());
        return toAjax(empService.insertCategory(category));
    }

    @PreAuthorize("@ss.hasPermi('employment:category:edit')")
    @Log(title = "服务分类", businessType = BusinessType.UPDATE)
    @PutMapping("/category")
    public AjaxResult editCategory(@RequestBody EmpServiceCategory category)
    {
        category.setUpdateBy(getUsername());
        return toAjax(empService.updateCategory(category));
    }

    @PreAuthorize("@ss.hasPermi('employment:category:remove')")
    @Log(title = "服务分类", businessType = BusinessType.DELETE)
    @DeleteMapping("/category/{categoryIds}")
    public AjaxResult removeCategory(@PathVariable Long[] categoryIds)
    {
        return toAjax(empService.deleteCategoryByIds(categoryIds));
    }

    @PreAuthorize("@ss.hasPermi('employment:report:list')")
    @GetMapping("/report/overview")
    public AjaxResult reportOverview()
    {
        List<Map<String, Object>> list = empService.selectOverviewReport();
        return success(list.isEmpty() ? null : list.get(0));
    }

    @PreAuthorize("@ss.hasPermi('employment:report:query')")
    @GetMapping("/report/age")
    public AjaxResult reportAge()
    {
        return success(empService.selectAgeReport());
    }

    @PreAuthorize("@ss.hasPermi('employment:report:query')")
    @GetMapping("/report/district")
    public AjaxResult reportDistrict()
    {
        return success(empService.selectDistrictReport());
    }

    @PreAuthorize("@ss.hasPermi('employment:report:query')")
    @GetMapping("/report/applyMonth")
    public AjaxResult reportApplyMonth()
    {
        return success(empService.selectApplyMonthReport());
    }

    @PreAuthorize("@ss.hasPermi('employment:report:query')")
    @GetMapping("/report/flowLog/list")
    public TableDataInfo reportFlowLogList(EmpFlowLog flowLog)
    {
        startPage();
        List<EmpFlowLog> list = empService.selectFlowLogReport(flowLog);
        return getDataTable(list);
    }

    @Log(title = "流程日志", businessType = BusinessType.EXPORT)
    @PreAuthorize("@ss.hasPermi('employment:report:export')")
    @PostMapping("/report/flowLog/export")
    public void exportFlowLog(HttpServletResponse response, EmpFlowLog flowLog)
    {
        List<EmpFlowLog> list = empService.selectFlowLogReport(flowLog);
        ExcelUtil<EmpFlowLog> util = new ExcelUtil<EmpFlowLog>(EmpFlowLog.class);
        util.exportExcel(response, list, "就业服务流程日志");
    }

    @PreAuthorize("@ss.hasPermi('employment:report:query')")
    @GetMapping("/report/flowLog/trend")
    public AjaxResult reportFlowTrend(EmpFlowLog flowLog)
    {
        return success(empService.selectFlowTrendReport(flowLog));
    }

    @PreAuthorize("@ss.hasPermi('employment:permission:list')")
    @GetMapping("/permission/roles")
    public AjaxResult permissionRoleReport()
    {
        return success(empService.selectRoleReport());
    }

    @PreAuthorize("@ss.hasPermi('employment:permission:query')")
    @GetMapping("/permission/menus")
    public AjaxResult permissionMenuReport()
    {
        return success(empService.selectPermissionReport());
    }
}
