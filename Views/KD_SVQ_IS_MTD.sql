Create Or Replace View KD_Svq_IS_MTD As
Select
  A.Salesman_Code,
  A.This_Month,
  A.This_Month_Implants,
  A.This_Month_Bio,
  Round((A.This_Month / ((A.Month_Quota / B.Total_Sales_Days) * B.Elapsed_Work_Days)) * 100,2) As Mtd_Quota_Pct,
  Round((A.This_Month / A.Month_Quota) * 100,2) As Month_Quota_Pct,
  A.Month_Quota - A.This_Month As Month_Remaining
From
  Kd_Svq_Is_This_Month A,
  KD_Work_Days_This_Month B;