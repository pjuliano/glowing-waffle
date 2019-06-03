Create Or Replace View KD_SVQ As
Select
  A.Salesman_Code,
  E.Name,
  A.Region,
  Nvl(D.Today,0) As Today,
  Nvl(C.This_Month,0) As This_Month,
  L.PY_This_Month_SD As PYMTD_SD,
  C.This_Month_Implants,
  C.This_Month_Bio,
  C.Month_Quota_Pct,
  C.Month_Quota_Pct_Impl,
  C.Month_Quota_Pct_Bio,
  C.MTD_Quota,
  C.MTD_Quota_Impl,
  C.MTD_Quota_Bio,
  c.mtd_quota_remaining,
  c.mtd_quota_impl_remaining,
  c.mtd_Quota_bio_remaining,
  C.Mtd_Quota_Pct,
  C.MTD_Quota_Pct_Impl,
  C.MTD_Quota_Pct_Bio,
  C.Month_Remaining,
  C.Month_Remaining_Impl,
  C.Month_Remaining_Bio,
  B.This_Quarter,
  K.Py_This_Quarter_Sd As PYQTD_SD,
  B.This_Quarter_Implants,
  B.This_Quarter_Bio,
  B.Quarter_Quota_Pct,
  B.Quarter_Quota_Pct_Impl,
  B.Quarter_Quota_Pct_Bio,
  B.Qtd_Quota_Pct,
  B.Qtd_Quota_Pct_Impl,
  B.Qtd_Quota_Pct_Bio,
  B.Quarter_Remaining,
  B.Quarter_Remaining_Impl,
  B.Quarter_Remaining_Bio,
  A.This_Year,
  A.This_Year_Implants,
  A.This_Year_Bio,
  J.PY_Year_SD As PYYTD_SD,
  A.Year_Quota_Pct,
  A.YEar_Quota_Pct_Impl,
  A.Year_Quota_Pct_Bio,
  A.Ytd_quota,
  A.Ytd_Quota_Pct,
  A.YTD_quota_remaining,
  A.YTD_Quota_Impl,
  A.Ytd_Quota_Pct_Impl,
  a.ytd_quota_impl_remaining,
  A.YTD_Quota_Bio,
  A.Ytd_Quota_Pct_Bio,
  a.ytd_quota_bio_remaining,
  A.Year_Remaining,
  A.Year_Remaining_Impl,
  A.Year_Remaining_Bio,
  H.Month_Quota_Pct_Reg,
  H.Month_Quota_Pct_Impl_Reg,
  H.month_Quota_Pct_Bio_Reg,
  H.Mtd_Quota_Pct_Reg,
  H.mtd_Quota_Pct_Impl_Reg,
  H.mtd_Quota_Pct_Bio_Reg,
  H.PY_MTD_SD_REG,
  G.Quarter_Quota_Pct_Reg,
  G.Quarter_Quota_Pct_Impl_Reg,
  G.Quarter_Quota_Pct_Bio_Reg,
  G.Qtd_Quota_Pct_Reg,
  G.Qtd_Quota_Pct_Impl_Reg,
  G.Qtd_Quota_Pct_Bio_Reg,
  G.PY_QTD_SD_REG,
  F.Year_Quota_Pct_Reg,
  F.Year_Quota_Pct_Impl_Reg,
  F.Year_Quota_Pct_Bio_Reg,
  F.Ytd_Quota_Pct_Reg,
  F.YTD_Quota_Pct_Impl_reg,
  F.YTD_Quota_Pct_Bio_Reg,
  F.PY_YTD_SD_REG,
  I.Year_Quota_Pct_Total,
  I.year_Quota_Pct_Impl_Total,
  I.year_Quota_Pct_Bio_Total,
  I.Ytd_Quota_Pct_Total,
  I.ytd_Quota_Pct_Impl_Total,
  I.ytd_Quota_Pct_Bio_Total,
  I.PY_Year_SD_Total,
  I.Quarter_Quota_Pct_Total,
  I.quarter_Quota_Pct_Impl_Total,
  I.quarter_Quota_Pct_Bio_Total,
  I.Qtd_Quota_Pct_Total,
  I.Qtd_Quota_Pct_Impl_Total,
  I.Qtd_Quota_Pct_Bio_Total,
  I.PY_Quarter_SD_Total,
  I.Month_Quota_Pct_Total,
  I.month_Quota_Pct_Impl_Total,
  I.month_Quota_Pct_Bio_Total,
  I.Mtd_Quota_Pct_Total,
  I.mtd_Quota_Pct_Impl_Total,
  I.mtd_Quota_Pct_Bio_Total,
  I.PY_Month_SD_Total
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
    On A.Region = H.Region
               Left Join KD_PY_Year_SD J
    On A.Salesman_Code = J.Salesman_Code
               Left Join Kd_Py_Qtr_Sd K
    On A.Salesman_Code = K.Salesman_Code
               Left Join KD_PY_Month_SD L
    On A.Salesman_Code = L.Salesman_Code,
    Kd_Svq_Totals_Td I;