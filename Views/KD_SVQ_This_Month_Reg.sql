Create Or Replace View KD_SVQ_This_Month_Reg As
Select
  A.Region,
  Sum(A.This_Month) As This_Month,
  Sum(A.Month_Quota) As Month_Quota
From
  Kd_Svq_This_Month A
Group By
  A.Region;