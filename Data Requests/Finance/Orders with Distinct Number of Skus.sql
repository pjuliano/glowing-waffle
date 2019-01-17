Select
    Corporate_Form,
    Order_No,
    Count (Distinct Catalog_No) As Distinct_Catalog_Nos,
    Sum(A.Invoiced_Qty) As Total_Items,
    Sum(A.AllAmounts) As Total_Sales
From
    KD_Sales_Data_Request A
Where
    A.Corporate_Form != 'KEY' And
    Extract(Year From A.InvoiceDate) = 2018 And
    A.Charge_Type = 'Parts' And
    A.Catalog_No != '3DBC-22001091' And
    ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
    (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
Group By
    Corporate_Form,
    Order_No