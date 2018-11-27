Create Or Replace View KD_SVQ_IS_This_Quarter_Reg As
Select
  A.Region,
  Sum(A.This_Quarter) As This_Quarter,
  Sum(A.Qtr_Quota) As Qtr_Quota,
  Sum(B.PY_This_Quarter_SD) As PY_QTD_SD
From
  Kd_Svq_IS_This_Quarter A,
  KD_PY_Qtr_SD B 
Where
  A.Region = B.Region And
  A.Salesman_Code = B.Salesman_Code
Group By
  A.Region;