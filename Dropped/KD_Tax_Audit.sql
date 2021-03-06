Create Or Replace View KD_Tax_Audit As
Select
  A.Site,
  A.Invoice_Id,
  A.Item_Id,
  A.Invoicedate,
  A.Invoiced_Qty,
  A.Sale_Unit_Price,
  A.Discount,
  A.Net_Curr_Amount,
  A.Gross_Curr_Amount,
  A.Catalog_Desc,
  A.Customer_Name,
  A.Order_No,
  A.Customer_No,
  A.Cust_Grp,
  A.Catalog_No,
  A.Authorize_Code,
  A.Salesman_Code,
  A.Commission_Receiver,
  A.District_Code,
  A.Region_Code,
  A.Createdate,
  A.Part_Product_Code,
  A.Part_Product_Family,
  A.Second_Commodity,
  A.Invoicemonth,
  A.Invoiceqtr,
  A.Invoiceqtryr,
  A.Invoicemthyr,
  A.Group_Id,
  A.Type_Designation,
  A.Customer_No_Pay,
  A.Corporate_Form,
  A.Fixedamounts,
  A.Allamounts,
  A.Localamount,
  A.Truelocalamt,
  A.Vat_Dom_Amount,
  A.Vat_Code,
  A.Cost,
  A.Charge_Type,
  A.Source,
  A.Market_Code,
  A.Association_No,
  A.Vat_Curr_Amount,
  A.Pay_Term_Description,
  A.Kdreference,
  A.Customerref,
  A.Deliverydate,
  A.Ship_Via,
  A.Delivery_Identity,
  A.Delivery_Address_Id,
  A.Invoice_Address_Id,
  A.Invoiceadd1,
  A.Invoiceadd2,
  A.Invoicecity,
  A.InvoiceState,
  A.Invoicezip,
  A.Invoicecountry,
  A.InvoiceCounty,
  A.Delivadd1,
  A.Delivadd2,
  A.Delivcity,
  A.Delivstate,
  A.Delivzip,
  A.Delivcounty,
  A.Delivcountry,
  Sum(B.Tax_Amount) * -1 As Total_Tax_Amount
From
  Kd_Sales_Data_Request A Left Join Tax_Ledger_Item_Qry B
    On A.Invoice_Id = B.Series_Id || B.Invoice_No And
       A.Item_Id = B.Item_Id
Group By
  A.Site,
  A.Invoice_Id,
  A.Item_Id,
  A.Invoicedate,
  A.Invoiced_Qty,
  A.Sale_Unit_Price,
  A.Discount,
  A.Net_Curr_Amount,
  A.Gross_Curr_Amount,
  A.Catalog_Desc,
  A.Customer_Name,
  A.Order_No,
  A.Customer_No,
  A.Cust_Grp,
  A.Catalog_No,
  A.Authorize_Code,
  A.Salesman_Code,
  A.Commission_Receiver,
  A.District_Code,
  A.Region_Code,
  A.Createdate,
  A.Part_Product_Code,
  A.Part_Product_Family,
  A.Second_Commodity,
  A.Invoicemonth,
  A.Invoiceqtr,
  A.Invoiceqtryr,
  A.Invoicemthyr,
  A.Group_Id,
  A.Type_Designation,
  A.Customer_No_Pay,
  A.Corporate_Form,
  A.Fixedamounts,
  A.Allamounts,
  A.Localamount,
  A.Truelocalamt,
  A.Vat_Dom_Amount,
  A.Vat_Code,
  A.Cost,
  A.Charge_Type,
  A.Source,
  A.Market_Code,
  A.Association_No,
  A.Vat_Curr_Amount,
  A.Pay_Term_Description,
  A.Kdreference,
  A.Customerref,
  A.Deliverydate,
  A.Ship_Via,
  A.Delivery_Identity,
  A.Delivery_Address_Id,
  A.Invoice_Address_Id,
  A.Invoiceadd1,
  A.Invoiceadd2,
  A.Invoicecity,
  A.InvoiceState,
  A.Invoicezip,
  A.Invoicecountry,
  A.InvoiceCounty,
  A.Delivadd1,
  A.Delivadd2,
  A.Delivcity,
  A.Delivstate,
  A.Delivzip,
  A.Delivcounty,
  A.Delivcountry