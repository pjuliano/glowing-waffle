Create Or Replace View Kd_Svq_IS_Ytd_Reg As
Select
  A.Region,
  A.This_Year,
  Round((A.This_Year/Sum(B.Daily_Quota)) * 100,2) As Ytd_Quota_Pct_Reg,
  Round((A.This_Year / A.Year_Quota) * 100,2) As Year_Quota_Pct_Reg
From
  Kd_Svq_Is_This_Year_Reg A,
  Kd_Daily_Quota_By_Month_IS B
Where
  A.Region = B.Region
Group By
  A.Region,
  A.This_Year,
  Round((A.This_Year / A.Year_Quota) * 100,2);