Select
  A.Order_No,
  A.Invoice_Id,
  A.Invoicedate,
  A.Invoiced_Qty,
  A.AllAmounts/A.Invoiced_Qty As Unit_Price,
  A.Catalog_No,
  A.Catalog_Desc,
  A.AllAmounts As Total
From
  IFSAPP.Kd_Sales_Data_Request A
Where
  A.Charge_Type = 'Parts' And
  A.Customer_No = '&Customer_No' And
  A.InvoiceDate Between To_Date('&DateFrom','MM/DD/YYYY') And To_Date('&DateTo','MM/DD/YYYY')
Order By
  A.Invoicedate Asc,
  A.Catalog_No