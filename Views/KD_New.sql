Create or Replace View KD_New As 
Select
    SD.Customer_No,
    Sum(SD.AllAmounts) As Rolling_6M
From
    KD_Sales_Data_Request SD, KD_First_Order_Date FOD
Where
    SD.Customer_No Not In (Select Customer_No From KD_Down) And
    SD.Customer_No Not In (Select Customer_No From KD_Lost) And
    SD.Customer_No Not In (Select Customer_No From KD_Recovered) And
    SD.Customer_No = FOD.Customer_No And
    FOD.First_Order_Date >= Add_Months(Trunc(Sysdate),-6) And
    SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-6) And
    SD.Charge_Type = 'Parts' And
    SD.Corporate_Form = 'DOMDIR' And
    SD.Catalog_No != '3DBC-22001091' And
    ((SD.Order_No Not Like 'W%' And
    SD.Order_No Not Like 'X%') Or
    SD.Order_No Is Null) And
    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
    SD.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
(SD.Order_No != 'C512921' Or SD.Order_No Is Null) --Kevin Stack's order/return that spanned years.
    And Sd.Source != 'PTUSAXLSX'
Group By
    SD.Customer_No