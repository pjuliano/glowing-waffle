--Down Customer by PF
SELECT
    SD.Salesman_Code,
    Person_Info_Api.Get_Name(SD.Salesman_Code) As Salesman_Name,
    SD.Region_Code, 
    Customer_Info_Api.Get_Creation_Date(SD.Customer_No) as Cust_Create_Date,
    SD.Customer_No,
    SD.Customer_Name,
    SD.Part_Product_Family,
    SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) As Rolling_90D,
    SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End) As Rolling_90DLY,
    Round(SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) As "CY/LY_90D",
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) As Rolling_18M,
    SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End) as Rolling_18MLY,
    Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) As "CY/LY_18M",
    Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) Then SD.AllAmounts Else 0 End) As CY,
    Sum(Case When Extract(Year From Sd.InvoiceDate) = Extract(Year From Sysdate)-1 Then SD.AllAmounts Else 0 End) As PY,
    Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(YEar From Sysdate)-2 Then Sd.AllAmounts Else 0 End) As PY2,
    Sum(Case When Extract(YEar From sD.InvoiceDate) = Extract(Year From Sysdate)-3 then SD.AllAmounts Else 0 End) As PY3,
    Sum(Case When Extract(Year From Sd.InvoiceDate) = Extract(Year From Sysdate)-4 Then SD.AllAmounts Else 0 End) As PY4
FROM
    KD_Sales_Data_Request SD
WHERE
    Extract(Year From SD.InvoiceDate) >= Extract(Year From Sysdate)-3 AND
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
    Round(SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) <= .90 OR
    Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) <= .90
ORDER BY
    SD.Salesman_Code,
    SD.Customer_No,
    Round(SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) Asc,
    Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) Asc