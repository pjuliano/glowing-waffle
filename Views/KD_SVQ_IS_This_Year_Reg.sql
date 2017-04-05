Create Or Replace View KD_SVQ_IS_This_Year_Reg As
Select
  A.Region,
  Sum(A.This_Year) As This_Year,
  Sum(A.Year_Quota) As Year_Quota
From
  Kd_Svq_IS_This_Year A
Group By
  A.Region;