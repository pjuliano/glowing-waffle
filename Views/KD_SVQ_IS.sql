Create Or Replace View KD_SVQ_IS As
Select
  A.Salesman_Code,
  E.Rep_Name,
  A.Region,
  D.Today,
  Nullif(C.This_Month,0) As This_Month,
  L.PY_This_Month_SD As PYMTD_SD,
  C.This_Month_Implants,
  C.This_Month_Bio,
  C.This_Month_Gross_Margin,
  C.Month_Quota_Pct,
  C.Mtd_Quota_Pct,
  C.Month_Remaining,
  B.This_Quarter,
  K.Py_This_Quarter_Sd As PYQTD_SD,
  B.This_Quarter_Implants,
  B.This_Quarter_Bio,
  B.Quarter_Quota_Pct,
  B.Qtd_Quota_Pct,
  B.Quarter_Remaining,
  A.This_Year,
  J.PY_Year_SD As PYYTD_SD,
  A.This_Year_Second_Half,
  A.Year_Quota_Pct,
  A.Ytd_Quota_Pct,
  A.Year_Remaining,
  F.Year_Quota_Pct_Reg,
  F.Ytd_Quota_Pct_Reg,
  F.PY_YTD_SD_REG,
  G.Quarter_Quota_Pct_Reg,
  G.Qtd_Quota_Pct_Reg,
  G.PY_QTD_SD_REG,
  H.Month_Quota_Pct_Reg,
  H.Mtd_Quota_Pct_Reg,
  H.PY_MTD_SD_REG,
  I.Year_Quota_Pct_Total,
  I.Ytd_Quota_Pct_Total,
  I.PY_Year_SD_Total,
  I.Quarter_Quota_Pct_Total,
  I.Qtd_Quota_Pct_Total,
  I.PY_Quarter_SD_Total,
  I.Month_Quota_Pct_Total,
  I.Mtd_Quota_Pct_Total,
  I.PY_Month_SD_Total
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
    On A.Region = H.Region
               Left Join KD_PY_Year_IS_SD J
    On A.Salesman_Code = J.Salesman_Code
               Left Join Kd_Py_Qtr_IS_Sd K
    On A.Salesman_Code = K.Salesman_Code
               Left Join KD_PY_Month_IS_SD L
    On A.Salesman_Code = L.Salesman_Code,
    Kd_Svq_IS_Totals_Td I;