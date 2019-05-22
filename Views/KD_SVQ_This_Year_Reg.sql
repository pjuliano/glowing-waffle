Create Or Replace View KD_SVQ_This_Year_Reg As
Select
  A.Region,
  Sum(A.This_Year) As This_Year,
  Sum(A.This_Year_Implants) As This_Year_Implants,
  Sum(A.This_Year_Bio) As This_YEar_Bio,
  Sum(A.Year_Quota) As Year_Quota,
  Sum(A.Year_Quota_Impl) As Year_Quota_Impl,
  Sum(A.Year_Quota_Bio) As Year_Quota_Bio,
  Sum(B.PY_Year_SD) As PY_YTD_SD --Rem
From
  Kd_Svq_This_Year A,
  KD_PY_Year_SD B
Where
  A.Salesman_Code = B.Salesman_Code And
  A.Region = B.Region
Group By
  A.Region;