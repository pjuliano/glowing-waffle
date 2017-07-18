Select
  A.Invoicedate,
  A.Order_No,
  A.Invoice_Id,
  A.Catalog_No,
  A.Catalog_Desc,
  A.Invoiced_Qty,
  A.Allamounts / A.Invoiced_Qty As Unitprice,
  A.Allamounts As Total,
  A.Vat_Dom_Amount As Tax
From
  Kd_Sales_Data_Request A
Where
  A.Customer_No = '17639' And
  A.Invoicedate >= To_Date('07/01/2016','MM/DD/YYYY') And
  A.Charge_Type = 'Parts'