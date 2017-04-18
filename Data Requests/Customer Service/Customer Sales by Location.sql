Select
  A.Delivadd1 As Location,
  A.Invoicedate As Invoice_Date,
  A.Catalog_No,
  A.Catalog_Desc,
  A.Invoiced_Qty,
  A.AllAmounts As Total
From
  Kd_Sales_Data_Request A
Where
  A.Customer_No = 'A27468' And
  A.Invoicedate >= To_Date('01/01/2015','MM/DD/YYYY')