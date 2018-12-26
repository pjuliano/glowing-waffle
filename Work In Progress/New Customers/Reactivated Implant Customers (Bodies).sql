--Reactivated Implant Customer (Bodies)
--LIOD Should be most recent IMPL purchase
WITH LIOD AS (  SELECT
                    SD.Customer_No,
                    SD.Part_Product_Family,
                    MAX(SD.InvoiceDate) AS Last_Implant_Order_Date
                FROM
                    KD_Sales_Data_Request SD
                WHERE
                    SD.Part_Product_Code = 'IMPL' And
                    EXTRACT(YEAR FROM SD.InvoiceDate) = EXTRACT(YEAR FROM SYSDATE)
                GROUP BY
                    SD.Customer_No,
                    SD.Part_Product_Family  
                ORDER BY
                    SD.Customer_No,
                    SD.Part_Product_Family  )
SELECT
    SD.Salesman_Code,
    Person_Info_Api.Get_Name(SD.Salesman_Code) As Salesman_Name,
    SD.Region_Code,
    SD.Customer_No,
    SD.Customer_Name,
    SD.InvoiceDate,
    SD.Invoice_ID,
    SD.Order_No,
    SD.Part_Product_Family,
    LIOD.Last_Implant_Order_Date - (SELECT 
                                        MAX(SD2.InvoiceDate)
                                    FROM
                                        KD_Sales_Data_Request SD2
                                    WHERE
                                        SD.Customer_No = SD2.Customer_No AND
                                        SD.Part_Product_Family = SD2.Part_Product_Family AND
                                        LIOD.Last_Implant_Order_Date > SD2.InvoiceDate And
                                        SD.Order_No != SD2.Order_No
                                    GROUP BY
                                        SD2.Customer_No,
                                        SD2.Part_Product_Family) AS Days_Since_Prior_Order
FROM
    KD_Sales_Data_Request SD,
    LIOD
WHERE
    SD.Customer_No = LIOD.Customer_No AND
    SD.Part_Product_Family = LIOD.Part_Product_Family AND
    SD.Part_Product_Code = 'IMPL' AND
    SD.Corporate_Form = 'DOMDIR'
GROUP BY
    SD.Salesman_Code,
    Person_Info_Api.Get_Name(SD.Salesman_Code),
    SD.Region_Code,
    SD.Customer_No,
    SD.Customer_Name,
    SD.InvoiceDate,
    SD.Invoice_ID,
    SD.Order_No,
    SD.Part_Product_Family,
    LIOD.Last_Implant_Order_Date
HAVING
    LIOD.Last_Implant_Order_Date - (SELECT 
                                        MAX(SD2.InvoiceDate)
                                    FROM
                                        KD_Sales_Data_Request SD2
                                    WHERE
                                        SD.Customer_No = SD2.Customer_No AND
                                        SD.Part_Product_Family = SD2.Part_Product_Family AND
                                        LIOD.Last_Implant_Order_Date > SD2.InvoiceDate AND
                                        SD.Order_No != SD2.Order_No
                                    GROUP BY
                                        SD2.Customer_No,
                                        SD2.Part_Product_Family) >= 547