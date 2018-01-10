Create or Replace View KD_CY_Sales As
Select
  Customer_No,
  Sum(Allamounts) As Cysales,
  Sum(Case When Part_Product_Code = 'IMPL' Then Allamounts
           Else 0
      End) As Cyimpl,
  Sum(Case When Part_Product_Code = 'REGEN' Then Allamounts
           Else 0
      End) As CYBIO
From
  Kd_Sales_Data_Request
Where
  Extract(YEar From InvoiceDate) = Extract(YEar From Sysdate)
Group By
  Customer_No;