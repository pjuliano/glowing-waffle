Create Or Replace View KD_Open_PO_Lines As
Select
    A.Order_No,
    A.Date_Entered,
    A.Line_No,
    A.Release_No,
    Inventory_Part_Api.Get_Accounting_Group(A.Contract,A.Part_No) As Accounting_Group,
    Inventory_Part_Api.Get_Part_Product_Family(A.Contract,A.Part_No) As Product_Family,
    A.Part_No,
    Inventory_Part_Api.Get_Description(a.Contract,A.Part_No) As Description,
    A.Eng_Chg_Level,
    A.Buy_Qty_Due,
    Purchase_Order_Invoice_API.Calc_Qty_Invoiced(ORDER_NO,Line_No,Release_No) As Invoiced_Qty,
    Case When Purchase_Order_Invoice_API.Calc_Qty_Invoiced(ORDER_NO,Line_No,Release_No) Is Null Then A.Buy_Qty_Due
         Else Buy_Qty_Due - Purchase_Order_Invoice_API.Calc_Qty_Invoiced(ORDER_NO,Line_No,Release_No)
    End As Qty_Remaining,
    A.Buy_Unit_Price
From
    Purchase_Order_Line_All A
Where
    A.State In ('Confirmed','Received','Released') And
    A.Contract = '100' And
    Order_No != 'P9276' And
    Inventory_Part_Api.Get_Accounting_Group(A.Contract,A.Part_No) In ('RM','FG','OP')
Order By
    Order_No,
    Inventory_Part_Api.Get_Accounting_Group(A.Contract,A.Part_No),
    Part_No