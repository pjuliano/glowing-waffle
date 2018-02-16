Select
  A.Invoicedate,
  A.Order_No,
  A.Invoice_Id,
  A.Catalog_No,
  A.Catalog_Desc,
  A.Part_Product_Family,
  A.Part_Product_Code,
  A.second_Commodity,
  A.Invoiced_Qty,
  A.Allamounts / A.Invoiced_Qty As Unitprice,
  A.Allamounts As Total,
  A.Vat_Dom_Amount As Tax
From
  Kd_Sales_Data_Request A
Where
  A.Customer_No = '20130' And
  To_Char(A.InvoiceDate,'YYYY') = '2017' And
  A.Charge_Type = 'Parts'