Create or Replace View KD_Boomi_Svq As
Select
  Rank() Over (Order By A.YTD_Quota_Pct Desc) as Rank,
  To_Char(Sysdate,'YYYY-MM-DD') "Current_DATE",
  A.Salesman_Code,
  A.Name,
  A.Region,
  Round(A.Today) As Today,
  Round(A.This_Month) As This_Month,
  Round(A.This_Month_Implants) As This_Month_Implants,
  Round(A.This_Month_Bio) As This_Month_Bio,
  Round(A.This_Month_Gross_Margin) As This_Month_Gross_Margin,
  A.Month_Quota_Pct,
  A.Mtd_Quota_Pct,
  Round(A.Month_Remaining) As Month_Remaining,
  Round(B.Month_Quota) As Month_Quota,
  Round(A.Month_Remaining / Nullif((C.Total_Sales_Days - C.Elapsed_Work_Days),0)) As Avg_Per_Day_Req_Month,
  Case When Round(((B.Month_Quota / C.Total_Sales_Days) * C.Elapsed_Work_Days) - A.This_Month) > 0 
       Then Round(((B.Month_Quota / C.Total_Sales_Days) * C.Elapsed_Work_Days) - A.This_Month)
       Else 0
  End As "SALES_TODAY_TO_HIT_100%_MTD",
  Round(A.This_Quarter) As This_Quarter,
  Round(A.This_Quarter_Implants) As This_Quarter_Implants,
  Round(A.This_Quarter_Bio) As This_Quarter_Bio,
  Round(D.Qtr_Quota) As Qtr_Quota,
  A.Quarter_Quota_Pct,
  A.Qtd_Quota_Pct,
  I.QtD_Margin,
  Round(A.Quarter_Remaining) As Quarter_Remaining,
  Round(A.This_Year) As This_Year,
  Round(A.This_Year_Second_Half) As This_Year_Second_Half,
  Round(E.Year_Quota) As Year_Quota,
  A.Year_Quota_Pct,
  A.Ytd_Quota_Pct,
  I.YTD_Margin,
  Round(A.Year_Remaining) As Year_Remaining,
  F.Qm1_Impl,
  F.Qm1_Imp_Com_Base,
  F."QM1_IMP_COM+",
  F.Qm1_Bio,
  F.Qm1_Bio_Com_Base,
  F."QM1_BIO_COM+",
  F.Qm2_Impl,
  F.Qm2_Imp_Com_Base,
  F."QM2_IMP_COM+",
  F.Qm2_Bio,
  F.Qm2_Bio_Com_Base,
  F."QM2_BIO_COM+",
  F.Qm3_Impl,
  F.Qm3_Imp_Com_Base,
  F."QM3_IMP_COM+",
  F.Qm3_Bio,
  F.Qm3_Bio_Com_Base,
  F."QM3_BIO_COM+",
  A.Year_Quota_Pct_Reg,
  A.YTD_Quota_PCT_REG,
  A.Quarter_Quota_Pct_Reg,
  A.Qtd_Quota_Pct_Reg,
  A.Month_Quota_Pct_Reg,
  A.MTD_Quota_PCT_REG,
  A.Year_Quota_Pct_Total,
  A.Ytd_Quota_Pct_Total,
  A.Quarter_Quota_Pct_Total,
  A.Qtd_Quota_Pct_Total,
  A.Month_Quota_Pct_Total,
  A.Mtd_Quota_Pct_Total,
  C.Total_Sales_Days - C.Elapsed_Work_Days As Sales_Days_Remaining_Month,
  Round(G.This_Month) As This_Month_Reg,
  Round(G.Month_Quota) As Month_Quota_Reg,
  Round(G.Month_Quota - G.This_Month) As Month_Remaining_Reg,
  Round(H.This_Quarter) As This_Quarter_Reg,
  A.Pymtd_Sd,
  A.Pyqtd_Sd,
  A.Pyytd_Sd,
  A.Py_mtd_Sd_Reg,
  A.Py_Qtd_Sd_Reg,
  A.Py_Ytd_Sd_Reg,
  A.Py_Month_Sd_Total,
  A.Py_Quarter_Sd_Total,
  A.Py_Year_Sd_Total
From
  Kd_Svq A,
  Kd_Svq_This_Month B,
  Kd_Monthly_Calendar C,
  Kd_Svq_This_Quarter D,
  Kd_Svq_This_Year E,
  Kd_Cq_Commission F,
  Kd_Svq_This_Month_Reg G,
  Kd_Svq_This_Quarter_Reg H,
  KD_Svq_Margins I
Where
  A.Salesman_Code = B.Salesman_Code And
  C.Month = Extract(Month From Sysdate) And
  A.Salesman_Code = D.Salesman_Code And
  A.Salesman_Code = E.Salesman_Code And
  A.Salesman_Code = F.Salesman_Code And
  A.Region = G.Region And
  A.Region = H.Region And 
  A.Salesman_Code = I.Salesman_Code And
  A.Salesman_Code != '999'
Order By
  A.Salesman_Code Asc