Select
  Customer_No,
  Customer_Name,
  Catalog_No,
  Catalog_Desc,
  Sum(Invoiced_Qty) As Invoiced_Qty
From
  Kd_Sales_Data_Request
Where
  Customer_No In ('27485','27559','29642','29643','21906','27673') And
  Upper(Catalog_Desc) Like 'TRI%MAX%' And 
  Part_Product_Code = 'IMPL'
Group By
  Customer_No,
  Customer_Name,
  Catalog_No,
  Catalog_Desc
Order By
  Customer_No,
  Customer_Name,
  Catalog_No