Create or Replace View KD_CY_Sales As
Select
  Customer_No,
  Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate) Then Allamounts Else 0 End) As Cysales,
  Sum(Case When Part_Product_Code = 'IMPL' And
                Extract(Year From InvoiceDate) = Extract(Year From Sysdate) Then Allamounts Else 0 End) As Cyimpl,
  Sum(Case When Part_Product_Code = 'REGEN' And
                Extract(Year From InvoiceDate) = Extract(Year From Sysdate) Then Allamounts Else 0 End) As CYBIO,
  Sum(Case When InvoiceDate >= Trunc(Sysdate)-365 Then AllAmounts Else 0 End) As Rolling365
From
  Kd_Sales_Data_Request
Where
  Extract(Year From InvoiceDate) >= Extract(Year From Sysdate)-1
Group By
  Customer_No;