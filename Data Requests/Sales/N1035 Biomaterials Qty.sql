Select
  --A.Customer_Name,
  A.Catalog_No,
  A.Catalog_Desc,
  Sum(A.Invoiced_Qty) As Qty
From
  Kd_Sales_Data_Request A
Where
  A.Association_No = 'N1035' And
  A.Part_Product_Code = 'REGEN' And
  A.InvoiceDate >= To_Date('01/01/2016','MM/DD/YYYY')
Group By
  --A.Customer_Name,
  A.Catalog_No,
  A.Catalog_Desc
Order By
  --A.Customer_Name,
  Sum(A.Invoiced_Qty) Desc