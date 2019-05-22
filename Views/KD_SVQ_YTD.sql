Create Or Replace View KD_SVQ_YTD As
Select
  A.Salesman_Code,
  A.Region,
  A.This_Year,
  A.This_Year_Implants,
  A.This_Year_Bio,
  A.This_Year_Second_Half,
  Round((A.This_Year / Nullif(Sum(B.Daily_Quota),0)) * 100,2) As Ytd_Quota_Pct,
  Round((A.This_Year_Implants / Nullif(Sum(B.Daily_Quota_Impl),0)) * 100,2) as YTD_Quota_Pct_Impl,
  Round((A.This_Year_Bio / Nullif(Sum(B.Daily_Quota_Bio),0)) * 100,2) As YTD_Quota_Pct_Bio,
  Round((A.This_Year / Nullif(A.Year_Quota,0)) * 100,2) As Year_Quota_Pct,
  Round((A.This_Year_Implants / Nullif(A.Year_Quota_Impl,0)) * 100,2) As Year_Quota_Pct_Impl,
  Round((A.This_Year_Bio / Nullif(A.Year_Quota_Bio,0)) * 100,2) As Year_Quota_Pct_Bio,
  A.Year_Quota - A.This_Year As Year_Remaining,
  A.Year_Quota_Impl - A.This_Year_Implants as Year_Remaining_Impl,
  A.Year_Quota_Bio - A.This_Year_Bio As Year_Remaining_Bio
From
  Kd_Svq_This_Year A,
  Kd_Daily_Quota_By_Month B
Where
  A.Salesman_Code = B.Salesman_Code
Group By
  A.Salesman_Code,
  A.Region,
  A.This_Year,
  A.This_Year_Implants,
  A.This_Year_Bio,
  A.This_Year_Second_Half,
  Round((A.This_Year / Nullif(A.Year_Quota,0)) * 100,2),
  Round((A.This_Year_Implants / Nullif(A.Year_Quota_Impl,0)) * 100,2),
  Round((A.This_Year_Bio / Nullif(A.Year_Quota_Bio,0)) * 100,2),
  A.Year_Quota - A.This_Year,
  A.Year_Quota_Impl - A.This_Year_Implants,
  A.Year_Quota_Bio - A.This_Year_Bio;