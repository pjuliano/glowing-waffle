Create Or Replace View KD_Recovered As
Select
    SD.Customer_No,
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-6) Then SD.AllAmounts Else 0 End) As Rolling_6M,
    SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate),-18) And Add_Months(Trunc(Sysdate),-6) Then SD.AllAmounts Else 0 End) As Rolling_Between_18_And_6MLY,
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) As Rolling_18M
From
    KD_Sales_Data_Request SD 
Where
    SD.Customer_No Not In (Select Customer_No From KD_Down) And
    SD.Customer_No Not In (Select Customer_No From KD_Lost) And
    Extract(Year From SD.InvoiceDate) >= Extract(Year From Sysdate)-4 AND
    SD.Charge_Type = 'Parts' And
    SD.Corporate_Form = 'DOMDIR' And
    SD.Catalog_No != '3DBC-22001091' And
    ((SD.Order_No Not Like 'W%' And
    SD.Order_No Not Like 'X%') Or
    SD.Order_No Is Null) And
    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
    SD.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    SD.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
Group By
    SD.Customer_No
Having
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-6) Then SD.AllAmounts Else 0 End) > 1500 And
    SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate),-18) And Add_Months(Trunc(Sysdate),-6) Then SD.AllAmounts Else 0 End) <= 0 And
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) > 1500