Create Or Replace View Kd_Svq_Totals_Td As
With Qtr_Total_Quota As (
Select 
  Sum(Daily_Quota) As Qtr_Total_Quota,
  Sum(Daily_Quota_Impl) As Qtr_Total_Quota_Impl,
  Sum(Daily_Quota_Bio) As Qtr_Total_Quota_Bio
From 
  Kd_Daily_Quota_By_Month  
Where 
  Qtr = Case
          When
           Extract(Month From Sysdate) In (1,2,3)
          Then
           'QTR1'
          When 
           Extract(Month From Sysdate) In (4,5,6)
          Then
           'QTR2'
          When
           Extract(Month From Sysdate) In (7,8,9)
          Then
           'QTR3'
          When
           Extract(Month From Sysdate) In (10,11,12)
          Then
             'QTR4'
          End),
Month_total_quota As (
Select
  Sum(Daily_Quota) As Month_Total_Quota,
  Sum(Daily_Quota_Impl) As Month_Total_Quota_Impl,
  Sum(Daily_Quota_Bio) As Month_Total_Quota_Bio
From 
  Kd_Daily_Quota_By_Month
Where
  Extract(Month From Sysdate) = Month)
Select
  Round((A.This_Year_Total / Sum(B.Daily_Quota)) * 100,2) As Ytd_Quota_Pct_Total,
  Round((A.This_Year_Implants_Total / Sum(B.Daily_Quota_Impl)) * 100,2) As YTD_Quota_Pct_Impl_Total,
  Round((A.This_Year_Bio_Total / Sum(B.Daily_Quota_Bio)) * 100,2) As YTD_Quota_Pct_Bio_Total,
  Round((A.This_Year_Total / A.Year_Quota_Total) * 100,2) As Year_Quota_Pct_Total,
  Round((A.This_Year_Implants_Total / A.Year_Quota_Impl_Total) * 100) As Year_Quota_Pct_Impl_Total,
  Round((A.This_Year_Bio_Total / A.Year_Quota_Bio_Total) * 100) As Year_Quota_Pct_Bio_Total,
  Round((A.This_Quarter_Total / C.Qtr_Total_Quota) * 100,2) As Qtd_Quota_Pct_Total,
  Round((A.This_Quarter_Implants_Total / C.Qtr_Total_Quota_Impl) * 100,2) as Qtd_Quota_Pct_Impl_Total,
  Round((A.This_Quarter_Bio_Total / C.Qtr_Total_Quota_Bio) * 100,2) As QTD_Quota_Pct_Bio_Total,
  Round((A.This_Quarter_Total / A.Quarter_Quota_Total) * 100,2) As Quarter_Quota_Pct_Total,
  Round((A.This_Quarter_Implants_Total / A.Quarter_Quota_Impl_Total) * 100,2) As Quarter_Quota_Pct_Impl_Total,
  Round((A.This_Quarter_Bio_Total / A.Quarter_Quota_Bio_Total) * 100,2) As Quarter_Quota_Pct_Bio_Total,
  Round((A.This_Month_Total / D.Month_Total_Quota) * 100,2) As Mtd_Quota_Pct_Total,
  Round((A.This_Month_Implants_Total / D.Month_Total_Quota_Impl) * 100,2) As MTD_Quota_PCt_Impl_Total,
  Round((A.This_Month_Bio_Total / D.Month_Total_Quota_Bio) * 100,2) As MTD_Quota_Pct_Bio_Total,
  Round((A.This_Month_Total / A.Month_Quota_Total) * 100,2) As Month_Quota_PCT_Total,
  Round((A.This_Month_Implants_Total / A.Month_Quota_Impl_Total) * 100,2) As Month_Quota_Pct_Impl_Total,
  Round((A.This_Month_Bio_Total / A.Month_Quota_Bio_Total) * 100,2) As Month_Quota_Pct_Bio_Total,
  Round(A.PY_Month_SD_Total,2) As PY_Month_SD_Total, --Rem
  Round(A.PY_Quarter_SD_Total,2) As PY_Quarter_SD_Total, --Rem
  Round(A.PY_Year_SD_Total,2) As PY_Year_SD_Total --Rem
From
  Kd_Svq_Totals A,
  Kd_Daily_Quota_By_Month B,
  Qtr_total_quota C,
  Month_Total_Quota D 
Group By 
  A.This_Year_Total,
  A.This_Year_Implants_Total,
  A.This_Year_Bio_Total,
  Round((A.This_Year_Total / A.Year_Quota_Total) * 100,2), 
  Round((A.This_Year_Implants_Total / A.Year_Quota_Impl_Total) * 100), 
  Round((A.This_Year_Bio_Total / A.Year_Quota_Bio_Total) * 100), Round((A.This_Quarter_Total / C.Qtr_Total_Quota) * 100,2), 
  Round((A.This_Quarter_Implants_Total / C.Qtr_Total_Quota_Impl) * 100,2), 
  Round((A.This_Quarter_Bio_Total / C.Qtr_Total_Quota_Bio) * 100,2), 
  Round((A.This_Quarter_Total / A.Quarter_Quota_Total) * 100,2), 
  Round((A.This_Quarter_Implants_Total / A.Quarter_Quota_Impl_Total) * 100,2),
  Round((A.This_Quarter_Bio_Total / A.Quarter_Quota_Bio_Total) * 100,2),
  Round((A.This_Month_Total / D.Month_Total_Quota) * 100,2), 
  Round((A.This_Month_Implants_Total / D.Month_Total_Quota_Impl) * 100,2),
  Round((A.This_Month_Bio_Total / D.Month_Total_Quota_Bio) * 100,2),
  Round((A.This_Month_Total / A.Month_Quota_Total) * 100,2), 
  Round((A.This_Month_Implants_Total / A.Month_Quota_Impl_Total) * 100,2),
  Round((A.This_Month_Bio_Total / A.Month_Quota_Bio_Total) * 100,2),
  Round(A.PY_Month_SD_Total,2),
  Round(A.PY_Quarter_SD_Total,2), 
  Round(A.PY_Year_SD_Total,2)
