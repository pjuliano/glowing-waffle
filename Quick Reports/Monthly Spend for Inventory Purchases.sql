Select 
  A.Contract,
  A.Order_No,
  A.Line_No,
  A.Release_No,
  A.Receipt_No,
  A.Vendor_No,
  Supplier_Info_Api.Get_Name(A.Vendor_No) As Vendor_Name,
  A.Part_No,
  A.Arrival_Date,
  A.Description,
  A.State,
  A.Qty_Arrived,
  Trunc(A.Arrival_Date) As Receipt_Date,
  B.Buy_Unit_Price,
  To_Char(A.Arrival_Date,'MM') As Month,
  To_Char(A.Arrival_Date,'YYYY') As Year,
  C.Part_Product_Family,
  C.Part_Cost_Group_Id,
  C.Accounting_Group,
  A.Qty_Arrived * B.Buy_Unit_Price As Extprice
From 
  Ifsapp.Purchase_Receipt_New A Left Join Ifsapp.Purchase_Order_Line_All B 
    On A.Order_No = B.Order_No And 
       A.Line_No = B.Line_No And
       A.Release_No = B.Release_No
                                Left Join Ifsapp.Inventory_Part C 
	  On B.Part_No = C.Part_No And 
       B.Contract = C.Contract
Where 
  A.Contract = '100' And
  A.Part_No Is Not Null And
	A.Arrival_Date Between To_Date('&DateFrom','MM/DD/YYYY') And To_Date('&DateTo','MM/DD/YYYY') And
  A.State != 'Cancelled' And
  (C.Accounting_Group Is Null Or 
  C.Accounting_Group In ('OP','RM','FG'))
Order By 
  A.State