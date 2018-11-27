Create Or Replace View KD_SVQ_This_Month_Reg As
Select
  A.Region,
  Sum(A.This_Month) As This_Month,
  Sum(A.Month_Quota) As Month_Quota,
  Sum(B.PY_This_Month_SD) As PY_MTD_SD
From
  Kd_Svq_This_Month A,
  KD_PY_Month_SD B
Where
  A.Region = B.Region And
  A.Salesman_Code = B.Salesman_Code
Group By
  A.Region; 