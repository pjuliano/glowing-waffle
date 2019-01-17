--Reactivated Implant Customer (Bodies)
WITH LIOD AS (  SELECT
                    SD.Customer_No,
                    SD.Part_Product_Family,
                    SD.Order_No,
                    MAX(SD.InvoiceDate) AS Last_Implant_Order_Date,
                    MIN(SD.InvoiceDate) AS First_Implant_Order_Date_CY
                FROM
                    KD_Sales_Data_Request SD
                WHERE
                    SD.Part_Product_Code = 'IMPL' And
                    EXTRACT(YEAR FROM SD.InvoiceDate) = EXTRACT(YEAR FROM SYSDATE) AND
                    SD.Charge_Type = 'Parts' And
                    SD.Corporate_Form = 'DOMDIR' And
                    SD.Catalog_No != '3DBC-22001091' And
                    ((SD.Order_No Not Like 'W%' And
                    SD.Order_No Not Like 'X%') Or
                    SD.Order_No Is Null) And
                    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
                    SD.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
                GROUP BY
                    SD.Customer_No,
                    SD.Part_Product_Family,
                    SD.Order_No ),
SLIOD AS    (   SELECT 
                    SD.Customer_No,
                    SD.Part_Product_Family,
                    MAX(SD.InvoiceDate) As Second_Last_Implant_Order_Date
                FROM
                    KD_Sales_Data_Request SD,
                    LIOD
                WHERE
                    SD.Customer_No = LIOD.Customer_No AND
                    SD.Part_Product_Family = LIOD.Part_Product_Family AND
                    SD.Order_No != LIOD.Order_No AND
                    SD.InvoiceDate < LIOD.First_Implant_Order_Date_CY AND
                    SD.Charge_Type = 'Parts' And
                    SD.Corporate_Form = 'DOMDIR' And
                    SD.Catalog_No != '3DBC-22001091' And
                    ((SD.Order_No Not Like 'W%' And
                    SD.Order_No Not Like 'X%') Or
                    SD.Order_No Is Null) And
                    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
                    SD.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
                GROUP BY
                    SD.Customer_No,
                    SD.Part_Product_Family  )
SELECT
    SD.Salesman_Code,
    Person_Info_Api.Get_Name(SD.Salesman_Code) As Salesman_Name,
    SD.Region_Code,
    Customer_Info_Api.Get_Creation_Date(SD.Customer_No) As Cust_Creation_Date,
    SD.Customer_No,
    SD.Customer_Name,
    SD.Part_Product_Family,
    LIOD.Last_Implant_Order_Date,
    LIOD.First_Implant_Order_Date_CY,
    SLIOD.Second_Last_Implant_Order_Date,
    LIOD.First_Implant_Order_Date_Cy - SLIOD.Second_Last_Implant_Order_Date As Date_Diff
FROM
    KD_Sales_Data_Request SD,
    LIOD,
    SLIOD
WHERE
    SD.Customer_No = LIOD.Customer_No AND
    SD.Customer_No = SLIOD.Customer_No AND
    SD.Part_Product_Family = LIOD.Part_Product_Family AND
    SD.Part_Product_Family = SLIOD.Part_Product_Family AND
    SD.Order_No = LIOD.Order_No AND
    LIOD.First_Implant_Order_Date_Cy - SLIOD.Second_Last_Implant_Order_Date >= 547 AND
    SD.Charge_Type = 'Parts' And
    SD.Corporate_Form = 'DOMDIR' And
    SD.Catalog_No != '3DBC-22001091' And
    ((SD.Order_No Not Like 'W%' And
    SD.Order_No Not Like 'X%') Or
    SD.Order_No Is Null) And
    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
    SD.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
GROUP BY
    SD.Salesman_Code,
    Person_Info_Api.Get_Name(SD.Salesman_Code),
    SD.Region_Code,
    Customer_Info_Api.Get_Creation_Date(SD.Customer_No),
    SD.Customer_No,
    SD.Customer_Name,
    SD.Part_Product_Family,
    LIOD.Last_Implant_Order_Date,
    LIOD.First_Implant_Order_Date_CY,
    SLIOD.Second_Last_Implant_Order_Date,
    LIOD.First_Implant_Order_Date_Cy - SLIOD.Second_Last_Implant_Order_Date
Order By
    SD.Salesman_Code,
    SD.Customer_No,
    SD.Part_Product_Family,
    LIOD.First_Implant_Order_Date_CY