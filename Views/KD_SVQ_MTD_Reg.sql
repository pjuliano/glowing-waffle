Create Or Replace View Kd_Svq_Mtd_Reg As
Select
  A.Region,
  A.This_Month,
  A.This_Month_Implants,
  A.This_Month_Bio,
  Round((A.This_Month / ((A.Month_Quota / Nullif(B.Total_Sales_Days,0)) * B.Elapsed_Work_Days)) * 100,2) As Mtd_Quota_Pct_Reg,
  Round((A.This_Month_Implants / ((A.Month_Quota_Impl / Nullif(B.Total_Sales_Days,0)) * B.Elapsed_Work_Days)) * 100,2) As MTD_Quota_Pct_Impl_Reg,
  Round((A.This_Month_Bio / ((A.Month_Quota_Bio / Nullif(B.Total_Sales_Days,0)) * B.Elapsed_Work_Days)) * 100,2) As MTD_Quota_Pct_Bio_Reg,
  Round((A.This_Month / Nullif(A.Month_Quota,0)) * 100,2) As Month_Quota_Pct_Reg,
  Round((A.This_Month_Implants / Nullif(A.Month_Quota_Impl,0)) * 100,2) As Month_Quota_Pct_Impl_Reg,
  Round((A.This_Month_Bio / Nullif(A.Month_Quota_Bio,0)) * 100,2) As Month_Quota_Pct_Bio_Reg,
  Round(A.Py_Mtd_Sd,2) As PY_MTD_SD_REG --Rem
From
  Kd_Svq_This_Month_Reg A,
  Kd_Work_Days_This_Month B