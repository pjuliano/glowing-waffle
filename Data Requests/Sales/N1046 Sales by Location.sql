Select
  A.Customer_No,
  A.Customer_Name,
  Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)-1
           Then A.Allamounts
           Else 0
      End) As Prior_Year,
  Sum(Case When A.Invoiceqtryr = 'QTR1/' || Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Q1,
  Sum(Case When A.Invoiceqtryr = 'QTR2/' || Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Q2,
    Sum(Case When A.Invoiceqtryr = 'QTR3/' || Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Q3,
    Sum(Case When A.Invoiceqtryr = 'QTR4/' || Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Q4
From
  KD_Sales_Data_Request A
Where
  A.Association_No = 'N1046' And
  A.Charge_Type = 'Parts'
Group By
  A.Customer_No,
  A.Customer_Name