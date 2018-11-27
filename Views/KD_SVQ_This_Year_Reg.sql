Create Or Replace View KD_SVQ_This_Year_Reg As
Select
  A.Region,
  Sum(A.This_Year) As This_Year,
  Sum(A.Year_Quota) As Year_Quota,
  Sum(B.PY_Year_SD) As PY_YTD_SD
From
  Kd_Svq_This_Year A,
  KD_PY_Year_SD B
Where
  A.Salesman_Code = B.Salesman_Code And
  A.Region = B.Region
Group By
  A.Region;