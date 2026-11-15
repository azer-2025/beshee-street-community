package com.bishe.system.service.employment.impl;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import com.bishe.common.exception.ServiceException;
import com.bishe.common.utils.StringUtils;
import com.bishe.system.domain.employment.EmpConsultation;
import com.bishe.system.domain.employment.EmpFlowLog;
import com.bishe.system.domain.employment.EmpPolicy;
import com.bishe.system.domain.employment.EmpPosition;
import com.bishe.system.domain.employment.EmpPositionApply;
import com.bishe.system.domain.employment.EmpServiceCategory;
import com.bishe.system.domain.employment.EmpTraining;
import com.bishe.system.domain.employment.EmpTrainingRecord;
import com.bishe.system.domain.employment.EmpUserProfile;
import com.bishe.system.mapper.employment.EmpServiceMapper;
import com.bishe.system.service.employment.IEmpService;

@Service
public class EmpServiceImpl implements IEmpService
{
    private static final int MAX_CERTIFICATE_COUNT = 6;
    private static final String[] CERT_IMAGE_EXTENSIONS = { ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".webp" };

    @Autowired
    private EmpServiceMapper empServiceMapper;

    @Override
    public EmpUserProfile selectProfileById(Long profileId)
    {
        return empServiceMapper.selectProfileById(profileId);
    }

    @Override
    public EmpUserProfile selectProfileByUserId(Long userId)
    {
        return empServiceMapper.selectProfileByUserId(userId);
    }

    @Override
    public List<EmpUserProfile> selectProfileList(EmpUserProfile profile)
    {
        return empServiceMapper.selectProfileList(profile);
    }

    @Override
    public int insertProfile(EmpUserProfile profile)
    {
        normalizeProfileCertificates(profile);
        return empServiceMapper.insertProfile(profile);
    }

    @Override
    public int updateProfile(EmpUserProfile profile)
    {
        normalizeProfileCertificates(profile);
        return empServiceMapper.updateProfile(profile);
    }

    @Override
    public int deleteProfileByIds(Long[] profileIds)
    {
        return empServiceMapper.deleteProfileByIds(profileIds);
    }

    @Override
    public EmpPosition selectPositionById(Long positionId)
    {
        return empServiceMapper.selectPositionById(positionId);
    }

    @Override
    public List<EmpPosition> selectPositionList(EmpPosition position)
    {
        return empServiceMapper.selectPositionList(position);
    }

    @Override
    public List<EmpPosition> selectFrontPositionList(EmpPosition position)
    {
        return empServiceMapper.selectFrontPositionList(position);
    }

    @Override
    public int insertPosition(EmpPosition position)
    {
        return empServiceMapper.insertPosition(position);
    }

    @Override
    public int updatePosition(EmpPosition position)
    {
        return empServiceMapper.updatePosition(position);
    }

    @Override
    public int deletePositionByIds(Long[] positionIds)
    {
        return empServiceMapper.deletePositionByIds(positionIds);
    }

    @Override
    public int applyPosition(EmpPositionApply apply)
    {
        if (apply == null || apply.getUserId() == null || apply.getPositionId() == null)
        {
            throw new ServiceException("岗位申请参数不完整");
        }
        EmpUserProfile profile = empServiceMapper.selectProfileByUserId(apply.getUserId());
        if (profile == null || !StringUtils.equals("1", profile.getAuditStatus()))
        {
            throw new ServiceException("请先完善个人档案并通过审核后再投递岗位");
        }
        EmpPosition position = empServiceMapper.selectPositionById(apply.getPositionId());
        if (position == null)
        {
            throw new ServiceException("岗位不存在");
        }
        if (!StringUtils.equals("1", position.getAuditStatus()) || !StringUtils.equals("0", position.getPublishStatus()))
        {
            throw new ServiceException("该岗位暂不可投递");
        }
        int count = empServiceMapper.countApplyByUserAndPosition(apply.getUserId(), apply.getPositionId());
        if (count > 0)
        {
            throw new ServiceException("您已投递过该岗位");
        }
        return empServiceMapper.insertPositionApply(apply);
    }

    @Override
    public EmpPositionApply selectApplyById(Long applyId)
    {
        return empServiceMapper.selectApplyById(applyId);
    }

    @Override
    public List<EmpPositionApply> selectApplyList(EmpPositionApply apply)
    {
        return empServiceMapper.selectApplyList(apply);
    }

    @Override
    public List<EmpPositionApply> selectMyApplyList(Long userId)
    {
        return empServiceMapper.selectMyApplyList(userId);
    }

    @Override
    public int insertPositionApply(EmpPositionApply apply)
    {
        if (apply == null || apply.getUserId() == null || apply.getPositionId() == null)
        {
            throw new ServiceException("申请参数不完整");
        }
        EmpPosition position = empServiceMapper.selectPositionById(apply.getPositionId());
        if (position == null)
        {
            throw new ServiceException("岗位不存在");
        }
        int count = empServiceMapper.countApplyByUserAndPosition(apply.getUserId(), apply.getPositionId());
        if (count > 0)
        {
            throw new ServiceException("该用户已申请过该岗位");
        }
        if (StringUtils.isEmpty(apply.getApplyStatus()))
        {
            apply.setApplyStatus("0");
        }
        return empServiceMapper.insertPositionApply(apply);
    }

    @Override
    public int updatePositionApply(EmpPositionApply apply)
    {
        if (apply == null || apply.getApplyId() == null)
        {
            throw new ServiceException("申请ID不能为空");
        }
        EmpPositionApply dbApply = empServiceMapper.selectApplyById(apply.getApplyId());
        if (dbApply == null)
        {
            throw new ServiceException("申请记录不存在");
        }
        Long targetUserId = apply.getUserId() != null ? apply.getUserId() : dbApply.getUserId();
        Long targetPositionId = apply.getPositionId() != null ? apply.getPositionId() : dbApply.getPositionId();
        if (targetUserId == null || targetPositionId == null)
        {
            throw new ServiceException("申请参数不完整");
        }
        boolean userChanged = !targetUserId.equals(dbApply.getUserId());
        boolean positionChanged = !targetPositionId.equals(dbApply.getPositionId());
        if (positionChanged)
        {
            EmpPosition position = empServiceMapper.selectPositionById(targetPositionId);
            if (position == null)
            {
                throw new ServiceException("岗位不存在");
            }
        }
        if (userChanged || positionChanged)
        {
            int count = empServiceMapper.countApplyByUserAndPosition(targetUserId, targetPositionId);
            if (count > 0)
            {
                throw new ServiceException("该用户已申请过该岗位");
            }
        }
        apply.setUserId(targetUserId);
        apply.setPositionId(targetPositionId);
        return empServiceMapper.updatePositionApply(apply);
    }

    @Override
    public int updateApplyStatus(EmpPositionApply apply)
    {
        return empServiceMapper.updateApplyStatus(apply);
    }

    @Override
    public int deleteApplyByIds(Long[] applyIds)
    {
        return empServiceMapper.deleteApplyByIds(applyIds);
    }

    @Override
    public EmpTraining selectTrainingById(Long trainingId)
    {
        return empServiceMapper.selectTrainingById(trainingId);
    }

    @Override
    public List<EmpTraining> selectTrainingList(EmpTraining training)
    {
        return empServiceMapper.selectTrainingList(training);
    }

    @Override
    public List<EmpTraining> selectFrontTrainingList(EmpTraining training)
    {
        return empServiceMapper.selectFrontTrainingList(training);
    }

    @Override
    public int insertTraining(EmpTraining training)
    {
        return empServiceMapper.insertTraining(training);
    }

    @Override
    public int updateTraining(EmpTraining training)
    {
        return empServiceMapper.updateTraining(training);
    }

    @Override
    public int deleteTrainingByIds(Long[] trainingIds)
    {
        return empServiceMapper.deleteTrainingByIds(trainingIds);
    }

    @Override
    @Transactional
    public int signupTraining(EmpTrainingRecord record)
    {
        if (record == null || record.getUserId() == null || record.getTrainingId() == null)
        {
            throw new ServiceException("培训报名参数不完整");
        }
        EmpUserProfile profile = empServiceMapper.selectProfileByUserId(record.getUserId());
        if (profile == null || !StringUtils.equals("1", profile.getAuditStatus()))
        {
            throw new ServiceException("请先完善个人档案并通过审核后再报名培训");
        }
        EmpTraining training = empServiceMapper.selectTrainingById(record.getTrainingId());
        if (training == null)
        {
            throw new ServiceException("培训计划不存在");
        }
        if (!StringUtils.equals("1", training.getAuditStatus()) || !StringUtils.equals("0", training.getStatus()))
        {
            throw new ServiceException("该培训暂不可报名");
        }
        Integer quota = training.getQuota();
        Integer signupCount = training.getSignupCount();
        if (quota != null && quota > 0 && signupCount != null && signupCount >= quota)
        {
            throw new ServiceException("培训名额已满");
        }
        int count = empServiceMapper.countTrainingRecordByUserAndTraining(record.getUserId(), record.getTrainingId());
        if (count > 0)
        {
            throw new ServiceException("您已报名该培训");
        }
        int rows = empServiceMapper.insertTrainingRecord(record);
        if (rows > 0)
        {
            int incRows = empServiceMapper.increaseTrainingSignupCount(record.getTrainingId());
            if (incRows == 0)
            {
                throw new ServiceException("培训名额已满");
            }
        }
        return rows;
    }

    @Override
    public List<EmpTrainingRecord> selectTrainingRecordList(EmpTrainingRecord record)
    {
        return empServiceMapper.selectTrainingRecordList(record);
    }

    @Override
    public List<EmpTrainingRecord> selectMyTrainingRecordList(Long userId)
    {
        return empServiceMapper.selectMyTrainingRecordList(userId);
    }

    @Override
    public EmpTrainingRecord selectTrainingRecordById(Long recordId)
    {
        return empServiceMapper.selectTrainingRecordById(recordId);
    }

    @Override
    @Transactional
    public int insertTrainingRecord(EmpTrainingRecord record)
    {
        if (record == null || record.getTrainingId() == null || record.getUserId() == null)
        {
            throw new ServiceException("培训记录参数不完整");
        }
        EmpTraining training = empServiceMapper.selectTrainingById(record.getTrainingId());
        if (training == null)
        {
            throw new ServiceException("培训计划不存在");
        }
        int count = empServiceMapper.countTrainingRecordByUserAndTraining(record.getUserId(), record.getTrainingId());
        if (count > 0)
        {
            throw new ServiceException("该用户已存在此培训记录");
        }
        if (StringUtils.isEmpty(record.getRecordStatus()))
        {
            record.setRecordStatus("0");
        }
        int rows = empServiceMapper.insertTrainingRecord(record);
        if (rows > 0)
        {
            int incRows = empServiceMapper.increaseTrainingSignupCount(record.getTrainingId());
            if (incRows == 0)
            {
                throw new ServiceException("培训名额已满");
            }
        }
        return rows;
    }

    @Override
    @Transactional
    public int updateTrainingRecord(EmpTrainingRecord record)
    {
        if (record == null || record.getRecordId() == null)
        {
            throw new ServiceException("培训记录ID不能为空");
        }
        EmpTrainingRecord dbRecord = empServiceMapper.selectTrainingRecordById(record.getRecordId());
        if (dbRecord == null)
        {
            throw new ServiceException("培训记录不存在");
        }
        Long targetTrainingId = record.getTrainingId() != null ? record.getTrainingId() : dbRecord.getTrainingId();
        Long targetUserId = record.getUserId() != null ? record.getUserId() : dbRecord.getUserId();
        if (targetTrainingId == null || targetUserId == null)
        {
            throw new ServiceException("培训记录参数不完整");
        }
        boolean trainingChanged = !targetTrainingId.equals(dbRecord.getTrainingId());
        boolean userChanged = !targetUserId.equals(dbRecord.getUserId());
        if (trainingChanged || userChanged)
        {
            int count = empServiceMapper.countTrainingRecordByUserAndTraining(targetUserId, targetTrainingId);
            if (count > 0)
            {
                throw new ServiceException("该用户已存在此培训记录");
            }
        }
        if (trainingChanged)
        {
            EmpTraining newTraining = empServiceMapper.selectTrainingById(targetTrainingId);
            if (newTraining == null)
            {
                throw new ServiceException("培训计划不存在");
            }
            int incRows = empServiceMapper.increaseTrainingSignupCount(targetTrainingId);
            if (incRows == 0)
            {
                throw new ServiceException("培训名额已满");
            }
            empServiceMapper.decreaseTrainingSignupCount(dbRecord.getTrainingId());
        }
        record.setTrainingId(targetTrainingId);
        record.setUserId(targetUserId);
        int rows = empServiceMapper.updateTrainingRecord(record);
        if (rows <= 0)
        {
            throw new ServiceException("培训记录更新失败");
        }
        return rows;
    }

    @Override
    public int updateTrainingRecordStatus(EmpTrainingRecord record)
    {
        return empServiceMapper.updateTrainingRecordStatus(record);
    }

    @Override
    @Transactional
    public int deleteTrainingRecordByIds(Long[] recordIds)
    {
        if (recordIds == null || recordIds.length == 0)
        {
            return 0;
        }
        List<EmpTrainingRecord> records = empServiceMapper.selectTrainingRecordByIds(recordIds);
        int rows = empServiceMapper.deleteTrainingRecordByIds(recordIds);
        if (rows > 0 && records != null)
        {
            for (EmpTrainingRecord item : records)
            {
                if (item != null && item.getTrainingId() != null)
                {
                    empServiceMapper.decreaseTrainingSignupCount(item.getTrainingId());
                }
            }
        }
        return rows;
    }

    @Override
    public EmpConsultation selectConsultationById(Long consultId)
    {
        return empServiceMapper.selectConsultationById(consultId);
    }

    @Override
    public List<EmpConsultation> selectConsultationList(EmpConsultation consultation)
    {
        return empServiceMapper.selectConsultationList(consultation);
    }

    @Override
    public List<EmpConsultation> selectMyConsultationList(Long userId)
    {
        return empServiceMapper.selectMyConsultationList(userId);
    }

    @Override
    public int insertConsultation(EmpConsultation consultation)
    {
        if (consultation == null || consultation.getUserId() == null)
        {
            throw new ServiceException("咨询参数不完整");
        }
        if (StringUtils.isEmpty(consultation.getQuestionContent()))
        {
            throw new ServiceException("咨询问题不能为空");
        }
        consultation.setConsultType(normalizeConsultType(consultation.getConsultType()));
        if (StringUtils.isEmpty(consultation.getConsultStatus()))
        {
            consultation.setConsultStatus("0");
        }
        if (StringUtils.isEmpty(consultation.getAuditStatus()))
        {
            consultation.setAuditStatus("0");
        }
        return empServiceMapper.insertConsultation(consultation);
    }

    @Override
    public int updateConsultation(EmpConsultation consultation)
    {
        if (consultation == null || consultation.getConsultId() == null)
        {
            throw new ServiceException("咨询ID不能为空");
        }
        EmpConsultation dbConsultation = empServiceMapper.selectConsultationById(consultation.getConsultId());
        if (dbConsultation == null)
        {
            throw new ServiceException("咨询记录不存在");
        }
        if (consultation.getUserId() == null)
        {
            consultation.setUserId(dbConsultation.getUserId());
        }
        if (StringUtils.isEmpty(consultation.getConsultType()))
        {
            consultation.setConsultType(dbConsultation.getConsultType());
        }
        consultation.setConsultType(normalizeConsultType(consultation.getConsultType()));
        if (StringUtils.isEmpty(consultation.getQuestionContent()))
        {
            consultation.setQuestionContent(dbConsultation.getQuestionContent());
        }
        return empServiceMapper.updateConsultation(consultation);
    }

    @Override
    public int updateConsultationAudit(EmpConsultation consultation)
    {
        EmpConsultation dbConsultation = empServiceMapper.selectConsultationById(consultation.getConsultId());
        if (dbConsultation == null)
        {
            throw new ServiceException("咨询记录不存在");
        }
        if (StringUtils.equals("2", consultation.getAuditStatus()))
        {
            consultation.setConsultStatus("2");
        }
        return empServiceMapper.updateConsultationAudit(consultation);
    }

    @Override
    public int replyConsultation(EmpConsultation consultation)
    {
        if (consultation == null || consultation.getConsultId() == null)
        {
            throw new ServiceException("咨询回复参数不完整");
        }
        EmpConsultation dbConsultation = empServiceMapper.selectConsultationById(consultation.getConsultId());
        if (dbConsultation == null)
        {
            throw new ServiceException("咨询记录不存在");
        }
        if (!StringUtils.equals("1", dbConsultation.getAuditStatus()))
        {
            throw new ServiceException("该咨询尚未审核通过，不能回复");
        }
        if (StringUtils.equals("2", dbConsultation.getConsultStatus()))
        {
            throw new ServiceException("该咨询已关闭，不能回复");
        }
        if (StringUtils.isEmpty(consultation.getAnswerContent()))
        {
            throw new ServiceException("回复内容不能为空");
        }
        return empServiceMapper.replyConsultation(consultation);
    }

    @Override
    public int deleteConsultationByIds(Long[] consultIds)
    {
        return empServiceMapper.deleteConsultationByIds(consultIds);
    }

    @Override
    public EmpPolicy selectPolicyById(Long policyId)
    {
        return empServiceMapper.selectPolicyById(policyId);
    }

    @Override
    public List<EmpPolicy> selectPolicyList(EmpPolicy policy)
    {
        return empServiceMapper.selectPolicyList(policy);
    }

    @Override
    public List<EmpPolicy> selectFrontPolicyList(EmpPolicy policy)
    {
        return empServiceMapper.selectFrontPolicyList(policy);
    }

    @Override
    public int insertPolicy(EmpPolicy policy)
    {
        return empServiceMapper.insertPolicy(policy);
    }

    @Override
    public int updatePolicy(EmpPolicy policy)
    {
        return empServiceMapper.updatePolicy(policy);
    }

    @Override
    public int deletePolicyByIds(Long[] policyIds)
    {
        return empServiceMapper.deletePolicyByIds(policyIds);
    }

    @Override
    public int updatePolicyAudit(EmpPolicy policy)
    {
        return empServiceMapper.updatePolicyAudit(policy);
    }

    @Override
    public EmpServiceCategory selectCategoryById(Long categoryId)
    {
        return empServiceMapper.selectCategoryById(categoryId);
    }

    @Override
    public List<EmpServiceCategory> selectCategoryList(EmpServiceCategory category)
    {
        return empServiceMapper.selectCategoryList(category);
    }

    @Override
    public List<EmpServiceCategory> selectEnabledCategoryList(String categoryType)
    {
        return empServiceMapper.selectEnabledCategoryList(categoryType);
    }

    @Override
    public int insertCategory(EmpServiceCategory category)
    {
        return empServiceMapper.insertCategory(category);
    }

    @Override
    public int updateCategory(EmpServiceCategory category)
    {
        return empServiceMapper.updateCategory(category);
    }

    @Override
    public int deleteCategoryByIds(Long[] categoryIds)
    {
        return empServiceMapper.deleteCategoryByIds(categoryIds);
    }

    @Override
    public List<Map<String, Object>> selectOverviewReport()
    {
        return empServiceMapper.selectOverviewReport();
    }

    @Override
    public List<Map<String, Object>> selectAgeReport()
    {
        return empServiceMapper.selectAgeReport();
    }

    @Override
    public List<Map<String, Object>> selectDistrictReport()
    {
        return empServiceMapper.selectDistrictReport();
    }

    @Override
    public List<Map<String, Object>> selectApplyMonthReport()
    {
        return empServiceMapper.selectApplyMonthReport();
    }

    @Override
    public List<EmpFlowLog> selectFlowLogReport(EmpFlowLog flowLog)
    {
        return empServiceMapper.selectFlowLogReport(flowLog);
    }

    @Override
    public List<Map<String, Object>> selectFlowTrendReport(EmpFlowLog flowLog)
    {
        return empServiceMapper.selectFlowTrendReport(flowLog);
    }

    @Override
    public List<Map<String, Object>> selectRoleReport()
    {
        return empServiceMapper.selectRoleReport();
    }

    @Override
    public List<Map<String, Object>> selectPermissionReport()
    {
        return empServiceMapper.selectPermissionReport();
    }

    private String normalizeConsultType(String consultType)
    {
        String value = StringUtils.trimToEmpty(consultType);
        if (StringUtils.isEmpty(value))
        {
            return "OTHER";
        }
        if ("0".equals(value) || "JOB".equalsIgnoreCase(value) || "岗位咨询".equals(value)
                || "岗位申请".equals(value) || "求职咨询".equals(value))
        {
            return "JOB";
        }
        if ("1".equals(value) || "TRAINING".equalsIgnoreCase(value) || "培训咨询".equals(value)
                || "培训报名".equals(value))
        {
            return "TRAINING";
        }
        if ("2".equals(value) || "POLICY".equalsIgnoreCase(value) || "政策咨询".equals(value))
        {
            return "POLICY";
        }
        if ("3".equals(value) || "OTHER".equalsIgnoreCase(value) || "其他".equals(value) || "账户问题".equals(value))
        {
            return "OTHER";
        }
        return "OTHER";
    }

    private void normalizeProfileCertificates(EmpUserProfile profile)
    {
        if (profile == null || profile.getCertificateUrls() == null)
        {
            return;
        }
        profile.setCertificateUrls(normalizeCertificateUrls(profile.getCertificateUrls()));
    }

    private String normalizeCertificateUrls(String rawCertificateUrls)
    {
        if (StringUtils.isEmpty(rawCertificateUrls))
        {
            return "";
        }
        String normalizedRaw = rawCertificateUrls.replace('，', ',').replace('\n', ',').replace('\r', ',').replace('\t', ',');
        String[] items = normalizedRaw.split(",");
        Set<String> normalizedSet = new LinkedHashSet<>();
        for (String item : items)
        {
            String normalizedPath = normalizeCertificatePath(item);
            if (StringUtils.isEmpty(normalizedPath) || !isImagePath(normalizedPath))
            {
                continue;
            }
            normalizedSet.add(normalizedPath);
            if (normalizedSet.size() >= MAX_CERTIFICATE_COUNT)
            {
                break;
            }
        }
        return String.join(",", normalizedSet);
    }

    private String normalizeCertificatePath(String value)
    {
        String path = StringUtils.trimToEmpty(value);
        if (StringUtils.isEmpty(path))
        {
            return "";
        }
        if (StringUtils.startsWithIgnoreCase(path, "http://") || StringUtils.startsWithIgnoreCase(path, "https://"))
        {
            try
            {
                URI uri = new URI(path);
                path = StringUtils.trimToEmpty(uri.getPath());
            }
            catch (URISyntaxException ex)
            {
                return "";
            }
        }
        int queryIndex = path.indexOf('?');
        if (queryIndex > -1)
        {
            path = path.substring(0, queryIndex);
        }
        path = path.trim();
        if (path.startsWith("profile/upload/"))
        {
            path = "/" + path;
        }
        if (!path.startsWith("/profile/upload/"))
        {
            return "";
        }
        return path;
    }

    private boolean isImagePath(String path)
    {
        String lowerPath = path.toLowerCase();
        for (String extension : CERT_IMAGE_EXTENSIONS)
        {
            if (lowerPath.endsWith(extension))
            {
                return true;
            }
        }
        return false;
    }
}
