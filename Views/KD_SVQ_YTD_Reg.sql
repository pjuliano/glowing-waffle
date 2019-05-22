Create Or Replace View Kd_Svq_Ytd_Reg As
Select
  A.Region,
  A.This_Year,
  A.This_Year_Implants,
  A.This_Year_Bio,
  Round((A.This_Year / Nullif(Sum(B.Daily_Quota),0)) * 100,2) As YTD_Quota_PCT_Reg,
  Round((A.This_Year_Implants / Nullif(Sum(B.Daily_Quota_Impl),0)) * 100,2) As YTD_Quota_Pct_Impl_Reg,
  Round((A.This_Year_Bio / Nullif(Sum(B.Daily_Quota_Bio),0)) * 100,2) As YTD_Quota_Pct_Bio_Reg,
  Round((A.This_Year / Nullif(A.Year_Quota,0)) * 100,2) As Year_Quota_Pct_Reg,
  Round((A.This_Year_Implants / Nullif(A.Year_Quota_Impl,0)) * 100,2) As Year_Quota_Pct_Impl_Reg,
  Round((A.This_Year_Bio / Nullif(A.Year_Quota_Bio,0)) * 100,2) As Year_Quota_Pct_Bio_Reg,
  Round(A.PY_YTD_SD,2) AS PY_YTD_SD_REG --Rem
From
  Kd_Svq_This_Year_Reg A,
  Kd_Daily_Quota_By_Month B
Where
  A.Region = B.Region
Group By
  A.Region,
  A.This_Year,
  A.This_Year_Implants,
  A.This_Year_Bio,
  Round((A.This_Year / Nullif(A.Year_Quota,0)) * 100,2),
  Round((A.This_Year_Implants / Nullif(A.Year_Quota_Impl,0)) * 100,2),
  Round((A.This_Year_Bio / Nullif(A.Year_Quota_Bio,0)) * 100,2),
  Round(A.PY_YTD_SD,2);