Create Or Replace View Kd_Svq_Totals As
Select
  Sum(A.This_Year) As This_Year_Total,
  Sum(A.This_Year_Implants) As This_Year_Implants_Total,
  Sum(A.This_Year_Bio) As This_Year_Bio_Total,
  Sum(A.Year_Quota) As Year_Quota_Total,
  Sum(A.Year_Quota_Impl) As Year_Quota_Impl_Total,
  Sum(A.Year_Quota_Bio) As Year_Quota_Bio_Total,
  Sum(B.This_Quarter) As This_Quarter_Total,
  Sum(B.This_Quarter_ImplAnts) As This_Quarter_ImpLants_Total,
  Sum(B.This_Quarter_Bio) As This_Quarter_Bio_Total,
  Sum(B.Qtr_Quota) As Quarter_Quota_Total,
  Sum(B.Qtr_Quota_Impl) as Quarter_Quota_ImpL_Total,
  Sum(B.Qtr_Quota_Bio) As Quarter_Quota_Bio_Total,
  Sum(C.This_Month) As This_Month_Total,
  Sum(C.This_Month_Implants) As This_Month_Implants_Total,
  Sum(C.This_Month_Bio) As This_Month_Bio_Total,
  Sum(C.Month_Quota) As Month_Quota_Total,
  Sum(C.Month_Quota_Impl) As Month_Quota_Impl_Total,
  Sum(C.Month_Quota_Bio) As Month_Quota_Bio_Total,
  Sum(C.Py_MTD_Sd) As PY_Month_SD_Total, --Rem
  Sum(B.Py_Qtd_Sd) As PY_Quarter_SD_Total, --Rem
  Sum(A.Py_Ytd_Sd) As PY_Year_SD_Total --Rem
From
  Kd_Svq_This_Year_Reg A Left Join Kd_Svq_This_Quarter_Reg B
    On A.Region = B.Region
                     Left Join Kd_Svq_This_Month_Reg C
    On A.Region = C.Region