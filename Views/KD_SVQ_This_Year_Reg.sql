--Create Or Replace View KD_SVQ_This_Year_Reg As
Select
  A.Region,
  Sum(A.This_Year) As This_Year,
  Sum(A.This_Year_Implants) As This_Year_Implants,
  Sum(A.This_Year_Bio) As This_YEar_Bio,
  --Sum(A.Year_Quota) As Year_Quota,
  SUM(c.year) AS year_quota,
  --Sum(A.Year_Quota_Impl) As Year_Quota_Impl,
  SUM(c.year_impl) AS year_quota_impl,
  --Sum(A.Year_Quota_Bio) As Year_Quota_Bio,
  SUM(c.year_bio) AS year_quota_bio,
  Sum(B.PY_Year_SD) As PY_YTD_SD --Rem
From
  Kd_Svq_This_Year A,
  KD_PY_Year_SD B,
  kd_quota_region C
Where
  A.Salesman_Code = B.Salesman_Code And
  A.Region = B.Region
  AND A.region = c.region_code
Group By
  A.Region