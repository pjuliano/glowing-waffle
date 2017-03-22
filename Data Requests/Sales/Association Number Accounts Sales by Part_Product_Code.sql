Select
  A.Association_No,
  A.Customer_No,
  A.Customer_Name,
  A.Invoicemthyr,
  Sum(Case
        When
          A.Part_Product_Code = 'REGEN'
        Then
          A.Allamounts
        Else
          0
      End) As Bio,
  Sum(Case
        When
          A.Part_Product_Code != 'REGEN'
        Then
          A.AllAmounts
        Else
          0
      End) As Impl
From
  Kd_Sales_Data_Request A
Where
  A.Association_No Is Not Null And
  Extract(Year From A.Invoicedate) In ('2015','2016') And
  A.Corporate_Form = 'DOMDIR' And
  A.Charge_Type = 'Parts'
Group By
  A.Association_No,
  A.Customer_No,
  A.Customer_Name,
  A.Invoicemthyr;