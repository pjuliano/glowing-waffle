Create Or Replace View KD_Svq_QTD_Alt As
Select
  A.Salesman_Code,
  A.Region,
  A.This_Quarter,
  A.Qtr_Quota,
  Round((A.This_Quarter  /Sum(B.Daily_Quota)) * 100,2) As Qtd_Quota_Pct,
  Round((A.This_Quarter / A.Qtr_Quota) * 100,2) As Quarter_Quota_Pct,
  A.Qtr_Quota - A.This_Quarter As Quarter_Remaining
From
  Kd_Svq_This_Quarter A,
  Kd_Daily_Quota_By_Month B
Where
  A.Salesman_Code = B.Salesman_Code And
  B.Qtr = Case
            When
              Extract(Month From Sysdate) In (1,2,3)
            Then
              'QTR1'
            When
              Extract(Month From Sysdate) In (4,5,6)
            Then
              'QTR2'
            When
              Extract(Month From Sysdate) In (7,8,9)
            Then
              'QTR3'
            When
              Extract(Month From Sysdate) IN (10,11,12)
            Then
              'QTR4'
          End
Group By
  A.Salesman_Code,
  A.Region,
  A.This_Quarter,
  A.Qtr_Quota,
  Round((A.This_Quarter / A.Qtr_Quota) * 100,2),
  A.Qtr_Quota - A.This_Quarter;
  
Create Or Replace View KD_SVQ_YTD_Alt As
Select
  A.Salesman_Code,
  A.Region,
  A.This_Year,
  Round((A.This_Year / Sum(B.Daily_Quota)) * 100,2) As Ytd_Quota_Pct,
  Round((A.This_Year / A.Year_Quota) * 100,2) As Year_Quota_Pct,
  A.Year_Quota - A.This_Year As Year_Remaining
From
  Kd_Svq_This_Year A,
  KD_Daily_Quota_By_Month B
Where
  A.Salesman_Code = B.Salesman_Code
Group By
  A.Salesman_Code,
  A.Region,
  A.This_Year,
  Round((A.This_Year / A.Year_Quota) * 100,2),
  A.Year_Quota - A.This_Year;
  
Create Or Replace View Kd_Svq_Qtd_Reg_Alt As
Select
  A.Region,
  A.This_Quarter,
  Round((A.This_Quarter / Sum(B.Daily_Quota)) * 100,2) As Qtd_Quota_Pct_Reg,
  Round((A.This_Quarter / A.Qtr_Quota) * 100,2) As Quarter_Quota_Pct_Reg
From
  Kd_Svq_This_Quarter_Reg A,
  KD_Daily_Quota_By_Month B
Where
  A.Region = B.Region And
  B.Qtr = Case
            When
              Extract(Month From Sysdate) In (1,2,3)
            Then
              'QTR1'
            When
              Extract(Month From Sysdate) In (4,5,6)
            Then
              'QTR2'
            When
              Extract(Month From Sysdate) In (7,8,9)
            Then
              'QTR3'
            When
              Extract(Month From Sysdate) IN (10,11,12)
            Then
              'QTR4'
          End
Group By
  A.Region,
  A.This_Quarter,
  Round((A.This_Quarter / A.Qtr_Quota) * 100,2);
Create Or Replace View Kd_Svq_Ytd_Reg_Alt As
Select
  A.Region,
  A.This_Year,
  Round((A.This_Year/Sum(B.Daily_Quota)) * 100,2) As YTD_Quota_PCT_Reg,
  Round((A.This_Year / A.Year_Quota) * 100,2) As Year_Quota_Pct_Reg
From
  Kd_Svq_This_Year_Reg A,
  KD_Daily_Quota_By_Month B
Where
  A.Region = B.Region
Group By
  A.Region,
  A.This_Year,
  Round((A.This_Year / A.Year_Quota) * 100,2);
  
Create or Replace View KD_SVQ_Totals_TD_Alt As
With Qtr_Total_Quota As (
Select 
  Sum(Daily_Quota) As Qtr_Total_Quota
From 
  Kd_Daily_Quota_By_Month  
Where 
  Qtr = Case
          When
           Extract(Month From Sysdate) In (1,2,3)
          Then
           'QTR1'
          When 
           Extract(Month From Sysdate) In (4,5,6)
          Then
           'QTR2'
          When
           Extract(Month From Sysdate) In (7,8,9)
          Then
           'QTR3'
          When
           Extract(Month From Sysdate) In (10,11,12)
          Then
             'QTR4'
          End),
Month_total_quota As (
Select
  Sum(Daily_Quota) As Month_Total_Quota
From 
  Kd_Daily_Quota_By_Month
Where
  Extract(Month From Sysdate) = Month)
Select
  Round((A.This_Year_Total / Sum(B.Daily_Quota)) * 100,2) As Ytd_Quota_Pct_Total,
  Round((A.This_Year_Total / A.Year_Quota_Total) * 100,2) As Year_Quota_Pct_Total,
  Round((A.This_Year_Total / C.Qtr_Total_Quota) * 100,2) As Qtd_Quota_Pct_Total,
  Round((A.This_Quarter_Total / A.Quarter_Quota_Total) * 100,2) As Quarter_Quota_Pct_Total,
  Round((A.This_Month_Total / D.Month_Total_Quota) * 100,2) As Mtd_Quota_Pct_Total,
  Round((A.This_Month_Total / A.Month_Quota_Total) * 100,2) As Month_Quota_PCT_Total
From
  Kd_Svq_Totals A,
  Kd_Daily_Quota_By_Month B,
  Qtr_total_quota C,
  Month_Total_Quota D
Group By
  A.This_Year_Total,
  Round((A.This_Year_Total / A.Year_Quota_Total) * 100,2),
  Round((A.This_Year_Total / C.Qtr_Total_Quota) * 100,2),
  Round((A.This_Quarter_Total / A.Quarter_Quota_Total) * 100,2),
  Round((A.This_Month_Total / D.Month_Total_Quota) * 100,2),
  Round((A.This_Month_Total / A.Month_Quota_Total) * 100,2);
  
Create Or Replace View KD_SVQ_Alt As
Select
  A.Salesman_Code,
  E.Name,
  A.Region,
  D.Today,
  C.This_Month,
  C.This_Month_Implants,
  C.This_Month_Bio,
  C.This_Month_Gross_Margin,
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
  Kd_Svq_Ytd_Alt A Left Join Kd_Svq_Qtd_Alt B
    On A.Salesman_Code = B.Salesman_Code
               Left Join Kd_Svq_Mtd C
    On A.Salesman_Code = C.Salesman_Code
               Left Join Kd_Svq_Today D
    On A.Salesman_Code = D.Salesman_Code
               Left Join Person_Info E
    On A.Salesman_Code = E.Person_Id
               Left Join Kd_Svq_Ytd_Reg_Alt F
    On A.Region = F.Region
               Left Join Kd_Svq_Qtd_Reg_Alt G
    On A.Region = G.Region
               Left Join Kd_Svq_Mtd_Reg H
    On A.Region = H.Region,
    Kd_Svq_Totals_Td_Alt I;
