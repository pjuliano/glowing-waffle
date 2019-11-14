--Create Or Replace View KD_SVQ_This_Quarter_Reg As
Select
  A.Region,
  Sum(A.This_Quarter) As This_Quarter,
  Sum(A.This_Quarter_Implants) As This_Quarter_Implants,
  Sum(A.This_Quarter_Bio) As This_Quarter_Bio,
  Sum(A.Qtr_Quota) As Qtr_Quota,
  Sum(A.Qtr_Quota_Impl) As Qtr_Quota_Impl,
  Sum(A.Qtr_Quota_Bio) As Qtr_Quota_Bio,
  Sum(B.PY_This_Quarter_SD) As PY_QTD_SD --Rem
From
  Kd_Svq_This_Quarter A,
  KD_PY_Qtr_SD B 
Where
  A.Region = B.Region And
  A.Salesman_Code = B.Salesman_Code
Group By
  A.Region;