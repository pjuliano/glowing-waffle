Select
  B.Part_Product_Family,
  B.Part_Product_Code,
  B.Catalog_No,
  B.Catalog_Desc,
  Customer_Info_Address_Api.Get_State(A.Identity,A.Delivery_Address_ID) As State,
  A.*
From
  Tax_Ledger_Item_Qry A Left Join Kd_Sales_Data_Request B
    On A.Series_Id || A.Invoice_No = B.Invoice_Id And
       A.Item_Id = B.Item_Id
Where
  A.Accounting_Year = 2017 And
  Customer_Info_Address_Api.Get_State(A.Identity,A.Delivery_Address_ID) = 'CA'