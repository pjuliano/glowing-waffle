Select 
  A.Customer_No,
  A.Customer_Name,
  A.Order_No,
  A.Line,
  A.Catalog_No,
  A.Catalog_Desc,
  A.Invoiced_Qty,
  A.Product_Type,
  A.AllAmounts As Total
From
  Kd_Na_Commission_Detail A
Where
  A.Salesman_Code = '101' And
  Extract(Year From A.Invoicedate) = 2017 And
  A.Qtr = 'QTR1'
Order By
  A.Invoicedate,
  A.Order_No,
  A.Line