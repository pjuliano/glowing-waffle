Create Or Replace View KD_SVQ_IS_This_Quarter_Reg As
Select
  A.Region,
  Sum(A.This_Quarter) As This_Quarter,
  Sum(A.Qtr_Quota) As Qtr_Quota
From
  Kd_Svq_IS_This_Quarter A
Group By
  A.Region;