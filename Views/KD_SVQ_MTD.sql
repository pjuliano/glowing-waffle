Create Or Replace View KD_Svq_MTD As
Select
  A.Salesman_Code,
  A.This_Month,
  A.This_Month_Implants,
  A.This_Month_Bio,
  A.This_Month_Gross_Margin,
  Round(A.Month_Quota / Nullif(B.Total_Sales_Days,0),2) * b.elapsed_work_days as MTD_Quota,
  Round(A.Month_Quota_Impl / Nullif(B.Total_Sales_Days,0),2) As MTD_Quota_IMPL,
  Round(A.Month_Quota_Bio / Nullif(B.Total_Sales_Days,0),2) AS MTD_Quota_BIO,
  (Round(A.Month_Quota / Nullif(B.Total_Sales_Days,0),2) * b.elapsed_work_days) - nvl(A.This_Month,0) as MTD_Quota_Remaining,
  Round(A.Month_Quota_Impl / Nullif(B.Total_Sales_Days,0),2) - a.this_month_implants AS MTD_Quota_IMPL_Remaining,
  Round(A.Month_Quota_Bio / Nullif(B.Total_Sales_Days,0),2) - a.this_month_bio AS MTD_Quota_BIO_Remaining,
  Round((A.This_Month / ((A.Month_Quota / Nullif(B.Total_Sales_Days,0)) * B.Elapsed_Work_Days)) * 100,2) As Mtd_Quota_Pct,
  Round((A.This_Month_Implants / ((A.Month_Quota_Impl / Nullif(B.Total_Sales_Days,0)) * B.Elapsed_Work_Days)) * 100,2) Mtd_Quota_Pct_Impl,
  Round((A.This_Month_Bio / ((A.Month_Quota_Impl / Nullif(B.Total_Sales_Days,0)) * B.Elapsed_Work_Days)) * 100,2) Mtd_Quota_Pct_Bio,
  Round((A.This_Month / Nullif(A.Month_Quota,0)) * 100,2) As Month_Quota_Pct,
  Round((A.This_Month_Implants / Nullif(A.Month_Quota_Impl,0)) * 100,2) As Month_Quota_Pct_Impl,
  Round((A.This_Month_Bio / Nullif(A.Month_Quota_Bio,0)) * 100,2) As Month_Quota_Pct_Bio,
  A.Month_Quota - nvl(A.This_Month,0) As Month_Remaining,
  A.Month_Quota_Impl - nvl(A.This_Month_Implants,0) As Month_Remaining_Impl,
  A.Month_Quota_Bio - nvl(A.This_Month_Bio,0) As Month_Remaining_Bio
From
  Kd_Svq_This_Month A,
  KD_Work_Days_This_Month B;