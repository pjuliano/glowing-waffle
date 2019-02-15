Create Or Replace View KD_Inventory_Levels As
Select
    A.Contract,
    Inventory_Part_Api.Get_Accounting_Group(A.Contract,A.Part_No) As Accounting_Group,
    Inventory_Part_Api.Get_Part_product_Family(A.Contract,A.Part_No) As Product_Family,
    A.Part_No,
    Inventory_Part_Api.Get_Description(A.Contract,A.Part_No) as Description,
    A.Eng_Chg_level,
    Sum(A.Qty_In_Transit) Qty_In_Transit,
    SUm(A.Qty_OnHand) Qty_OnHand,
    SUm(A.Qty_Reserved) Qty_Reserved,
    Sum(A.Qty_OnHand - A.Qty_Reserved) as Qty_Available
From
    Inventory_Part_In_Stock A
Where
    A.Warehouse Not Like 'CON%' And
    Inventory_Part_Api.Get_Part_Status(A.Contract,A.Part_No) = 'A' And
    Inventory_Part_Api.Get_Accounting_Group(A.Contract,A.Part_No) In ('RM','OP','FG') And 
    A.Contract = '100'
Group By
    A.Contract,
    Inventory_Part_Api.Get_Accounting_Group(A.Contract,A.Part_No),
    Inventory_Part_Api.Get_Part_product_Family(A.Contract,A.Part_No),
    A.Part_No,
    Inventory_Part_Api.Get_Description(A.Contract,A.Part_No),
    A.Eng_Chg_level
Order by
    A.Contract,
    Inventory_Part_Api.Get_Accounting_Group(A.Contract,A.Part_No),
    Inventory_Part_Api.Get_Part_product_Family(A.Contract,A.Part_No),
    A.Part_No