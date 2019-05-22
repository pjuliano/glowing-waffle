Create Or Replace View KD_New_Bio_Cust_CY As 
Select
    Customer_No,
    Sum(Case When Extract(Year from InvoiceDate) < Extract(Year From Sysdate) And
                  Part_Product_Code = 'REGEN' Then AllAmounts
             Else 0 End) As PYs_Regen,
    Sum(Case When Extract(Year from InvoiceDate) = Extract(Year From Sysdate) And
              Part_Product_Code = 'REGEN' Then AllAmounts
         Else 0 End) As CY_Regen
From
    KD_Sales_Data_Request A
Where
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
    ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
    (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
(A.Order_No != 'C512921' Or A.Order_No Is Null) --Kevin Stack's order/return that spanned years.
Group By
    Customer_No
Having
    Sum(Case When Extract(Year from InvoiceDate) < Extract(Year From Sysdate) And
              Part_Product_Code = 'REGEN' Then AllAmounts
             Else 0 End) <= 0 And
    Sum(Case When Extract(Year from InvoiceDate) = Extract(Year From Sysdate) And
              Part_Product_Code = 'REGEN' Then AllAmounts
         Else 0 End) > 500