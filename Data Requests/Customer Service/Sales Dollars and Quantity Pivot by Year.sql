Select
  *
From (
  Select
    Extract(Year From A.InvoiceDate) As Year,
    A.Catalog_No,
    A.Catalog_Desc,
    A.Invoiced_Qty,
    A.AllAmounts
  From
    Kd_Sales_Data_Request A
  Where
    A.Charge_Type = 'Parts' And
    A.Customer_No = 'A18173')
Pivot 
  (Sum(Invoiced_Qty) As Qty, Sum(AllAmounts) As Sales For Year In (2010,2011,2012,2013,2014,2015,2016,2017))