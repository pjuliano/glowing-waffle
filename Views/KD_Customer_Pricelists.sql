Create Or Replace View Kd_Customer_Pricelists As
Select 
    Customer_Id,
    LISTAGG(Price_List_No, ', ') Within Group (Order BY Customer_ID) as Price_Lists
From 
    Customer_Pricelist_Ent
Group By
    Customer_ID;