Select
  A.Customer_Name,
  A.Invoicedate,
  A.Catalog_No,
  A.Catalog_Desc,
  A.Invoiced_Qty,
  A.AllAmounts as Total_Price
From
  Kd_Sales_Data_Request A
Where
  A.Association_No = 'N1035' And
  Extract(Year From A.Invoicedate) = 2016 And
  A.Charge_Type = 'Parts'
Order By
  A.Customer_Name,
  A.Invoicedate