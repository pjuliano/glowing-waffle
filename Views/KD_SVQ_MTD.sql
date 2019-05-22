Create Or Replace View KD_Svq_MTD As
Select
  A.Salesman_Code,
  A.This_Month,
  A.This_Month_Implants,
  A.This_Month_Bio,
  A.This_Month_Gross_Margin,
  Round((A.This_Month / ((A.Month_Quota / B.Total_Sales_Days) * B.Elapsed_Work_Days)) * 100,2) As Mtd_Quota_Pct,
  Round((A.This_Month_Implants / ((A.Month_Quota_Impl / B.Total_Sales_Days) * B.Elapsed_Work_Days)) * 100,2) Mtd_Quota_Pct_Impl,
  Round((A.This_Month_Bio / ((A.Month_Quota_Impl / B.Total_Sales_Days) * B.Elapsed_Work_Days)) * 100,2) Mtd_Quota_Pct_Bio,
  Round((A.This_Month / Nullif(A.Month_Quota,0)) * 100,2) As Month_Quota_Pct,
  Round((A.This_Month_Implants / Nullif(A.Month_Quota_Impl,0)) * 100,2) As Month_Quota_Pct_Impl,
  Round((A.This_Month_Bio / Nullif(A.Month_Quota_Bio,0)) * 100,2) As Month_Quota_Pct_Bio,
  A.Month_Quota - A.This_Month As Month_Remaining,
  A.Month_Quota_Impl - A.This_Month_Implants As Month_Remaining_Impl,
  A.Month_Quota_Bio - A.This_Month_Bio As Month_Remaining_Bio
From
  Kd_Svq_This_Month A,
  KD_Work_Days_This_Month B;