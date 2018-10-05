With 
    Max_Date As (
        Select
            A.Price_List_No,
            A.Catalog_No,
            Max(A.Valid_From_Date) As Latest_Entry_Date
        From
            Sales_Price_List_Part A 
        Group By 
            A.Price_List_No, 
            A.Catalog_No),
    
    Customer_Price_Lists As (
        Select
            Price_List_No,
            Count(Customer_ID) As Customers_Assigned
        From
            Customer_Pricelist_Ent
        Where
            Customer_Info_Api.Get_Association_No(Customer_Id) Not Like '%N%' and
            Customer_Info_Api.Get_Country(Customer_ID) In ('UNITED STATES','CANADA')
        Group By
            Price_List_No)            
    
Select
    A.Price_List_No,
    Inventory_Part_Api.Get_Part_Product_Family('100',A.Catalog_No) As Family,
    A.Catalog_No,
    A.Base_Price,
    A.Percentage_Offset,
    A.Sales_Price,
    C.Customers_Assigned
From
    Sales_Price_List_Part A,
    Max_Date B,
    Customer_Price_Lists C
Where
    A.Price_List_No = B.Price_List_No And
    A.Catalog_No = B.Catalog_No And
    A.Valid_From_Date = B.Latest_Entry_Date And
    A.Price_List_No = C.Price_List_No And
    Inventory_Part_Api.Get_Part_Product_Code('100',A.Catalog_No) = 'IMPL' And
    Mod(A.Percentage_Offset,5) != 0 And
    Sales_Part_Api.Get_Sales_Price_Group_Id('100',A.Catalog_No) != 'SIMPLNT'
Order By
    Price_List_No,
    Catalog_No