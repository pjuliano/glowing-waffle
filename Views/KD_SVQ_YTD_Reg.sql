Create Or Replace View Kd_Svq_Ytd_Reg As
Select
  A.Region,
  A.This_Year,
  Round((A.This_Year/Sum(B.Daily_Quota)) * 100,2) As YTD_Quota_PCT_Reg,
  Round((A.This_Year / A.Year_Quota) * 100,2) As Year_Quota_Pct_Reg
From
  Kd_Svq_This_Year_Reg A,
  Kd_Daily_Quota_By_Month B
Where
  A.Region = B.Region
Group By
  A.Region,
  A.This_Year,
  Round((A.This_Year / A.Year_Quota) * 100,2);