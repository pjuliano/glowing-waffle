Create Or Replace View KD_Tax_Audit As
Select
  B.Part_Product_Family,
  B.Part_Product_Code,
  Sales_Part_Api.Get_Catalog_Group(B.Site, B.Catalog_No) As Sales_Group,
  B.Invoiced_Qty,
  B.Catalog_No,
  B.Catalog_Desc,
  Customer_Info_Address_Api.Get_State(A.Identity,A.Delivery_Address_Id) As State,
  A.*
From
  Tax_Ledger_Item_Qry A Left Join Kd_Sales_Data_Request B
    On A.Series_Id || A.Invoice_No = B.Invoice_Id And
       A.Item_Id = B.Item_Id