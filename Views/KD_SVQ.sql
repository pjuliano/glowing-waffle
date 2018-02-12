Create Or Replace View KD_SVQ As
Select
  A.Salesman_Code,
  E.Name,
  A.Region,
  D.Today,
  Nullif(C.This_Month,0) As This_Month,
  C.This_Month_Implants,
  C.This_Month_Bio,
  C.This_Month_Gross_Margin,
  C.Month_Quota_Pct,
  C.Mtd_Quota_Pct,
  C.Month_Remaining,
  B.This_Quarter,
  B.This_Quarter_Implants,
  B.This_Quarter_Bio,
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
  Kd_Svq_Ytd A Left Join Kd_Svq_Qtd B
    On A.Salesman_Code = B.Salesman_Code
               Left Join Kd_Svq_Mtd C
    On A.Salesman_Code = C.Salesman_Code
               Left Join Kd_Svq_Today D
    On A.Salesman_Code = D.Salesman_Code
               Left Join Person_Info E
    On A.Salesman_Code = E.Person_Id
               Left Join Kd_Svq_Ytd_Reg F
    On A.Region = F.Region
               Left Join Kd_Svq_Qtd_Reg G
    On A.Region = G.Region
               Left Join Kd_Svq_Mtd_Reg H
    On A.Region = H.Region,
    Kd_Svq_Totals_Td I;