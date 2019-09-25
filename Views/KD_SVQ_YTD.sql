Create Or Replace View KD_SVQ_YTD As
Select
  A.Salesman_Code,
  A.Region,
  A.This_Year,
  A.This_Year_Implants,
  A.This_Year_Bio,
  --A.This_Year_Second_Half,
  Round(Sum(B.Daily_Quota),2) as YTD_Quota,
  Round((A.This_Year / Nullif(Sum(B.Daily_Quota),0)) * 100,2) As YTD_Quota_Pct,
  Round(Sum(B.Daily_Quota),2) - nvl(A.This_Year,0) As YTD_Quota_Remaining,
  Round(Sum(B.Daily_Quota_Impl),2) as YTD_Quota_Impl,
  Round((A.This_Year_Implants / Nullif(Sum(B.Daily_Quota_Impl),0)) * 100,2) as YTD_Quota_Pct_Impl,
  A.This_Year_Implants - Round(Sum(B.Daily_Quota_Impl),2) As YTD_Quota_Impl_Remaining,
  Round(Sum(B.Daily_Quota_Bio),2)as YTD_Quota_Bio,
  Round((A.This_Year_Bio / Nullif(Sum(B.Daily_Quota_Bio),0)) * 100,2) As YTD_Quota_Pct_Bio,
  A.This_Year_Bio - Round(Sum(B.Daily_Quota_Bio),2) As YTD_Quota_Bio_Remaining,
  Round((A.This_Year / Nullif(A.Year_Quota,0)) * 100,2) As Year_Quota_Pct,
  Round((A.This_Year_Implants / Nullif(A.Year_Quota_Impl,0)) * 100,2) As Year_Quota_Pct_Impl,
  Round((A.This_Year_Bio / Nullif(A.Year_Quota_Bio,0)) * 100,2) As Year_Quota_Pct_Bio,
  A.This_Year - nvl(A.Year_Quota,0) As Year_Remaining,
  A.This_Year_Implants - nvl(A.Year_Quota_Impl,0) as Year_Remaining_Impl,
  A.This_Year_Bio - nvl(A.Year_Quota_Bio,0) As Year_Remaining_Bio
From
  Kd_Svq_This_Year A LEFT JOIN Kd_Daily_Quota_By_Month B
    ON A.Salesman_Code = B.Salesman_Code
Group By
  A.Salesman_Code,
  A.Region,
  A.This_Year,
  A.This_Year_Implants,
  A.This_Year_Bio,
  --A.This_Year_Second_Half,
  Round((A.This_Year / Nullif(A.Year_Quota,0)) * 100,2),
  Round((A.This_Year_Implants / Nullif(A.Year_Quota_Impl,0)) * 100,2),
  Round((A.This_Year_Bio / Nullif(A.Year_Quota_Bio,0)) * 100,2),
  A.This_Year - nvl(A.Year_Quota,0),
  A.This_Year_Implants - nvl(A.Year_Quota_Impl,0),
  A.This_Year_Bio - nvl(A.Year_Quota_Bio,0);