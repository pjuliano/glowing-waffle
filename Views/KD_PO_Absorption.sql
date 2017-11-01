Create or Replace View KD_PO_Absorption As
Select
  Purchase_Order_Api.Get_Vendor_No(B.Order_No) As Vendor_No,
  Supplier_Info_Api.Get_Name(Purchase_Order_Api.Get_Vendor_No(B.Order_No)) As Vendor_Name,
  B.Order_No,
  A.Date_Applied,
  B.Transaction,
  A.Curr_Amount,
  A.Userid,
  B.Part_No,
  Sales_Part_Api.Get_Catalog_Desc(B.Contract,B.Part_No) As Description,
  B.Quantity,
  C.Inventory_Value * B.Quantity As Inv_Value_Unit_Cost_X_Qty,
  B.Lot_Batch_No,
  B.Serial_No
From
  Mpccom_Accounting A,
  Inventory_Transaction_Hist B,
  KD_Cost_100 C
Where
  A.Accounting_Id = B.Accounting_Id And
  B.Part_No = C.Part_No And
  A.Str_Code In ('M57','M152') And
  Extract(Year From A.Date_Applied) = Extract(Year From Sysdate)
Order By
  Purchase_Order_Api.Get_Vendor_No(B.Order_No)