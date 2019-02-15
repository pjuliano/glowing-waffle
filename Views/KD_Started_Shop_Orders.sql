Create or Replace View KD_Started_Shop_Orders As
Select
    A.Order_No,
    Inventory_Part_Api.Get_Part_Product_Family(A.contract,A.Part_No) As Product_Family,
    A.Part_No,
    Inventory_Part_Api.Get_Description(A.Contract,A.Part_No) As Description,
    A.Eng_Chg_Level,
    A.Revised_Due_Date As Due_Date,
    A.Need_Date,
    A.Qty_On_Order
From
    Shop_Ord A
Where
    State = 'Started'