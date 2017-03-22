Select
  A.Catalog_No,
  A.Catalog_Desc,
  Sum(A.Invoiced_Qty) As Qty,
  Sum(A.AllAmounts) As Sales
From
  Kd_Sales_Data_Request A
Where
  A.Association_No = 'N1035' And
  Extract(Year From A.Invoicedate) = 2016 And
  A.Part_Product_Code = 'IMPL'
Group By
  A.Catalog_No,
  A.Catalog_Desc
Order By
  A.Catalog_No