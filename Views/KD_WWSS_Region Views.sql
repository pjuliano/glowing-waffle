Create or Replace View KD_WWSS_Yesterday_Region As
Select
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End As Region_Code,
  Sum(A.AllAmounts) As Yesterday
From
  Kd_Sales_Data_Request A
Where
  A.Invoicedate = Trunc(Sysdate-1)
Group By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End
Order By
  A.Corporate_Form,
    Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End;
  
Create or Replace View KD_WWSS_Today_Region As
Select
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End As Region_Code,
  Sum(A.Allamounts) As Today
From
  Kd_Sales_Data_Request A
Where
  A.Invoicedate = Trunc(Sysdate)
Group By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End
Order By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End;
  
Create or Replace View KD_WWSS_This_Month_Region As
With Us_Quota_Region As (
  Select
    A.Region,
    Sum(A.Jan) As Jan,
    Sum(A.Feb) As Feb,
    Sum(A.Mar) As Mar,
    Sum(A.Apr) As Apr,
    Sum(A.May) As May,
    Sum(A.June) As Jun,
    Sum(A.July) As Jul,
    Sum(A.Aug) As Aug,
    Sum(A.Sept) As Sep,
    Sum(A.Oct) As Oct,
    Sum(A.Nov) As Nov,
    Sum(A.Dec) As Dec
  From
    Srrepquota A
  Group By
    A.Region)
Select
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End As Region_Code,
  Sum(A.Allamounts) As This_Month,
  Case
    When
      A.Region_Code = C.Region And
      A.Corporate_Form != 'Freight'
    Then   
      Case
        When
          Extract(Month From Sysdate) = 1
        Then
          C.Jan
        When
          Extract(Month From Sysdate) = 2
        Then
          C.Feb
        When
          Extract(Month From Sysdate) = 3
        Then
          C.Mar
        When
          Extract(Month From Sysdate) = 4
        Then
          C.Apr
        When
          Extract(Month From Sysdate) = 5
        Then
          C.May
        When
          Extract(Month From Sysdate) = 6
        Then
          C.Jun
        When
          Extract(Month From Sysdate) = 7
        Then
          C.Jul
        When
          Extract(Month From Sysdate) = 8
        Then
          C.Aug
        When
          Extract(Month From Sysdate) = 9
        Then
          C.Sep
        When
          Extract(Month From Sysdate) = 10
        Then
          C.Oct
        When
          Extract(Month From Sysdate) = 11
        Then
          C.Nov
        When
          Extract(Month From Sysdate) = 12
        Then
          C.Dec
        Else
          0
      End
    Else
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
  End As Month_Quota
From
  Kd_Sales_Data_Request A Left Join SrfcstNew B
    On A.Corporate_Form = B.F1
                          Left Join US_Quota_Region C
    On A.Region_Code = C.Region
Where
  Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
  Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
Group By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End,
  Case
    When
      A.Region_Code = C.Region And
      A.Corporate_Form != 'Freight'
    Then   
      Case
        When
          Extract(Month From Sysdate) = 1
        Then
          C.Jan
        When
          Extract(Month From Sysdate) = 2
        Then
          C.Feb
        When
          Extract(Month From Sysdate) = 3
        Then
          C.Mar
        When
          Extract(Month From Sysdate) = 4
        Then
          C.Apr
        When
          Extract(Month From Sysdate) = 5
        Then
          C.May
        When
          Extract(Month From Sysdate) = 6
        Then
          C.Jun
        When
          Extract(Month From Sysdate) = 7
        Then
          C.Jul
        When
          Extract(Month From Sysdate) = 8
        Then
          C.Aug
        When
          Extract(Month From Sysdate) = 9
        Then
          C.Sep
        When
          Extract(Month From Sysdate) = 10
        Then
          C.Oct
        When
          Extract(Month From Sysdate) = 11
        Then
          C.Nov
        When
          Extract(Month From Sysdate) = 12
        Then
          C.Dec
        Else
          0
      End
    Else
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
  End
Order By
  A.Corporate_Form,
    Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End;
  
Create Or Replace View Kd_Wwss_This_Quarter_Region As
With Us_Quota_Region As (
  Select
    A.Region,
    Sum(A.Qtr1) As Qtr1,
    Sum(A.Qtr2) As Qtr2,
    Sum(A.Qtr3) As Qtr3,
    Sum(A.Qtr4) As Qtr4
  From
    Srrepquota A
  Group By
    A.Region)
Select
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End As Region_Code,
  Sum(A.Allamounts) As This_Qtr,
  Case
    When 
      A.Region_Code = C.Region And
      A.Corporate_Form != 'Freight'
    Then 
      Case
        When
          Extract(Month From Sysdate) In (1,2,3)
        Then
          C.QTR1
        When
          Extract(Month From Sysdate) In (4,5,6)
        Then
          C.Qtr2
        When
          Extract(Month From Sysdate) In (7,8,9)
        Then
          C.Qtr3
        When
          Extract(Month From Sysdate) In (10,11,12)
        Then
          C.Qtr4
      End
    Else
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
  End As QTR_Quota
From
  Kd_Sales_Data_Request A Left Join SrfcstNew B
    On A.Corporate_Form = B.F1
                          Left Join US_Quota_Region C
    On A.Region_Code = C.Region
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
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End,
  Case
    When 
      A.Region_Code = C.Region And
      A.Corporate_Form != 'Freight'
    Then
      Case
        When
          Extract(Month From Sysdate) In (1,2,3)
        Then
          C.QTR1
        When
          Extract(Month From Sysdate) In (4,5,6)
        Then
          C.Qtr2
        When
          Extract(Month From Sysdate) In (7,8,9)
        Then
          C.Qtr3
        When
          Extract(Month From Sysdate) In (10,11,12)
        Then
          C.Qtr4
      End
    Else
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
  End
Order By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End;
  
Create Or Replace View Kd_Wwss_This_Year_Region As
With Us_Quota_Region As (
  Select
    A.Region,
    Sum(A.Year) As Year
  From
    Srrepquota A
  Group By
    A.Region)
Select
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End As Region_Code,
  Sum(A.Allamounts) As This_Year,
  Case
    When 
      A.Region_Code = C.Region And
      A.Corporate_Form != 'Freight'
    Then
      C.Year
    Else
      B.Total 
  End As Total_Quota
From
  Kd_Sales_Data_Request A Left Join SrfcstNew B
    On A.Corporate_Form = B.F1
                          Left Join US_Quota_Region C
    On A.Region_Code = C.Region
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
Group By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End,
  Case
    When 
      A.Region_Code = C.Region And
      A.Corporate_Form != 'Freight'
    Then
      C.Year
    Else
      B.Total 
  End
Order By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End;
  
Create Or Replace View KD_WWSS_Last_Quarter_Region As
Select
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End As Region_Code,
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
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End
Order By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End;
  
Create Or Replace View KD_WWSS_This_Month_Last_Yr_Reg As
Select
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End As Region_Code,
  Sum(A.Allamounts) As This_Month_Last_Year
From
  Kd_Sales_Data_Request A Left Join Srfcstnew B
    On A.Corporate_Form = B.F1
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
  Extract(Month From A.InvoiceDate) = Extract(Month From Sysdate) 
Group By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End
Order By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End;
 
Create or Replace View KD_WWSS_This_QTR_Last_Yr_Reg As
Select
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End As Region_Code,
  Sum(A.Allamounts) As This_Qtr_Last_Year
From
  Kd_Sales_Data_Request A Left Join Srfcstnew B
    On A.Corporate_Form = B.F1
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
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End
Order By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End;

Create or Replace View KD_WWSS_Last_Year_Region As
Select
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End As Region_Code,
  Sum(A.Allamounts) As Last_Year
From
  Kd_Sales_Data_Request A Left Join SrfcstNew B
    On A.Corporate_Form = B.F1
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
  A.InvoiceDate <= Trunc(Sysdate)
Group By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End
Order By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End;

Create Or Replace View KD_WWSS_Region As
Select
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End As Region_Code,
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
  L.This_Month_Last_Year,
  Case
    When
      L.This_Month_Last_Year != 0
    Then
      Round((D.This_Month / L.This_Month_Last_Year) * 100,2)
  End As PCT_This_Month_Last_Yr,
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
  Kd_Wwss_This_Year_Region A Left Join Kd_Wwss_Today_Region B
    On A.Corporate_Form = B.Corporate_Form And
       A.Region_Code = B.Region_Code
                      Left Join Kd_Wwss_Yesterday_Region C
    On A.Corporate_Form = C.Corporate_Form And
       A.Region_Code = C.Region_Code
                      Left Join Kd_Wwss_This_Month_Region D
    On A.Corporate_Form = D.Corporate_Form And
       A.Region_Code = D.Region_Code
                      Left Join Kd_Wwss_This_Quarter_Region E
    On A.Corporate_Form = E.Corporate_Form And
       A.Region_Code = E.Region_Code
                      Left Join Kd_Wwss_Last_Quarter_Region F
    On A.Corporate_Form = F.Corporate_Form And
       A.Region_Code = F.Region_Code
                      Left Join Kd_Wwss_Last_Year_Region G
    On A.Corporate_Form = G.Corporate_Form And
       A.Region_Code = G.Region_Code
                      Left Join Kd_Wwss_This_Qtr_Last_Yr_Reg K
    On A.Corporate_Form = K.Corporate_Form And
       A.Region_Code = K.Region_Code
                      Left Join Kd_Wwss_This_Month_Last_Yr_Reg L
    On A.Corporate_Form = L.Corporate_Form And
       A.Region_Code = L.Region_Code,
  Kd_Work_Days_This_Month H,
  Kd_Work_Days_This_Quarter I,
  Kd_Work_Days_This_Year J
Group By
  A.Corporate_Form,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      A.Corporate_Form
    Else
      A.Region_Code
  End,
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
  End,
  D.Month_Quota - D.This_Month,
  Case
    When
      H.Elapsed_Work_Days != 0
    Then
      Round(D.This_Month / H.Elapsed_Work_Days,2)
  End,
  Case
    When
      H.Total_Sales_Days - H.Elapsed_Work_Days != 0
    Then
      Round((D.Month_Quota - D.This_Month) / (H.Total_Sales_Days - H.Elapsed_Work_Days),2)
  End,
  L.This_Month_Last_Year,
  Case
    When
      L.This_Month_Last_Year != 0
    Then
      Round((D.This_Month / L.This_Month_Last_Year) * 100,2)
  End,
  E.This_Qtr,
  E.Qtr_Quota,
  Case 
    When
      E.Qtr_Quota Is Not Null And
      E.Qtr_Quota != 0
    Then
      Round((E.This_Qtr / E.Qtr_Quota) * 100,2)
  End,
  E.Qtr_Quota - E.This_Qtr,
  Case
    When
      I.Elapsed_Work_Days != 0
    Then
      Round(E.This_Qtr / I.Elapsed_Work_Days,2)
  End,
  Case
    When
      I.Total_Sales_Days - I.Elapsed_Work_Days != 0
    Then
      Round((E.Qtr_Quota - E.This_Qtr) / (I.Total_Sales_Days - I.Elapsed_Work_Days),2) 
  End,
  Round(Case 
          When
            E.Qtr_Quota Is Not Null And
            E.Qtr_Quota != 0
          Then
            (E.This_Qtr / E.Qtr_Quota) * 100
        End /
        (I.Elapsed_Work_Days / I.Total_Sales_Days),2),
  A.This_Year,
  A.Total_Quota,
  Case
    When
      A.Total_Quota Is Not Null And
      A.Total_Quota != 0
    Then
      Round((A.This_Year / A.Total_Quota) * 100,2) 
  End,
  A.Total_Quota - This_Year,
  F.Last_Qtr,
  Case
    When
      F.Last_Qtr Is Not Null And
      F.Last_Qtr != 0
    Then
      Round((E.This_Qtr / F.Last_Qtr) * 100,2)
  End,
  K.This_Qtr_Last_Year,
  Case
    When
      K.This_Qtr_Last_Year != 0
    Then
      Round((E.This_Qtr / K.This_Qtr_Last_Year) * 100,2)
  End,
  G.Last_Year,
  Case
    When
      G.Last_Year Is Not Null And
      G.Last_Year != 0 
    Then
      Round((A.This_Year / G.Last_Year) * 100,2)
  End,
  H.Total_Sales_Days,
  H.Holidays,
  H.Elapsed_Work_Days,
  I.Total_Sales_Days,
  I.Holidays,
  I.Elapsed_Work_Days,
  J.Total_Sales_Days,
  J.Holidays,
  J.Elapsed_Work_Days