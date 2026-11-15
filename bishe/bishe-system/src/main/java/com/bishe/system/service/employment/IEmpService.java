package com.bishe.system.service.employment;

import java.util.List;
import java.util.Map;
import com.bishe.system.domain.employment.EmpConsultation;
import com.bishe.system.domain.employment.EmpFlowLog;
import com.bishe.system.domain.employment.EmpPolicy;
import com.bishe.system.domain.employment.EmpPosition;
import com.bishe.system.domain.employment.EmpPositionApply;
import com.bishe.system.domain.employment.EmpServiceCategory;
import com.bishe.system.domain.employment.EmpTraining;
import com.bishe.system.domain.employment.EmpTrainingRecord;
import com.bishe.system.domain.employment.EmpUserProfile;

public interface IEmpService
{
    EmpUserProfile selectProfileById(Long profileId);

    EmpUserProfile selectProfileByUserId(Long userId);

    List<EmpUserProfile> selectProfileList(EmpUserProfile profile);

    int insertProfile(EmpUserProfile profile);

    int updateProfile(EmpUserProfile profile);

    int deleteProfileByIds(Long[] profileIds);

    EmpPosition selectPositionById(Long positionId);

    List<EmpPosition> selectPositionList(EmpPosition position);

    List<EmpPosition> selectFrontPositionList(EmpPosition position);

    int insertPosition(EmpPosition position);

    int updatePosition(EmpPosition position);

    int deletePositionByIds(Long[] positionIds);

    int applyPosition(EmpPositionApply apply);

    EmpPositionApply selectApplyById(Long applyId);

    List<EmpPositionApply> selectApplyList(EmpPositionApply apply);

    List<EmpPositionApply> selectMyApplyList(Long userId);

    int insertPositionApply(EmpPositionApply apply);

    int updatePositionApply(EmpPositionApply apply);

    int updateApplyStatus(EmpPositionApply apply);

    int deleteApplyByIds(Long[] applyIds);

    EmpTraining selectTrainingById(Long trainingId);

    List<EmpTraining> selectTrainingList(EmpTraining training);

    List<EmpTraining> selectFrontTrainingList(EmpTraining training);

    int insertTraining(EmpTraining training);

    int updateTraining(EmpTraining training);

    int deleteTrainingByIds(Long[] trainingIds);

    int signupTraining(EmpTrainingRecord record);

    List<EmpTrainingRecord> selectTrainingRecordList(EmpTrainingRecord record);

    List<EmpTrainingRecord> selectMyTrainingRecordList(Long userId);

    EmpTrainingRecord selectTrainingRecordById(Long recordId);

    int insertTrainingRecord(EmpTrainingRecord record);

    int updateTrainingRecord(EmpTrainingRecord record);

    int updateTrainingRecordStatus(EmpTrainingRecord record);

    int deleteTrainingRecordByIds(Long[] recordIds);

    EmpConsultation selectConsultationById(Long consultId);

    List<EmpConsultation> selectConsultationList(EmpConsultation consultation);

    List<EmpConsultation> selectMyConsultationList(Long userId);

    int insertConsultation(EmpConsultation consultation);

    int updateConsultation(EmpConsultation consultation);

    int updateConsultationAudit(EmpConsultation consultation);

    int replyConsultation(EmpConsultation consultation);

    int deleteConsultationByIds(Long[] consultIds);

    EmpPolicy selectPolicyById(Long policyId);

    List<EmpPolicy> selectPolicyList(EmpPolicy policy);

    List<EmpPolicy> selectFrontPolicyList(EmpPolicy policy);

    int insertPolicy(EmpPolicy policy);

    int updatePolicy(EmpPolicy policy);

    int deletePolicyByIds(Long[] policyIds);

    int updatePolicyAudit(EmpPolicy policy);

    EmpServiceCategory selectCategoryById(Long categoryId);

    List<EmpServiceCategory> selectCategoryList(EmpServiceCategory category);

    List<EmpServiceCategory> selectEnabledCategoryList(String categoryType);

    int insertCategory(EmpServiceCategory category);

    int updateCategory(EmpServiceCategory category);

    int deleteCategoryByIds(Long[] categoryIds);

    List<Map<String, Object>> selectOverviewReport();

    List<Map<String, Object>> selectAgeReport();

    List<Map<String, Object>> selectDistrictReport();

    List<Map<String, Object>> selectApplyMonthReport();

    List<EmpFlowLog> selectFlowLogReport(EmpFlowLog flowLog);

    List<Map<String, Object>> selectFlowTrendReport(EmpFlowLog flowLog);

    List<Map<String, Object>> selectRoleReport();

    List<Map<String, Object>> selectPermissionReport();
}
