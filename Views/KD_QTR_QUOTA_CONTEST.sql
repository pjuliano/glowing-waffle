Create Or Replace View KD_QTR_QUOTA_CONTEST AS
Select
  A.Name,
  A.Quarter_Quota_Pct,
  A.Qtd_Quota_Pct
From
  Kd_Svq A
Order By
  A.Qtd_Quota_Pct Desc