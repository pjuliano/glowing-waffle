Create Or Replace View KD_Svq_Today As
Select
  A.Salesman_Code,
  Sum(A.AllAmounts) As Today
From
  KD_Sales_Data_Request A
Where
  A.Invoicedate = Trunc(Sysdate) And
  A.Charge_Type = 'Parts' And
  --Begin Change 03072017
  --Now excluding W and X orders so sales totals will match Daily Commissions per M. Nealon
  --A.Corporate_Form = 'DOMDIR'
  A.Corporate_Form = 'DOMDIR' And
  ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null)
  --End Change 03072017
Group By
  A.Salesman_Code;
  
Create Or Replace View KD_Svq_This_Month As
Select
  A.Salesman_Code,
  Sum(A.Allamounts) As This_Month,
  Sum(Case
        When
          --Begin Change 02142017.1
          --Changed case statement to include "other" as in the Daily Commissions report per Kevin Munroe.
          --In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED') 
          A.Part_Product_Code Not In ('LIT','REGEN')
          --End change 02142017.1
        Then
          A.Allamounts
        Else
          0
      End) As This_Month_Implants,
  Sum(Case
        When
          A.Part_Product_Code = 'REGEN'
        Then
          A.Allamounts
        Else
          0
      End) As This_Month_Bio,
  --Begin Change 02142017.2
  --Added This_Month_Gross_Margin per RMs.
  Sum(Case
        When
          A.Part_Product_Code != 'LIT' And 
          A.Order_No Not Like 'W%' And
          A.Order_No Not Like 'X%'
        Then
          Round((A.Allamounts - (A.Cost * A.Invoiced_Qty)),2)
      End) As This_Month_Gross_Margin,
  --End Change 02142017.2
  Case
    When
      Extract(Month From Sysdate) = 1
    Then
      B.Jan
    When
      Extract(Month From Sysdate) = 2
    Then
      B.Feb
    When
      Extract(Month From Sysdate) = 3
    Then
      B.Mar
    When
      Extract(Month From Sysdate) = 4
    Then
      B.Apr
    When
      Extract(Month From Sysdate) = 5
    Then
      B.May
    When
      Extract(Month From Sysdate) = 6
    Then
      B.June
    When
      Extract(Month From Sysdate) = 7
    Then
      B.July
    When
      Extract(Month From Sysdate) = 8
    Then
      B.Aug
    When
      Extract(Month From Sysdate) = 9
    Then
      B.Sept
    When
      Extract(Month From Sysdate) = 10
    Then
      B.Oct
    When
      Extract(Month From Sysdate) = 11
    Then
      B.Nov
    When
      Extract(Month From Sysdate) = 12
    Then
      B.Dec
    Else
      0
  End As Month_Quota,
  B.Region
From
  Kd_Sales_Data_Request A Left Join Srrepquota B
    On A.Salesman_Code = B.Repnumber
Where
  Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Charge_Type = 'Parts' And
  --Begin Change 03072017
  --Now excluding W and X orders so sales totals will match Daily Commissions per M. Nealon
  --A.Corporate_Form = 'DOMDIR'
  A.Corporate_Form = 'DOMDIR' And
((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null)
  --End Change 03072017
Group By
  A.Salesman_Code,
  Case
    When
      Extract(Month From Sysdate) = 1
    Then
      B.Jan
    When
      Extract(Month From Sysdate) = 2
    Then
      B.Feb
    When
      Extract(Month From Sysdate) = 3
    Then
      B.Mar
    When
      Extract(Month From Sysdate) = 4
    Then
      B.Apr
    When
      Extract(Month From Sysdate) = 5
    Then
      B.May
    When
      Extract(Month From Sysdate) = 6
    Then
      B.June
    When
      Extract(Month From Sysdate) = 7
    Then
      B.July
    When
      Extract(Month From Sysdate) = 8
    Then
      B.Aug
    When
      Extract(Month From Sysdate) = 9
    Then
      B.Sept
    When
      Extract(Month From Sysdate) = 10
    Then
      B.Oct
    When
      Extract(Month From Sysdate) = 11
    Then
      B.Nov
    When
      Extract(Month From Sysdate) = 12
    Then
      B.Dec
    Else
      0
  End,
  B.Region;

Create Or Replace View KD_Svq_MTD As
Select
  A.Salesman_Code,
  A.This_Month,
  A.This_Month_Implants,
  A.This_Month_Bio,
  --Begin Change 02142017.2
  --Grouping entry for new column.
  A.This_Month_Gross_Margin,
  --End Change 02142017.2
  Round((A.This_Month / ((A.Month_Quota / B.Total_Sales_Days) * B.Elapsed_Work_Days)) * 100,2) As Mtd_Quota_Pct,
  Round((A.This_Month / A.Month_Quota) * 100,2) As Month_Quota_Pct,
  A.Month_Quota - A.This_Month As Month_Remaining
From
  Kd_Svq_This_Month A,
  KD_Work_Days_This_Month B;

Create Or Replace View KD_Svq_This_Quarter As
Select
  A.Salesman_Code,
  Sum(A.Allamounts) As This_Quarter,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      B.QTR1
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      B.QTR2
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      B.QTR3
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      B.QTR4 
  End As Qtr_Quota,
  B.Region
From
  Kd_Sales_Data_Request A Left Join Srrepquota B
    On A.Salesman_Code = B.Repnumber
Where
  A.InvoiceQtr = Case
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
                 End And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Charge_Type = 'Parts' And
  --Begin Change 03072017
  --Now excluding W and X orders so sales totals will match Daily Commissions per M. Nealon
  --A.Corporate_Form = 'DOMDIR'
  A.Corporate_Form = 'DOMDIR' And
((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null)
  --End Change 03072017
Group By
  A.Salesman_Code,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      B.QTR1
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      B.QTR2
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      B.QTR3
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      B.Qtr4 
  End,
  B.Region;

Create Or Replace View KD_Svq_QTD As
Select
  A.Salesman_Code,
  A.This_Quarter,
  A.Qtr_Quota,
  --Begin Change 03012017.1
  --Reworked calculation to account for unevenly distributed quota (QTD by Month).
  --Round((A.This_Quarter / ((A.Qtr_Quota / B.Total_Sales_Days) * B.Elapsed_Work_Days)) * 100,2) As Qtd_Quota_Pct,
  Round((A.This_Quarter  /Sum(B.Daily_Quota)) * 100,2) As Qtd_Quota_Pct,
  --End Change 03012017.1
  Round((A.This_Quarter / A.Qtr_Quota) * 100,2) As Quarter_Quota_Pct,
  A.Qtr_Quota - A.This_Quarter As Quarter_Remaining
From
  Kd_Svq_This_Quarter A,
  --Begin Change 03012017.1
  --Using new table for QTD by Month formula.
  --Kd_Work_Days_This_Quarter B;
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
--End Change 03012017.1
  
Create Or Replace View KD_SVQ_This_Year As
Select
  A.Salesman_Code,
  Sum(A.Allamounts) As This_Year,
  B.Year As Year_Quota,
  B.Region
From
  Kd_Sales_Data_Request A Left Join Srrepquota B
    On A.Salesman_Code = B.Repnumber
Where
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  --Begin Change 03072017
  --Now excluding W and X orders so sales totals will match Daily Commissions per M. Nealon  
((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null) And
  --End Change 03072017
  Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
Group By
  A.Salesman_Code,
  B.Year,
  B.Region;

Create Or Replace View KD_SVQ_YTD As
Select
  A.Salesman_Code,
  A.Region,
  A.This_Year,
  --Begin Change 03012017.2
  --Reworked calculation to account for unevenly distributed quota (YTD by Month).
  --Round((A.This_Year / ((A.Year_Quota / B.Total_Sales_Days) * B.Elapsed_Work_Days)) * 100,2) As Ytd_Quota_Pct,
  Round((A.This_Year / Sum(B.Daily_Quota)) * 100,2) As Ytd_Quota_Pct,
  --End Change 03012017.2
  Round((A.This_Year / A.Year_Quota) * 100,2) As Year_Quota_Pct,
  A.Year_Quota - A.This_Year As Year_Remaining
From
  Kd_Svq_This_Year A,
  --Begin Change 03012017.2
  --Using new table for YTD by Month formula.
  --KD_Work_Days_This_Year B;
  Kd_Daily_Quota_By_Month B
Where
  A.Salesman_Code = B.Salesman_Code
Group By
  A.Salesman_Code,
  A.Region,
  A.This_Year,
  Round((A.This_Year / A.Year_Quota) * 100,2),
  A.Year_Quota - A.This_Year;
  --End Change 03012017.2

Create Or Replace View KD_SVQ As
Select
  A.Salesman_Code,
  E.Name,
  A.Region,
  D.Today,
  C.This_Month,
  C.This_Month_Implants,
  C.This_Month_Bio,
  --Begin Change 02142017.2
  --Added column from KD_SVQ_MTD per RMs.
  C.This_Month_Gross_Margin,
  --End Change 02142017.2
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

Create Or Replace View KD_SVQ_This_Year_Reg As
Select
  A.Region,
  Sum(A.This_Year) As This_Year,
  Sum(A.Year_Quota) As Year_Quota
From
  Kd_Svq_This_Year A
Group By
  A.Region;

Create Or Replace View KD_SVQ_This_Quarter_Reg As
Select
  A.Region,
  Sum(A.This_Quarter) As This_Quarter,
  Sum(A.Qtr_Quota) As Qtr_Quota
From
  Kd_Svq_This_Quarter A
Group By
  A.Region;

Create Or Replace View KD_SVQ_This_Month_Reg As
Select
  A.Region,
  Sum(A.This_Month) As This_Month,
  Sum(A.Month_Quota) As Month_Quota
From
  Kd_Svq_This_Month A
Group By
  A.Region;
  
Create Or Replace View Kd_Svq_Mtd_Reg As
Select
  A.Region,
  A.This_Month,
  Round((A.This_Month / ((A.Month_Quota / B.Total_Sales_Days) * B.Elapsed_Work_Days)) * 100,2) As Mtd_Quota_Pct_Reg,
  Round((A.This_Month / A.Month_Quota) * 100,2) As Month_Quota_Pct_Reg
From
  Kd_Svq_This_Month_Reg A,
  Kd_Work_Days_This_Month B;

Create Or Replace View Kd_Svq_Qtd_Reg As
Select
  A.Region,
  A.This_Quarter,
  --Begin Change 03012017.3
  --Reworked calculation to account for unevenly distributed quota (QTD by Month).
  --Round((A.This_Quarter / ((A.Qtr_Quota / B.Total_Sales_Days) * B.Elapsed_Work_Days)) * 100,2) As Qtd_Quota_Pct_Reg,
  Round((A.This_Quarter / Sum(B.Daily_Quota)) * 100,2) As Qtd_Quota_Pct_Reg,
  --End Change 03012017.3
  Round((A.This_Quarter / A.Qtr_Quota) * 100,2) As Quarter_Quota_Pct_Reg
From
  Kd_Svq_This_Quarter_Reg A,
  --Begin Change 03012017.3
  --Using new table for QTD by Month formula
  --Kd_Work_Days_This_Quarter B;
  Kd_Daily_Quota_By_Month B
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
  --End Change 03012017.3
  
Create Or Replace View Kd_Svq_Ytd_Reg As
Select
  A.Region,
  A.This_Year,
  --Begin Change 03012017.4
  --Reworked calculation to account for unevenly distributed quota (YTD by Month).
  --Round((A.This_Year / ((A.Year_Quota / B.Total_Sales_Days) * B.Elapsed_Work_Days)) * 100,2) As Ytd_Quota_Pct_Reg,
  Round((A.This_Year/Sum(B.Daily_Quota)) * 100,2) As YTD_Quota_PCT_Reg,
  Round((A.This_Year / A.Year_Quota) * 100,2) As Year_Quota_Pct_Reg
From
  Kd_Svq_This_Year_Reg A,
  --Begin Change 03012017.4
  --Using new table for YTD by Month Formula.
  --Kd_Work_Days_This_Year B;
  Kd_Daily_Quota_By_Month B
Where
  A.Region = B.Region
Group By
  A.Region,
  A.This_Year,
  Round((A.This_Year / A.Year_Quota) * 100,2);
  --End Change 03042017.4


Create Or Replace View Kd_Svq_Totals As
Select
  Sum(A.This_Year) As This_Year_Total,
  Sum(A.Year_Quota) As Year_Quota_Total,
  Sum(B.This_Quarter) As This_Quarter_Total,
  Sum(B.Qtr_Quota) As Quarter_Quota_Total,
  Sum(C.This_Month) As This_Month_Total,
  Sum(C.Month_Quota) As Month_Quota_Total
From
  Kd_Svq_This_Year_Reg A Left Join Kd_Svq_This_Quarter_Reg B
    On A.Region = B.Region
                     Left Join Kd_Svq_This_Month_Reg C
    On A.Region = C.Region;

--Begin Change 03012017.5 
--Total rewrite of view to reflect new calculation method
Create Or Replace View Kd_Svq_Totals_Td As
--Select
--  Round((A.This_Year_Total / ((A.Year_Quota_Total / D.Total_Sales_Days) * D.Elapsed_Work_Days)) * 100,2) As Ytd_Quota_Pct_Total,
--  Round((A.This_Year_Total / A.Year_Quota_Total) * 100,2) As Year_Quota_Pct_Total,
--  Round((A.This_Quarter_Total / ((A.Quarter_Quota_Total / C.Total_Sales_Days) * C.Elapsed_Work_Days)) * 100,2) As Qtd_Quota_Pct_Total,
--  Round((A.This_Quarter_Total / A.Quarter_Quota_Total) * 100,2) As Quarter_Quota_Pct_Total,
--  Round((A.This_Month_Total / ((A.Month_Quota_Total / B.Total_Sales_Days) * B.Elapsed_Work_Days)) *100,2) As Mtd_Quota_Pct_Total,
--  Round((A.This_Month_Total / A.Month_Quota_Total) * 100,2) As Month_Quota_Pct_Total
--From
--  Kd_Svq_Totals A,
--  Kd_Work_Days_This_Month B,
--  Kd_Work_Days_This_Quarter C,
--  Kd_Work_Days_This_Year D;
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
--End Change 03012017.5
  
Create or Replace View KD_SVQ_CY_MARGIN As
Select A.Salesman_Code,
  B.Region,
  Sum(A.Allamounts) As Total_Sales,
  Round(Sum(A.Invoiced_Qty * A.Cost),2) As Total_Cost,
  Round(Sum(Case
              When
                Extract(Month From A.Invoicedate) = Extract(Month From Sysdate)
              Then
                A.Invoiced_Qty * A.Cost
              End),2) As MTD_Cost,
  Round((Sum(Case
              When
                Extract(Month From A.Invoicedate) = Extract(Month From Sysdate)
              Then
                A.Allamounts
              End) - 
        Sum(Case
              When
                Extract(Month From A.Invoicedate) = Extract(Month From Sysdate)
              Then
                A.Invoiced_Qty * A.Cost
              End)) / 
          Sum(Case
              When
                Extract(Month From A.Invoicedate) = Extract(Month From Sysdate)
              Then
                A.Allamounts
              End) * 100,2) As MTD_Margin,
  Round((Sum(A.Allamounts) - Sum(A.Invoiced_Qty * A.Cost)) / Sum(A.Allamounts) * 100,2) As Cy_Margin
From 
  Kd_Sales_Data_Request A Left Join Srrepquota B
    On A.Salesman_Code   = B.Repnumber
Where 
  A.Charge_Type  = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
    --Begin Change 03072017
  --Now excluding W and X orders so sales totals will match Daily Commissions per M. Nealon
  --A.Corporate_Form = 'DOMDIR'
  --A.Order_No Not Like 'W%' And
  --A.Order_No Not Like 'X%' And
((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null) And
  --End Change 03072017
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
Group By A.Salesman_Code,
  B.Region;