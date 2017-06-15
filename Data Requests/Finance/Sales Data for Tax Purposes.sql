Select
  A.Identity As Customer_No,
  Customer_Info_Api.Get_Name(A.Identity) As Customer_Name,
  A.Order_No,
  A.Rma_No,
  A.Series_Id || A.Invoice_No As Invoice_Id,
  A.Invoice_Date,
  A.Catalog_No,
  A.Description,
  Inventory_Part_Api.Get_Part_Product_Family(A.Company,A.Catalog_No) As Part_Product_Family,
  Inventory_Part_Api.Get_Part_Product_Code(A.Company,A.Catalog_No) As Part_Product_Code,
  Case When Inventory_Part_Api.Get_Part_Product_Family(A.Company,A.Catalog_No) In ('DYNAC','DYNAG','DYNAB','DYNAM','CONNX','CYTOP','BVINE','SYNTH','MTF')
       Then 'BIOMATERIALS'
       When Inventory_Part_Api.Get_Part_Product_Family(A.Company,A.Catalog_No) In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED')
       Then 'IMPLANTS'
       Else 'OTHER'
  End As Product_Type,
  Sales_Part_Api.Get_Catalog_Group(A.Company,A.Catalog_No) As Catalog_Group,
  A.Invoiced_Qty,
  A.Net_Curr_Amount As Allamounts,
  A.Vat_Curr_Amount As Tax_Amount,
  Customer_Order_Address_Api.Get_Address1(A.Order_No) As Delivadd1,
  Customer_Order_Address_Api.Get_Address2(A.Order_No) As Delivadd2,
  Customer_Order_Address_Api.Get_City(A.Order_No) As Delivcity,
  Customer_Order_Address_Api.Get_State(A.Order_No) As Delivstate,
  Customer_Order_Address_Api.Get_Zip_Code(A.Order_No) As Delivzip,
  Customer_Order_Address_Api.Get_County(A.Order_No) As County,
  Customer_Info_Address_Api.Get_Address1(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Delivery')) As Cust_Def_Add1,
  Customer_Info_Address_Api.Get_Address2(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Delivery')) As Cust_Def_Add2,
  Customer_Info_Address_Api.Get_City(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Delivery')) As Cust_Def_City,
  Customer_Info_Address_Api.Get_State(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Delivery')) As Cust_Def_State,
  Customer_Info_Address_Api.Get_Zip_Code(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Delivery')) As Cust_Def_Zip,
  Customer_Info_Address_Api.Get_County(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Delivery')) As Cust_Def_County
From
  Customer_Order_Inv_Join A
Where
  Objstate = 'Posted' And
  Customer_Info_Address_Api.Get_Country(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Delivery')) = 'UNITED STATES' And
  A.Invoice_Date Between To_Date('06/01/2016','MM/DD/YYYY') And To_Date('02/28/2017','MM/DD/YYYY') And
  A.Taxable_Db Is Not Null