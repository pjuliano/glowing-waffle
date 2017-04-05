Create Or Replace View KD_SVQ_IS_This_Month_Reg As
Select
  A.Region,
  Sum(A.This_Month) As This_Month,
  Sum(A.Month_Quota) As Month_Quota
From
  Kd_Svq_IS_This_Month A
Group By
  A.Region;