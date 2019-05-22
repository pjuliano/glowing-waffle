With Totals As 
    (
    Select 
        A.Order_No,
        Sum(A.Allamounts) As Total,
        Sum(B.List_Price * A.Invoiced_Qty) As List,
        Sum(Case When Part_Product_Code = 'IMPL' Then A.Invoiced_Qty Else 0 End) As Implants
    From 
        KD_Sales_Data_Request A Left Join Sales_Part B
            On A.Site = B.Contract And 
               A.Catalog_no = B.Catalog_No
    Where 
        A.Charge_Type = 'Parts' And
        A.Catalog_No Not In (Select Catalog_No From KD_Kit_Parts) And
        Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate) And
        A.Corporate_Form = 'DOMDIR' And
        A.Catalog_No != '3DBC-22001091' And
        ((A.Order_No Not Like 'W%' And
        A.Order_No Not Like 'X%') Or
        A.Order_No Is Null) And
        (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
        A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
        A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
    Group By
        A.Order_No
    )
--Keystone Kits    
Select Distinct
    A.Salesman_Code,
    Person_Info_Api.Get_Name(A.Salesman_Code) As Salesman_Name,
    A.Customer_No,
    A.Customer_Name,
    A.Order_No,
    A.Part_Product_Family,
    C.Total,
    C.Implants,
    C.List,
    Round((1 - C.Total/Nullif(C.List,0)) * 100,2) As Discount_Pct
From
    KD_Sales_Data_Request A,
    KD_Kit_Parts B,
    Totals C
Where
    --A.Customer_No || '-' || A.Part_Product_Family Not In (Select Customer_No || '-' || Part_Product_Family From KD_Prior_Kits) And
    A.Order_No = C.Order_No And
    A.Catalog_No = B.Catalog_No And
    B.Catalog_No Not In ('LODI-7422','LODI-7421','15700K','15863K','30-70021','60-70111','60-70112','60-70110') And
    Extract(Year from InvoiceDate) = Extract(Year From Sysdate) And
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
    ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
    (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND
    (A.Order_No != 'C512921' Or A.Order_No Is Null) --Kevin Stack's order/return that spanned years.
    --C.Total >= 6000 And
    --Round((1 - C.Total/Nullif(C.List,0)) * 100,2) <= 25

Union All
--Paltop Kits
Select Distinct
    A.Salesman_Code,
    Person_Info_Api.Get_Name(A.Salesman_Code) As Salesman_Name,
    A.Customer_No,
    A.Customer_Name,
    A.Order_No,
    A.Part_Product_Family,
    C.Total,
    C.Implants,
    C.List,
    Round((1 - C.Total/Nullif(C.List,0)) * 100,2) As Discount_Pct
From
    KD_Sales_Data_Request A,
    KD_Kit_Parts B,
    Totals C
Where
    --A.Customer_No || '-' || A.Part_Product_Family Not In (Select Customer_No || '-' || Part_Product_Family From KD_Prior_Kits) And
    A.Order_No = C.Order_No And
    A.Catalog_No = B.Catalog_No And
    B.Catalog_No In ('30-70021','60-70111','60-70112','60-70110') And
    Extract(Year from InvoiceDate) = Extract(Year From Sysdate) And
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
    ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
    (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND
    (A.Order_No != 'C512921' Or A.Order_No Is Null) --Kevin Stack's order/return that spanned years.
    --Round((1 - C.Total/Nullif(C.List,0)) * 100,2) <= 25 And
    --C.Implants >= 30

Order By 1