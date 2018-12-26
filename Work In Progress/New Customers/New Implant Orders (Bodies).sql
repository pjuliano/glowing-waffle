--New Implant Customer (Bodies)
WITH FIOD AS (  SELECT
                    SD.Customer_No,
                    SD.Part_Product_Family,
                    MIN(SD.InvoiceDate) AS First_Implant_Order_Date
                FROM
                    KD_Sales_Data_Request SD
                WHERE
                    SD.Part_Product_Code = 'IMPL' And
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
                    SD.Part_Product_Family  
                ORDER BY
                    SD.Customer_No,
                    SD.Part_Product_Family  )
SELECT
    SD.Salesman_Code,
    Person_Info_Api.Get_Name(SD.Salesman_Code) AS Salesman_Name,
    SD.Region_Code,
    SD.Customer_No,
    SD.Customer_Name,
    SD.InvoiceDate,
    SD.Invoice_ID,
    SD.Order_No,
    SD.Part_Product_Family
FROM
    KD_Sales_Data_Request SD,
    FIOD
WHERE
    SD.Customer_No = FIOD.Customer_No AND 
    SD.Part_Product_Family = FIOD.Part_Product_Family AND
    EXTRACT(YEAR FROM SD.InvoiceDate) = EXTRACT(YEAR FROM SYSDATE) AND
    SD.Corporate_Form = 'DOMDIR' AND
    FIOD.First_Implant_Order_Date = SD.InvoiceDate AND
    SD.Part_Product_Code = 'IMPL' And
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
    SD.Customer_No,
    SD.Customer_Name,
    SD.InvoiceDate,
    SD.Invoice_ID,
    SD.Order_No,
    SD.Part_Product_Family    
ORDER BY
    SD.Salesman_Code,
    SD.Part_Product_Family,
    SD.InvoiceDate Asc,
    SD.Customer_No
