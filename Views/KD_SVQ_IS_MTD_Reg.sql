Create Or Replace View Kd_Svq_IS_Mtd_Reg As
Select
  A.Region,
  A.This_Month,
  Round((A.This_Month / ((A.Month_Quota / B.Total_Sales_Days) * B.Elapsed_Work_Days)) * 100,2) As Mtd_Quota_Pct_Reg,
  Round((A.This_Month / A.Month_Quota) * 100,2) As Month_Quota_Pct_Reg,
  Round(A.Py_Mtd_Sd,2) As PY_MTD_SD_REG
From
  Kd_Svq_IS_This_Month_Reg A,
  Kd_Work_Days_This_Month B;