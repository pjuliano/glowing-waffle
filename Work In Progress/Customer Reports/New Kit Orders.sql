--New kit orders
With FKOD As (  Select
                    SD.Customer_No,
                    SD.Catalog_No,
                    Min(SD.InvoiceDate) as First_Kit_Order_Date
                From
                    KD_Sales_Data_Request SD,
                    KD_Kit_Parts KP
                Where
                    SD.Catalog_No = KP.Catalog_No And
                    SD.Charge_Type = 'Parts' And
                    SD.Corporate_Form = 'DOMDIR' And
                    SD.Catalog_No != '3DBC-22001091' And
                    ((SD.Order_No Not Like 'W%' And
                    SD.Order_No Not Like 'X%') Or
                    SD.Order_No Is Null) And
                    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
                    SD.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
                Group By
                    SD.Customer_No,
                    SD.Catalog_No)
Select
    SD.Salesman_Code,
    Person_Info_Api.Get_Name(SD.Salesman_Code) As Salesman_Name,
    SD.Region_Code,
    Customer_Info_Api.Get_Creation_Date(SD.Customer_No) As Cust_Creation_Date,
    SD.Customer_No,
    SD.Customer_Name,
    SD.InvoiceDate,
    SD.Invoice_ID,
    SD.Order_No,
    SD.Catalog_No,
    SD.Catalog_Desc
From
    KD_Sales_Data_Request SD,
    FKOD
Where
    SD.Customer_No = FKOD.Customer_No AND
    SD.Catalog_No = FKOD.Catalog_No AND
    Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) And
    SD.Corporate_Form = 'DOMDIR' And
    Fkod.First_Kit_Order_Date = SD.InvoiceDate And
    SD.Charge_Type = 'Parts' And
    SD.Corporate_Form = 'DOMDIR' And
    SD.Catalog_No != '3DBC-22001091' And
    ((SD.Order_No Not Like 'W%' And
    SD.Order_No Not Like 'X%') Or
    SD.Order_No Is Null) And
    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
    SD.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
Order By
    SD.Salesman_Code,
    SD.Customer_No,
    SD.Catalog_No,
    SD.InvoiceDate Asc
