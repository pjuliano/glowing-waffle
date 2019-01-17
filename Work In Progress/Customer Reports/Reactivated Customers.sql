--Reactivated Customers
WITH LOD AS (  SELECT
                    SD.Customer_No,
                    SD.Part_Product_Family,
                    MAX(SD.InvoiceDate) AS Last_Order_Date,
                    MIN(SD.InvoiceDate) AS First_Order_Date_CY
                FROM
                    KD_Sales_Data_Request SD
                WHERE
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
                    SD.Part_Product_Family),
SLOD AS     (   SELECT 
                    SD.Customer_No,
                    SD.Part_Product_Family,
                    MAX(SD.InvoiceDate) As Second_Last_Order_Date
                FROM
                    KD_Sales_Data_Request SD,
                    LOD
                WHERE
                    SD.Customer_No = LOD.Customer_No AND
                    SD.Charge_Type = 'Parts' And
                    SD.Corporate_Form = 'DOMDIR' And
                    SD.Catalog_No != '3DBC-22001091' And
                    ((SD.Order_No Not Like 'W%' And
                    SD.Order_No Not Like 'X%') Or
                    SD.Order_No Is Null) And
                    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
                    SD.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
                    SD.InvoiceDate < Lod.First_Order_Date_CY
                GROUP BY
                    SD.Customer_No,
                    SD.Part_Product_Family )
SELECT
    SD.Salesman_Code,
    Person_Info_Api.Get_Name(SD.Salesman_Code) As Salesman_Name,
    SD.Region_Code,
    Customer_Info_Api.Get_Creation_Date(SD.Customer_No) As Cust_Creation_Date,
    SD.Customer_No,
    SD.Customer_Name,
    SD.Part_Product_Family,
    LOD.Last_Order_Date,
    LOD.First_Order_Date_CY,
    SLOD.Second_Last_Order_Date,
    LOD.First_Order_Date_Cy - SLOD.Second_Last_Order_Date As Date_Diff
FROM
    KD_Sales_Data_Request SD,
    LOD,
    SLOD
WHERE
    SD.Customer_No = LOD.Customer_No AND
    SD.Customer_No = SLOD.Customer_No AND
    SD.Part_Product_Family = LOD.Part_Product_Family AND
    SD.Part_Product_Family = SLOD.Part_Product_Family AND
    LOD.First_Order_Date_Cy - SLOD.Second_Last_Order_Date >= 547 AND
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
    LOD.Last_Order_Date,
    LOD.First_Order_Date_CY,
    SLOD.Second_Last_Order_Date,
    LOD.First_Order_Date_Cy - SLOD.Second_Last_Order_Date
Order By
    SD.Salesman_Code,
    SD.Customer_No,
    SD.Part_Product_Family,
    LOD.First_Order_Date_CY
