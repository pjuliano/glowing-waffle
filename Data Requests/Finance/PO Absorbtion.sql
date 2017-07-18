Select
  Purchase_Order_Api.Get_Vendor_No(B.Order_No) As Vendor_No,
  Supplier_Info_Api.Get_Name(Purchase_Order_Api.Get_Vendor_No(B.Order_No)) As Vendor_Name,
  B.Order_No,
  To_Char(A.Date_Applied,'MM/DD/YYYY') As Date_Applied,
  B.Transaction,
  Case When B.Transaction != 'Receipt of Purchase Order' Then (-1 * A.Curr_Amount) Else A.Curr_Amount End As Curr_Amount,
  A.Userid,
  B.Part_No,
  Sales_Part_Api.Get_Catalog_Desc(B.Contract,B.Part_No) As Description,
  B.Quantity,
  Case When B.Transaction != 'Receipt of Purchase Order' Then (-1 * C.Inventory_Value * B.Quantity) Else (C.Inventory_Value * B.Quantity) End As Inv_Value_Unit_Cost_X_Qty,
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
  A.Date_Applied Between To_Date('01/01/2017','MM/DD/YYYY') And To_Date('07/31/2017','MM/DD/YYYY')
Order By
  Purchase_Order_Api.Get_Vendor_No(B.Order_No)