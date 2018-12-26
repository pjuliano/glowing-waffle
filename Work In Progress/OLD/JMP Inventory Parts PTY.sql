Select 
  Purchase_Order_Api.Get_Vendor_No(A.Order_No),
  A.Part_No,
  Inventory_Part_Api.Get_Description(A.Contract,A.Part_No),
  SUm(B.Qty_Onhand - B.Qty_Reserved)
From 
  Inventory_Transaction_Hist A,
  Inventory_Part_In_Stock B
Where 
  A.Part_No = B.Part_No And
  A.Lot_Batch_No = B.Lot_Batch_No And
  Purchase_Order_Api.Get_Vendor_No(A.Order_No) = '61010' And 
  A.Transaction = 'Receipt of Purchase Order'
Group By
  Purchase_Order_Api.Get_Vendor_No(A.Order_No),
  A.Part_No,
  Inventory_Part_Api.Get_Description(A.Contract,A.Part_No),
  Purchase_Order_Line_Api.Get_Fbuy_Unit_Price(A.Order_No,A.Sequence_No,A.Release_No)