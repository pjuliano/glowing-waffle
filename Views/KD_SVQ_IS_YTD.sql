Create Or Replace View KD_SVQ_IS_YTD As
Select
  A.Salesman_Code,
  A.Region,
  A.This_Year,
  A.This_Year_Second_Half,
  Round((A.This_Year / Sum(B.Daily_Quota)) * 100,2) As Ytd_Quota_Pct,
  Round((A.This_Year / A.Year_Quota) * 100,2) As Year_Quota_Pct,
  A.Year_Quota - A.This_Year As Year_Remaining
From
  Kd_Svq_IS_This_Year A,
  Kd_Daily_Quota_By_Month_IS B
Where
  A.Salesman_Code = B.Region
Group By
  A.Salesman_Code,
  A.Region,
  A.This_Year,
  A.This_Year_Second_Half,
  Round((A.This_Year / A.Year_Quota) * 100,2),
  A.Year_Quota - A.This_Year;