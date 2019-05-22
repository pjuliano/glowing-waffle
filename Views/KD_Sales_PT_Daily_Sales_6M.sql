Create Or Replace View KD_Sales_Pt_Daily_Sales_6M As
Select
    A.Site,
    Decode(B.Part_Cost_Group_ID,'PALTP','PALTOP','KEYSTONE') As DIVISION,
    A.Part_Product_Family,
    A.Part_Product_Code,
    A.Catalog_No,
    A.Catalog_Desc,
    A.InvoiceDate,
    Sum(A.Invoiced_Qty) Total_Invoiced_Qty
From
    KD_Sales_Data_Request A Left Join Inventory_Part B On
        A.Site = B.Contract And
        A.Catalog_No = B.Part_No
Where
    InvoiceDate Between Add_Months(Sysdate,-6) And Trunc(Sysdate) And
    Charge_Type != 'Freight'
Group By
    A.Site,
    Decode(B.Part_Cost_Group_ID,'PALTP','PALTOP','KEYSTONE'),
    A.Part_Product_Code,
    A.Part_Product_Family,
    A.Catalog_No,
    A.Catalog_Desc,
    A.InvoiceDate
Order By
    A.InvoiceDate,
    A.Part_Product_Family,
    A.Part_Product_Code,
    A.Catalog_No