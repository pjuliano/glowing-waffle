Create Table KD_PRIOR_KITS As
Select
    A.Salesman_Code,
    A.Customer_No,
    A.Order_No,
    A.CreateDate,
    A.Part_Product_Family,
    A.Catalog_No
From
    KD_Sales_Data_Request A,
    KD_Kit_Parts B
Where
    A.Catalog_No = B.Catalog_No And
    A.Charge_Type = 'Parts' And
    Extract(Year From A.Invoicedate) < Extract(Year From Sysdate) And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
    ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
    (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND 
(A.Order_No != 'C512921' Or A.Order_No Is Null) --Kevin Stack's order/return that spanned years.