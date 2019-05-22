Create Or Replace View KD_Current As 
Select
    SD.Customer_No,
    Sum(SD.AllAmounts) as Rolling_6M
From 
    KD_Sales_Data_Request SD 
Where
    SD.Customer_No Not In (Select Customer_No From KD_Down) And
    SD.Customer_No Not In (Select Customer_No From KD_Lost) And
    SD.Customer_No Not In (Select Customer_No From KD_Recovered) And
    SD.Customer_No Not In (Select Customer_No From KD_New) And
    SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-6) AND
    SD.Charge_Type = 'Parts' And
    SD.Corporate_Form = 'DOMDIR' And
    SD.Catalog_No != '3DBC-22001091' And
    ((SD.Order_No Not Like 'W%' And
    SD.Order_No Not Like 'X%') Or
    SD.Order_No Is Null) And
    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
    SD.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
(SD.Order_No != 'C512921' Or SD.Order_No Is Null) --Kevin Stack's order/return that spanned years.
Group By
    SD.Customer_No