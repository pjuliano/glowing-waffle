Create or Replace View KD_Sales_Data_Test As
Select
  A.Company As Site,
  A.Series_Id || A.Invoice_No As Invoice_Id,
  B.Item_Id,
  A.Invoice_Date As InvoiceDate,
  Case When A.Series_Id = 'CR' And A.Rma_No Is Null
       Then 0
       When A.Series_Id = 'CR' And A.Rma_No Is Not Null
       Then B.Invoiced_Qty * -1
       Else B.Invoiced_Qty
  End As Invoiced_Qty,
  B.Sale_Unit_Price,
  B.Discount,
  B.Net_Curr_Amount,
  B.Gross_Curr_Amount,
  B.Description As Catalog_Desc,
  A.Name as Customer_Name,
  B.Order_No,
  A.Identity As Customer_No,
  Cust_Ord_Customer_Api.Get_Cust_Grp(A.Identity) As Cust_Grp,
  B.Catalog_No,
  Person_Info_Api.Get_Name(Customer_Order_Api.Get_Authorize_Code(B.Order_No)) As Authorize_Code,
  Cust_Ord_Customer_Api.Get_Salesman_Code(A.Identity) As Salesman_Code,
  C.Commission_Receiver,
  Cust_Ord_Customer_Address_Api.Get_District_Code(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Pay')) As District_Code,
  Cust_Ord_Customer_Address_Api.Get_Region_Code(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Pay')) As Region_Code,
  A.Creation_Date As Createdate,
  Inventory_Part_Api.Get_Part_Product_Code(Decode(B.Contract,'241','240',B.Contract),B.Catalog_No) As Part_Product_Code,
  Inventory_Part_Api.Get_Part_Product_Family(Decode(B.Contract,'241','240',B.Contract),B.Catalog_No) As Part_Product_Family,
  Inventory_Part_Api.Get_Second_Commodity(Decode(B.Contract,'241','240',B.Contract),B.Catalog_No) As Second_Commodity,
  To_Char(A.Invoice_Date,'Month') As InvoiceMonth,
  'QTR' || To_Char(A.Invoice_Date,'Q') As Invoiceqtr,
  'QTR' || To_Char(A.Invoice_Date,'Q') || To_Char(A.Invoice_Date,'YYYY') As Invoiceqtryr,
  To_Char(A.Invoice_Date,'MM/YYYY') As Invoicemthyr,
  Identity_Invoice_Info_Api.Get_Group_Id(B.Company,B.Identity,B.Party_Type) As Group_Id,
  Inventory_Part_Api.Get_Type_Designation(100,B.Catalog_No) || Sales_Charge_Type_Api.Get_Charge_Group(A.Company,B.Catalog_No) As Type_Designation,
  Decode(Customer_Order_Api.Get_Customer_No_Pay(B.Order_No),Null,B.Identity) As Customer_No_Pay,
  D.Corporate_Form,
  Decode(A.Currency,'SEK',B.Net_Curr_Amount * 0.13,'DKK',B.Net_Curr_Amount * 0.13,'EUR',B.Net_Curr_Amount * 1.4,B.Net_Curr_Amount) As Fixedamounts,
  Case When A.Currency = 'CAD' And A.Invoice_Date >= To_Date('03/01/2013','MM/DD/YYYY')
       Then B.Net_Curr_Amount
       When A.Currency != 'USD'
       Then B.Net_Curr_Amount * Currency_Rate_Api.Get_Currency_Rate(99,A.Currency,4,A.Invoice_Date)
       Else B.Net_Curr_Amount
  End As Allamounts,
  Case When A.Currency In ('SEK','DKK')
       Then B.Net_Curr_Amount / Currency_Rate_Api.Get_Currency_Rate(230,A.Currency,1,A.Invoice_Date)
       Else B.Net_Curr_Amount
  End As Localamount,
  B.Net_Curr_Amount As Truelocalamt,
  B.Vat_Dom_Amount,
  B.Vat_Code,
  Case When Inventory_Part_Unit_Cost_Api.Get_Inventory_Value_By_Config(100,B.Catalog_No,'*') = 0 And Inventory_Part_Unit_Cost_Api.Get_Inventory_Value_By_Config(210,B.Catalog_No,'*') != 0 
       Then Inventory_Part_Unit_Cost_Api.Get_Inventory_Value_By_Config(210,B.Catalog_No,'*') * 1.4
       Else Inventory_Part_Unit_Cost_Api.Get_Inventory_Value_By_Config(100,B.Catalog_No,'*')
  End As Cost,
  Decode(D.Corporate_Form,'Freight','Freight','Parts') As Charge_Type,
  'IFS' As Source,
  Customer_Order_Api.Get_Market_Code(B.Order_No) As Market_Code,
  Customer_Info_Api.Get_Association_No(A.Identity) As Association_No,
  B.Vat_Curr_Amount,
  Payment_Term_Api.Get_Description(A.Company,Customer_Order_Api.Get_Pay_Term_Id(B.Order_No)) As Pay_Term_Description,
  Person_Info_Api.Get_Name(Customer_Order_Api.Get_Authorize_Code(B.Order_No)) As KdReference,
  Customer_Order_Api.Get_Cust_Ref(B.Order_No) As Customerref,
  Invoice_Api.Get_Delivery_Date(A.Company,A.Identity,A.Party_Type,B.Invoice_Id) As Deliverydate,
  A.Ship_Via,
  Invoice_Api.Get_Delivery_Identity(A.Company,B.Invoice_Id) As Delivery_Identity,
  A.Identity,
  Invoice_Api.Get_Delivery_Address_Id(A.Company,A.Identity,A.Party_Type,B.Invoice_Id) As Delivery_Address_Id,
  Customer_Order_Api.Get_Bill_Addr_No(B.ORder_No) as Invoice_Address_ID,
  A.Currency,
  B.Rma_No,
  Customer_Info_Address_Api.Get_Address1(A.Identity,Customer_Order_Api.Get_Bill_Addr_No(B.ORder_No)) As Invoiceadd1,
  Customer_Info_Address_Api.Get_Address2(A.Identity,Customer_Order_Api.Get_Bill_Addr_No(B.ORder_No)) As Invoiceadd2,
  Customer_Info_Address_Api.Get_City(A.Identity,Customer_Order_Api.Get_Bill_Addr_No(B.ORder_No)) As Invoicecity,
  Customer_Info_Address_Api.Get_State(A.Identity,Customer_Order_Api.Get_Bill_Addr_No(B.ORder_No)) As Invoicestate,
  Customer_Info_Address_Api.Get_Zip_Code(A.Identity,Customer_Order_Api.Get_Bill_Addr_No(B.ORder_No)) As Invoicezip,
  Customer_Info_Address_Api.Get_Country(A.Identity,Customer_Order_Api.Get_Bill_Addr_No(B.ORder_No)) As Invoicecountry,
  Customer_Info_Address_Api.Get_County(A.Identity,Customer_Order_Api.Get_Bill_Addr_No(B.ORder_No)) As Invoicecounty,
  Customer_Info_Address_Api.Get_Address1(A.Identity,Invoice_Api.Get_Delivery_Address_Id(A.Company,A.Identity,A.Party_Type,B.Invoice_Id)) As Delivadd1,
  Customer_Info_Address_Api.Get_Address2(A.Identity,Invoice_Api.Get_Delivery_Address_Id(A.Company,A.Identity,A.Party_Type,B.Invoice_Id)) As Delivadd2,
  Customer_Info_Address_Api.Get_City(A.Identity,Invoice_Api.Get_Delivery_Address_Id(A.Company,A.Identity,A.Party_Type,B.Invoice_Id)) As Delivcity,
  Customer_Info_Address_Api.Get_State(A.Identity,Invoice_Api.Get_Delivery_Address_Id(A.Company,A.Identity,A.Party_Type,B.Invoice_Id)) As Delivstate,
  Customer_Info_Address_Api.Get_Zip_Code(A.Identity,Invoice_Api.Get_Delivery_Address_Id(A.Company,A.Identity,A.Party_Type,B.Invoice_Id)) As Delivzip,
  Customer_Info_Address_Api.Get_Country(A.Identity,Invoice_Api.Get_Delivery_Address_Id(A.Company,A.Identity,A.Party_Type,B.Invoice_Id)) As Delivcountry,
  Customer_Info_Address_Api.Get_County(A.Identity,Invoice_Api.Get_Delivery_Address_Id(A.Company,A.Identity,A.Party_Type,B.Invoice_Id)) As Delivcounty
From
  Customer_Order_Inv_Head_Uiv A,
  Customer_Info D,
  Customer_Order_Inv_Item_Uiv B Left Join Cust_Def_Com_Receiver C
    On B.Identity = C.Customer_No
Where
  A.Invoice_Id = B.Invoice_Id And
  A.Company  = B.Company And
  A.Identity = B.Identity And
  A.Identity = D.Customer_ID