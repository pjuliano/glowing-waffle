Create or Replace View Kd_National_Account_Summary As
Select
  A.Association_No,
  B.Name,
  Sum(Case When Extract(Month From A.Invoicedate) = 1 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Jan,
  Sum(Case When Extract(Month From A.Invoicedate) = 2 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Feb,
  Sum(Case When Extract(Month From A.Invoicedate) = 3 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Mar,
  Sum(Case When Extract(Month From A.Invoicedate) In (1,2,3) And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Q1,
  Sum(Case When Extract(Month From A.Invoicedate) = 4 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Apr,
  Sum(Case When Extract(Month From A.Invoicedate) = 5 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As May,
  Sum(Case When Extract(Month From A.Invoicedate) = 6 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Jun,
  Sum(Case When Extract(Month From A.Invoicedate) In (4,5,6) And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Q2,
  Sum(Case When Extract(Month From A.Invoicedate) = 7 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Jul,
  Sum(Case When Extract(Month From A.Invoicedate) = 8 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Aug,
  Sum(Case When Extract(Month From A.Invoicedate) = 9 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Sep,
  Sum(Case When Extract(Month From A.Invoicedate) In (7,8,9) And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Q3,
  Sum(Case When Extract(Month From A.Invoicedate) = 10 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Oct,
  Sum(Case When Extract(Month From A.Invoicedate) = 11 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Nov,
  Sum(Case When Extract(Month From A.Invoicedate) = 12 And 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) 
           Then A.Allamounts Else 0 End) As Dec,
  Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) 
           Then A.Allamounts Else 0 End) As Q4,
  Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts Else 0 End) As Total,
    Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)-1 
           Then A.Allamounts Else 0 End) As Ly_Total
From
  Kd_Sales_Data_Request A Left Join Customer_Info B
    On A.Association_No = B.Customer_ID
Where
  A.Association_No Like 'N%' And
  A.Association_No Not In ('UNIV','NIHI001','N1001','N1012','N9153') And
  A.Association_No Not Like '%SI%' And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  Extract(Year From A.InvoiceDate) >= Extract(Year From Sysdate)-1
Group By
  A.Association_No,
  B.Name
Order By
  Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts Else 0 End) Desc