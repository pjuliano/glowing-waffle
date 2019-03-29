With Available_Qty As
(
    Select 
    Contract,
    Part_No,
    Sum(Qty_OnHand - Qty_Reserved) As Available_Qty
From 
    Inventory_Part_In_Stock
Group By
    Contract,
    Part_No
),
Sales As
(
    Select
        Catalog_No,
        Sum(Invoiced_Qty) Qty
    From
        KD_Sales_Data_Request A
    Where
        InvoiceDate >= Add_Months(Sysdate,-12)
    Group By
        Catalog_No
)
Select 
    A.Contract, 
    A.Part_No, 
    A.Description, 
    A.Part_Product_Family,
    Inventory_Product_Family_Api.Get_Description(A.Part_Product_Family) as Family_Description,
    A.Part_Product_Code,
    Inventory_Product_Code_Api.Get_Description(A.Part_Product_Code) As Code_Description,
    A.Accounting_Group,
    Accounting_Group_Api.Get_Description(A.Accounting_Group) as Accounting_Group_Description,
    A.Expected_Leadtime,
    Inventory_Part_Planning_Api.Get_Safety_Stock(A.Contract, A.Part_No) as Safety_Stock,
    B.Available_Qty,
    C.Qty as Sales_Qty_12M
From 
    Inventory_Part A Left Join Available_Qty B On
        A.Contract = B.Contract And
        A.Part_No = B.Part_No
                     Left Join Sales C On 
        A.Part_No = C.Catalog_No
Where
     A.Contract = '100' And
     A.Part_Status != 'O'
