Create or Replace View KD_WWSS_Yesterday As
Select
  A.Part_Product_Family,
  A.Corporate_Form,
  Sum(A.AllAmounts) As Yesterday
From
  Kd_Sales_Data_Request A
Where
  A.Invoicedate = Trunc(Sysdate-1)
Group By
  A.Part_Product_Family,
  A.Corporate_Form
Order By
  A.Part_Product_Family,
  A.Corporate_Form;
  
Create or Replace View KD_WWSS_Today As
Select
  A.Part_Product_Family,
  A.Corporate_Form,
  Sum(A.Allamounts) As Today
From
  Kd_Sales_Data_Request A
Where
  A.Invoicedate = Trunc(Sysdate)
Group By
  A.Part_Product_Family,
  A.Corporate_Form
Order By
  A.Part_Product_Family,
  A.Corporate_Form;
  
Create or Replace View KD_WWSS_This_Month As
Select
  A.Part_Product_Family,
  A.Corporate_Form,
  Sum(A.Allamounts) As This_Month,
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
      B.Jun
    When
      Extract(Month From Sysdate) = 7
    Then
      B.Jul
    When
      Extract(Month From Sysdate) = 8
    Then
      B.Aug
    When
      Extract(Month From Sysdate) = 9
    Then
      B.Sep
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
  End As Month_Quota
From
  Kd_Sales_Data_Request A Left Join Srfcstbyfam B
    On A.Part_Product_Family = B.Family And
    A.Corporate_Form = B.F1
Where
  Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
  Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
Group By
  A.Part_Product_Family,
  A.Corporate_Form,
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
      B.Jun
    When
      Extract(Month From Sysdate) = 7
    Then
      B.Jul
    When
      Extract(Month From Sysdate) = 8
    Then
      B.Aug
    When
      Extract(Month From Sysdate) = 9
    Then
      B.Sep
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
  End
Order By
  A.Part_Product_Family,
  A.Corporate_Form;
  
Create Or Replace View KD_WWSS_This_Quarter As
Select
  A.Part_Product_Family,
  A.Corporate_Form,
  Sum(A.Allamounts) As This_Qtr,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      B.Q1
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      B.Q2
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      B.Q3
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      B.Q4 
  End As QTR_Quota
From
  Kd_Sales_Data_Request A Left Join Srfcstbyfam B
    On A.Part_Product_Family = B.Family And
       A.Corporate_Form = B.F1
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
  Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
Group By
  A.Part_Product_Family,
  A.Corporate_Form,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      B.Q1
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      B.Q2
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      B.Q3
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      B.Q4 
  End  
Order By
  A.Part_Product_Family,
  A.Corporate_Form;
  
Create Or Replace View KD_WWSS_This_Year As
Select
  A.Part_Product_Family,
  A.Corporate_Form,
  Sum(A.Allamounts) As This_Year,
  B.Total As Total_Quota
From
  Kd_Sales_Data_Request A Left Join Srfcstbyfam B
    On A.Part_Product_Family = B.Family And
       A.Corporate_Form = B.F1
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
Group By
  A.Part_Product_Family,
  A.Corporate_Form,
  B.Total
Order By
  A.Part_Product_Family,
  A.Corporate_Form;
  
Create Or Replace View KD_WWSS_Last_Quarter As
Select
  A.Part_Product_Family,
  A.Corporate_Form,
  Sum(A.Allamounts) As Last_Qtr
From
  Kd_Sales_Data_Request A
Where
  A.InvoiceQtr = Case
                   When
                     Extract(Month From Sysdate) In (1,2,3)
                   Then
                     'QTR4'
                   When
                     Extract(Month From Sysdate) In (4,5,6)
                   Then
                     'QTR1'
                   When
                     Extract(Month From Sysdate) In (7,8,9)
                   Then
                     'QTR2'
                   When
                     Extract(Month From Sysdate) In (10,11,12)
                   Then
                     'QTR3' 
                 End And
  Extract(Year From A.Invoicedate) = Case
                                       When
                                         Extract(Month From Sysdate) In (1,2,3)
                                       Then
                                         Extract(Year From Sysdate) - 1
                                       Else
                                         Extract(Year From Sysdate)
                                       End
Group By
  A.Part_Product_Family,
  A.Corporate_Form
Order By
  A.Part_Product_Family,
  A.Corporate_Form;
  
Create or Replace View KD_WWSS_This_QTR_Last_Year As
Select
  A.Part_Product_Family,
  A.Corporate_Form,
  Sum(A.Allamounts) As This_Qtr_Last_Year,
  B.Total
From
  Kd_Sales_Data_Request A Left Join Srfcstbyfam B
    On A.Part_Product_Family = B.Family And
       A.Corporate_Form = B.F1
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
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
                 End  
Group By
  A.Part_Product_Family,
  A.Corporate_Form,
  B.Total
Order By
  A.Part_Product_Family,
  A.Corporate_Form;

Create or Replace View KD_WWSS_Last_Year As
Select
  A.Part_Product_Family,
  A.Corporate_Form,
  Sum(A.Allamounts) As Last_Year,
  B.Total
From
  Kd_Sales_Data_Request A Left Join Srfcstbyfam B
    On A.Part_Product_Family = B.Family And
       A.Corporate_Form = B.F1
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
  --Begin Change 03012017
  --Column on Report should be Year to Date not Year Total. 
  --A.Invoicedate <= Trunc(Sysdate)
  A.Invoicedate <= To_Date(To_Char(Extract(Month From Sysdate)) || '/' || To_Char(Extract(Day From Sysdate)) || '/' || To_Char(Extract(Year From Sysdate) - 1),'MM/DD/YYYY')
  --End Change 03012017
Group By
  A.Part_Product_Family,
  A.Corporate_Form,
  B.Total
Order By
  A.Part_Product_Family,
  A.Corporate_Form;

Create Or Replace View KD_WWSS As
Select
  A.Part_Product_Family,
  A.Corporate_Form,
  Case
    When
      A.Part_Product_Family In ('PRIMA','GNSIS','TRINX','RESTO','EXHEX','ZMAX','OCT','RENOV','STAGE','XP1','COMM','OTMED')
    Then
      'IMPLANT'
    When
      A.Part_Product_Family In ('BVINE','CONNX','CYTOP','DYNAB','DYNAG','DYNAC','DYNAM','SYNTH','MTF')
    Then
      'REGEN'
    When
      A.Part_Product_Family = 'EG'
    Then
      'EG'
    When
      A.Part_Product_Family = 'Freight'
    Then
      'FREIGHT'
    Else
      'OTHER'
  End As Code,
  B.Today,
  C.Yesterday,
  D.This_Month,
  D.Month_Quota,
  Case
    When
      D.Month_Quota Is Not Null And
      D.Month_Quota != 0
    Then
      Round((D.This_Month / D.Month_Quota) * 100,2) 
  End As Pct_To_Month,
  D.Month_Quota - D.This_Month As Left_Month,
  Case
    When
      H.Elapsed_Work_Days != 0
    Then
      Round(D.This_Month / H.Elapsed_Work_Days,2)
  End As Month_Avg_Sales_To_Date,
  Case
    When
      H.Total_Sales_Days - H.Elapsed_Work_Days != 0
    Then
      Round((D.Month_Quota - D.This_Month) / (H.Total_Sales_Days - H.Elapsed_Work_Days),2)
  End As Month_Req_Daily_Sales,
  E.This_Qtr,
  E.Qtr_Quota,
  Case 
    When
      E.Qtr_Quota Is Not Null And
      E.Qtr_Quota != 0
    Then
      Round((E.This_Qtr / E.Qtr_Quota) * 100,2)
  End As Pct_To_Qtr,
  E.Qtr_Quota - E.This_Qtr As Left_Qtr,
  Case
    When
      I.Elapsed_Work_Days != 0
    Then
      Round(E.This_Qtr / I.Elapsed_Work_Days,2)
  End As Qtr_Avg_Sales_To_Date,
  Case
    When
      I.Total_Sales_Days - I.Elapsed_Work_Days != 0
    Then
      Round((E.Qtr_Quota - E.This_Qtr) / (I.Total_Sales_Days - I.Elapsed_Work_Days),2) 
  End As Qtr_Req_Daily_Sales,
  Round(Case 
          When
            E.Qtr_Quota Is Not Null And
            E.Qtr_Quota != 0
          Then
            (E.This_Qtr / E.Qtr_Quota) * 100
        End /
        (I.Elapsed_Work_Days / I.Total_Sales_Days),2) As Qtr_Run_Rate,
  A.This_Year,
  A.Total_Quota,
  Case
    When
      A.Total_Quota Is Not Null And
      A.Total_Quota != 0
    Then
      Round((A.This_Year / A.Total_Quota) * 100,2) 
  End As Pct_To_Year,
  A.Total_Quota - This_Year As Left_Year,
  F.Last_Qtr,
  Case
    When
      F.Last_Qtr Is Not Null And
      F.Last_Qtr != 0
    Then
      Round((E.This_Qtr / F.Last_Qtr) * 100,2)
  End As Pct_Last_Qtr,
  K.This_Qtr_Last_Year,
  Case
    When
      K.This_Qtr_Last_Year != 0
    Then
      Round((E.This_Qtr / K.This_Qtr_Last_Year) * 100,2)
  End As PCT_This_Qtr_Last_Year,
  G.Last_Year As Last_YTD,
  Case
    When
      G.Last_Year Is Not Null And
      G.Last_Year != 0 
    Then
      Round((A.This_Year / G.Last_Year) * 100,2)
  End As Pct_Last_Ytd,
  H.Total_Sales_Days As Work_Days_This_Month,
  H.Holidays As Holidays_This_Month,
  H.Elapsed_Work_Days As Elapsed_Work_Days_This_Month,
  I.Total_Sales_Days As Work_Days_This_Qtr,
  I.Holidays As Holidays_This_Qtr,
  I.Elapsed_Work_Days As Elapsed_Work_Days_This_Qtr,
  J.Total_Sales_Days As Work_Days_This_Year,
  J.Holidays As Holidays_This_Year,
  J.Elapsed_Work_Days As Elapsed_Work_Days_This_Year
From
  Kd_Wwss_This_Year A Left Join Kd_Wwss_Today B
    On A.Part_Product_Family = B.Part_Product_Family And
       A.Corporate_Form = B.Corporate_Form 
                      Left Join Kd_Wwss_Yesterday C
    On A.Part_Product_Family = C.Part_Product_Family And
       A.Corporate_Form = C.Corporate_Form 
                      Left Join Kd_Wwss_This_Month D
    On A.Part_Product_Family = D.Part_Product_Family And
       A.Corporate_Form = D.Corporate_Form 
                      Left Join Kd_Wwss_This_Quarter E
    On A.Part_Product_Family = E.Part_Product_Family And
       A.Corporate_Form = E.Corporate_Form 
                      Left Join Kd_Wwss_Last_Quarter F
    On A.Part_Product_Family = F.Part_Product_Family And
       A.Corporate_Form = F.Corporate_Form 
                      Left Join Kd_Wwss_Last_Year G
    On A.Part_Product_Family = G.Part_Product_Family And
       A.Corporate_Form = G.Corporate_Form 
                      Left Join Kd_Wwss_This_Qtr_Last_Year K
    On A.Part_Product_Family = K.Part_Product_Family And
       A.Corporate_Form = K.Corporate_Form,
  Kd_Work_Days_This_Month H,
  Kd_Work_Days_This_Quarter I,
  Kd_Work_Days_This_Year J;
