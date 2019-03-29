Create Or Replace View KD_New_Kit_Cust_CY As 
With Kits As (
Select
    A.Customer_No,
    A.Part_Product_Family,
    Sum(Case When Extract(Year From A.InvoiceDate) < Extract(Year From Sysdate) Then A.Invoiced_Qty Else 0 End) As OldKits,
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate) Then A.Invoiced_Qty Else 0 End) As NewKits
From
    KD_Sales_Data_Request A,
    KD_Kit_Parts B
Where
    A.Catalog_No = B.Catalog_No And
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
    ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
    (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
Group By
    A.Customer_No,
    A.Part_Product_Family
Having
    Sum(Case When Extract(Year From A.InvoiceDate) < Extract(Year From Sysdate) Then A.Invoiced_Qty Else 0 End) <= 0 And
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate) Then A.Invoiced_Qty Else 0 End) > 0 )

Select
    A.Customer_No,
    B.Part_Product_Family,
    Sum(A.AllAmounts) as Family_Total
From
 Kits B Left Join   KD_Sales_Data_Request A 
     On A.Customer_No = B.Customer_No And
    A.Part_Product_Family = B.Part_Product_Family
Where
    Extract(Year From InvoiceDate) = Extract(Year From Sysdate) And
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
    ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
    (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
Group By
    A.Customer_No,
    B.Part_Product_Family