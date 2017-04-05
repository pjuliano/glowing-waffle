Create Or Replace View KD_SVQ_IS As
Select
  A.Salesman_Code,
  E.Rep_Name,
  A.Region,
  D.Today,
  C.This_Month,
  C.This_Month_Implants,
  C.This_Month_Bio,
  C.Month_Quota_Pct,
  C.Mtd_Quota_Pct,
  C.Month_Remaining,
  B.This_Quarter,
  B.Quarter_Quota_Pct,
  B.Qtd_Quota_Pct,
  B.Quarter_Remaining,
  A.This_Year,
  A.Year_Quota_Pct,
  A.Ytd_Quota_Pct,
  A.Year_Remaining,
  F.Year_Quota_Pct_Reg,
  F.Ytd_Quota_Pct_Reg,
  G.Quarter_Quota_Pct_Reg,
  G.Qtd_Quota_Pct_Reg,
  H.Month_Quota_Pct_Reg,
  H.Mtd_Quota_Pct_Reg,
  I.Year_Quota_Pct_Total,
  I.Ytd_Quota_Pct_Total,
  I.Quarter_Quota_Pct_Total,
  I.Qtd_Quota_Pct_Total,
  I.Month_Quota_Pct_Total,
  I.Mtd_Quota_Pct_Total
From
  Kd_Svq_IS_Ytd A Left Join Kd_Svq_IS_Qtd B
    On A.Salesman_Code = B.Salesman_Code
               Left Join Kd_Svq_IS_Mtd C
    On A.Salesman_Code = C.Salesman_Code
               Left Join Kd_Svq_IS_Today D
    On A.Salesman_Code = D.Salesman_Code
               Left Join Srrepquotainside E
    On A.Salesman_Code = E.Region
               Left Join Kd_Svq_IS_Ytd_Reg F
    On A.Region = F.Region
               Left Join Kd_Svq_IS_Qtd_Reg G
    On A.Region = G.Region
               Left Join Kd_Svq_IS_Mtd_Reg H
    On A.Region = H.Region,
    Kd_Svq_IS_Totals_Td I;