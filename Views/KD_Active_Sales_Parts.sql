Create Or Replace View KD_Active_Sales_Parts As
Select
    Inventory_Part_Api.Get_Part_Product_Family(A.Contract,A.Catalog_No) As Product_Family,
    Part_No,
    Catalog_Desc As Description,
    A.Catalog_Group,
    A.Catalog_Type,
    A.List_Price
From
    Sales_Part A
Where
    A.Activeind_Db = 'Y' And
    A.Contract = '100'
Order By
    Inventory_Part_Api.Get_Part_Product_Family(A.Contract,A.Catalog_No),
    Part_No