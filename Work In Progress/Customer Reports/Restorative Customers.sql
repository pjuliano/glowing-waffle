--Restorative Customers (Implant Families)
SELECT
    SD.Salesman_Code,
    Person_Info_Api.Get_Name(SD.Salesman_Code) As Salesman_Name,
    SD.Region_Code, 
    Customer_Info_Api.Get_Creation_Date(SD.Customer_No) as Cust_Create_Date,
    SD.Customer_No,
    SD.Customer_Name,
    SD.Part_Product_Family,
    SUM(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) And 
                  SD.Part_Product_Code != 'IMPL'
             Then SD.AllAmounts 
             Else 0
        End) As Resto_Sales
FROM
    KD_Sales_Data_Request SD
WHERE
    SD.Part_Product_Code != 'REGEN' And
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
    SD.Part_Product_Family
HAVING
    (   SUM(Case When SD.Part_Product_Code = 'IMPL' Then SD.AllAmounts Else 0 End) <= 0 AND
        SUM(Case When Extract(Year From SD.InvoiceDate) < Extract(Year From Sysdate) And 
                  SD.Part_Product_Code != 'IMPL' 
             Then SD.AllAmounts 
             Else 0
        End) = 0 AND
        SUM(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) And 
                  SD.Part_Product_Code != 'IMPL' 
             Then SD.AllAmounts 
             Else 0
        End) > 0    )
ORDER BY
    SD.Salesman_Code,
    SD.Customer_No,
    SD.Part_Product_Family