--Create Or Replace View KD_Unmatched_Records AS
Select
  *
From
  Kd_Sales_Data_Test A
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  Not Exists(Select
               Null
             From
               Kd_Sales_Data_Request B
             Where
               ((A.Site = B.Site)                                 Or (A.Site Is Null And B.Site Is Null)) And
               ((A.Invoice_Id = B.Invoice_Id)                     Or (A.Invoice_Id Is Null And B.Invoice_Id Is Null)) And
               ((A.Item_Id = B.Item_Id)                           Or (A.Item_Id Is Null And B.Item_Id Is Null)) And
               ((A.Invoicedate = B.Invoicedate)                   Or (A.Invoicedate Is Null And B.Invoicedate Is Null)) And
               ((A.Invoiced_Qty = B.Invoiced_Qty)                 Or (A.Invoiced_Qty Is Null And B.Invoiced_Qty Is Null)) And
               ((A.Discount = B.Discount)                         Or (A.Discount Is Null And B.Discount Is Null)) And
               ((A.Gross_Curr_Amount = B.Gross_Curr_Amount)       Or (A.Gross_Curr_Amount Is Null And B.Gross_Curr_Amount Is Null)) And
               ((A.Catalog_Desc = B.Catalog_Desc)                 Or (A.Catalog_Desc Is Null And B.Catalog_Desc Is Null)) And
               ((A.Customer_Name = B.Customer_Name)               Or (A.Customer_Name Is Null And B.Customer_Name Is Null)) And
               ((A.Order_No = B.Order_No)                         Or (A.Order_No Is Null And B.Order_No Is Null)) And
               ((A.Customer_No = B.Customer_No)                   Or (A.Customer_No Is Null And B.Customer_No Is Null)) And
               ((A.Cust_Grp = B.Cust_Grp)                         Or (A.Cust_Grp Is Null And B.Cust_Grp Is Null) ) And
               ((A.Catalog_No = B.Catalog_No)                     Or (A.Catalog_No Is Null And B.Catalog_No Is Null)) And
               ((A.Authorize_Code = B.Authorize_Code)             Or (A.Authorize_Code Is Null And B.Authorize_Code Is Null)) And
               ((A.Salesman_Code = B.Salesman_Code)               Or (A.Salesman_Code Is Null And B.Salesman_Code Is Null)) And
               ((A.Commission_Receiver = B.Commission_Receiver)   Or (A.Commission_Receiver Is Null And B.Commission_Receiver Is Null)) And
               ((A.District_Code = B.District_Code)               Or (A.District_Code Is Null And B.District_Code Is Null)) And
               ((A.Region_Code = B.Region_Code)                   Or (A.Region_Code Is Null And B.Region_Code Is Null)) And
               ((A.Createdate = B.Createdate)                     Or (A.Createdate Is Null And B.Createdate Is Null)) And
               ((A.Part_Product_Code = B.Part_Product_Code)       Or (A.Part_Product_Code Is Null And B.Part_Product_Code Is Null)) And
               ((A.Part_Product_Family = B.Part_Product_Family)   Or (A.Part_Product_Family Is Null And B.Part_Product_Family Is Null)) And
               ((A.Second_Commodity = B.Second_Commodity)         Or (A.Second_Commodity Is Null And B.Second_Commodity Is Null)) And
               ((A.Invoicemonth = B.Invoicemonth)                 Or (A.Invoicemonth Is Null And B.Invoicemonth Is Null)) And 
               ((A.Invoiceqtr = B.Invoiceqtr)                     Or (A.Invoiceqtr Is Null And B.Invoiceqtr Is Null)) And
               ((A.Invoiceqtryr = B.Invoiceqtryr)                 Or (A.Invoiceqtryr Is Null And B.Invoiceqtryr Is Null)) And
               ((A.Invoicemthyr = B.Invoicemthyr)                 Or (A.Invoicemthyr Is Null And B.Invoicemthyr Is Null)) And
               ((A.Group_Id = B.Group_Id)                         Or (A.Group_Id Is Null And B.Group_Id Is Null)) And
               ((A.Customer_No_Pay = B.Customer_No_Pay)           Or (A.Customer_No_Pay Is Null And B.Customer_No_Pay Is Null)) And
               ((A.Fixedamounts = B.Fixedamounts)                 Or (A.FixedAmounts Is Null And B.Fixedamounts Is Null)) And 
               ((A.Allamounts = B.Allamounts)                     Or (A.Allamounts Is Null And B.Allamounts Is Null)) And
               ((A.Localamount = B.Localamount)                   Or (A.Localamount Is Null And B.Localamount Is Null)) And
               ((A.Truelocalamt = B.Truelocalamt)                 Or (A.Truelocalamt Is Null And B.Truelocalamt Is Null)) And 
               ((A.Vat_Dom_Amount = B.Vat_Dom_Amount)             Or (A.Vat_Dom_Amount Is Null And B.Vat_Dom_Amount Is Null)) And 
               ((A.Cost = B.Cost)                                 Or (A.Cost Is Null And B.Cost Is Null)) And
               ((A.Charge_Type = B.Charge_Type)                   Or (A.Charge_Type Is Null And B.Charge_Type Is Null)) And
               ((A.Source = B.Source)                             Or (A.Source Is Null And B.Source Is Null)) And
               ((A.Market_Code = B.Market_Code)                   Or (A.Market_Code Is Null And B.Market_Code Is Null)) And
               ((A.Association_No = B.Association_No)             Or (A.Association_No Is Null And B.Association_No Is Null)) And
               ((A.Vat_Curr_Amount = B.Vat_Curr_Amount)           Or (A.Vat_Curr_Amount Is Null And B.Vat_Curr_Amount Is Null)) And
               ((A.Pay_Term_Description = B.Pay_Term_Description) Or (A.Pay_Term_Description Is Null And B.Pay_Term_Description Is Null)) And
               ((A.Kdreference = B.Kdreference)                   Or (A.Kdreference Is Null And B.Kdreference Is Null)) And
               ((A.Customerref = B.Customerref)                   Or (A.Customerref Is Null And B.Customerref Is Null)) And
               ((A.Deliverydate = B.Deliverydate)                 Or (A.Deliverydate Is Null And B.Deliverydate Is Null)) And
               ((A.Ship_Via = B.Ship_Via)                         Or (A.Ship_Via Is Null And B.Ship_Via Is Null)) And
               ((A.Delivery_Identity = B.Delivery_Identity)       Or (A.Delivery_Identity Is Null And B.Delivery_Identity Is Null)) And
               ((A.Identity = B.Identity)                         Or (A.Identity Is Null And B.Identity Is Null)) And
               ((A.Delivery_Address_Id = B.Delivery_Address_Id)   Or (A.Delivery_Address_Id Is Null And B.Delivery_Address_Id Is Null)) And
               ((A.Invoice_Address_Id = B.Invoice_Address_Id)     Or (A.Invoice_Address_Id Is Null And B.Invoice_Address_Id Is Null)) And
               ((A.Currency = B.Currency)                         Or (A.Currency Is Null And B.Currency Is Null)) And
               ((A.Rma_No = B.Rma_No)                             Or (A.Rma_No Is Null And B.Rma_No Is Null)) And
               ((A.Invoiceadd1 = B.Invoiceadd1)                   Or (A.Invoiceadd1 Is Null And B.Invoiceadd1 Is Null)) And
               ((A.Invoiceadd2 = B.Invoiceadd2)                   Or (A.Invoiceadd2 Is Null And B.Invoiceadd2 Is Null)) And
               ((A.Invoicecity = B.Invoicecity)                   Or (A.Invoicecity Is Null And B.Invoicecity Is Null)) And
               ((A.Invoicestate = B.Invoicestate)                 Or (A.Invoicestate Is Null And B.Invoicestate Is Null)) And
               ((A.Invoicezip = B.Invoicezip)                     Or (A.Invoicezip Is Null And B.Invoicezip Is Null)) And
               ((A.Invoicecountry = B.Invoicecountry)             Or (A.Invoicecountry Is Null And B.Invoicecountry Is Null)) And
               ((A.Invoicecounty = B.Invoicecounty)               Or (A.Invoicecounty Is Null And B.Invoicecounty Is Null)) And 
               ((A.Delivadd1 = B.Delivadd1)                       Or (A.Delivadd1 Is Null And B.Delivadd1 Is Null)) And
               ((A.Delivadd2 = B.Delivadd2)                       Or (A.Delivadd2 Is Null And B.Delivadd2 Is Null)) And
               ((A.Delivcity = B.Delivcity)                       Or (A.Delivcity Is Null And B.Delivcity Is Null)) And
               ((A.Delivstate = B.Delivstate)                     Or (A.Delivstate Is Null And B.Delivstate Is Null)) And
               ((A.Delivzip = B.Delivzip)                         Or (A.Delivzip Is Null And B.Delivzip Is Null)) And
               ((A.Delivcountry = B.Delivcountry)                 Or (A.Delivcountry Is Null And B.Delivcountry Is Null)) And
               ((A.Delivcounty = B.Delivcounty)                   Or (A.Delivcounty Is Null And B.Delivcounty Is Null)) And
               Extract(Year From A.Invoicedate) = Extract(Year From Sysdate));