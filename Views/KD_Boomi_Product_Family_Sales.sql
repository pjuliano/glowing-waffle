Create Or Replace View KD_Boomi_Product_Family_Sales As
SELECT
    Case When Round(SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) <= .90 AND
              Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) <= .90
         Then 'DOWN'
         When Round(SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) Between .90 And 1.1 and
              Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) Between .90 and 1.1
         Then 'FLAT'
         When Round(SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4)  > 1.1 and
              Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) > 1.1
         Then 'UP'
    End As Status,
    SD.Customer_No,
    SD.Part_Product_Family,
    SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) As Rolling_90D,
    SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End) As Rolling_90DLY,
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-6) Then SD.AllAmounts Else 0 End) As Rolling_6M,
    SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End) As Rolling_6MLY,
    (Round(SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4)) * 100 As "CY/LY_90D",
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) As Rolling_18M,
    SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End) as Rolling_18MLY,
    (Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4)) * 100 As "CY/LY_18M",
    Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) Then SD.AllAmounts Else 0 End) As CY,
    Sum(Case When Extract(Year From Sd.InvoiceDate) = Extract(Year From Sysdate)-1 Then SD.AllAmounts Else 0 End) As PY,
    Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(YEar From Sysdate)-2 Then Sd.AllAmounts Else 0 End) As PY2,
    Sum(Case When Extract(YEar From sD.InvoiceDate) = Extract(Year From Sysdate)-3 then SD.AllAmounts Else 0 End) As PY3,
    Sum(Case When Extract(Year From Sd.InvoiceDate) = Extract(Year From Sysdate)-4 Then SD.AllAmounts Else 0 End) As PY4
FROM
    KD_Sales_Data_Request SD
WHERE
    Extract(Year From SD.InvoiceDate) >= Extract(Year From Sysdate)-4 AND
    SD.Charge_Type = 'Parts' And
    SD.Catalog_No != '3DBC-22001091' And
    ((SD.Order_No Not Like 'W%' And
    SD.Order_No Not Like 'X%') Or
    SD.Order_No Is Null) And
    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
    SD.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    (SD.Order_No != 'C512921' Or SD.Order_No Is Null) --Kevin Stack's order/return that spanned years.
    AND 
        (
        SD.Corporate_Form Not In ('FRA','ITL','SWE','IT','BENELUX','GER','KEY') And
        SD.Salesman_Code Not In ('908','504','317') And --Removed 318 per Brian and Ilona.
        SD.Customer_NO != 'CATEMP' AND 
        SD.Salesman_Code Not In 
        (
            '210-001',
            '210-098',
            '220-160',
            '220-140',
            '220-600',
            '220-100',
            '*'
        ))
GROUP BY
    SD.Customer_No,
    SD.Part_Product_Family
HAVING
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-6) Then SD.AllAmounts Else 0 End) > 0 AND
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) <> 0
--    Round(SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) /  Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) <= .90 OR
--    Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4) <= .90

Union All
SELECT
    'LOST' As Status,
    SD.Customer_No,
    SD.Part_Product_Family,
    SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) As Rolling_90D,
    SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End) As Rolling_90DLY,
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-6) Then SD.AllAmounts Else 0 End) As Rolling_6M,
    SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate),-18) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End) As Rolling_6MLY,
    (Round(SUM(Case When SD.InvoiceDate >= Trunc(Sysdate)-90 Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Trunc(Sysdate)-90,-12) And Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4))*100 As "CY/LY_90D",
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) As Rolling_18M,
    SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End) as Rolling_18MLY,
    (Round(SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) / Nullif(SUM(Case When SD.InvoiceDate Between Add_Months(Add_Months(Trunc(Sysdate),-18),-12) AND Add_Months(Trunc(Sysdate),-12) Then SD.AllAmounts Else 0 End),0),4))*100 As "CY/LY_18M",
    Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) Then SD.AllAmounts Else 0 End) As CY,
    Sum(Case When Extract(Year From Sd.InvoiceDate) = Extract(Year From Sysdate)-1 Then SD.AllAmounts Else 0 End) As PY,
    Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(YEar From Sysdate)-2 Then Sd.AllAmounts Else 0 End) As PY2,
    Sum(Case When Extract(YEar From sD.InvoiceDate) = Extract(Year From Sysdate)-3 then SD.AllAmounts Else 0 End) As PY3,
    Sum(Case When Extract(Year From Sd.InvoiceDate) = Extract(Year From Sysdate)-4 Then SD.AllAmounts Else 0 End) As PY4
FROM
    KD_Sales_Data_Request SD
WHERE
    Extract(Year From SD.InvoiceDate) >= Extract(Year From Sysdate)-4 AND
    SD.Charge_Type = 'Parts' And
    SD.Corporate_Form = 'DOMDIR' And
    SD.Catalog_No != '3DBC-22001091' And
    ((SD.Order_No Not Like 'W%' And
    SD.Order_No Not Like 'X%') Or
    SD.Order_No Is Null) And
    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
    SD.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    (SD.Order_No != 'C512921' Or SD.Order_No Is Null) --Kevin Stack's order/return that spanned years.
    AND 
        (
        SD.Corporate_Form Not In ('FRA','ITL','SWE','IT','BENELUX','GER','KEY') And
        SD.Salesman_Code Not In ('908','504','317') And --Removed 318 per Brian and Ilona.
        SD.Customer_NO != 'CATEMP' AND 
        SD.Salesman_Code Not In 
        (
            '210-001',
            '210-098',
            '220-160',
            '220-140',
            '220-600',
            '220-100',
            '*'
        ))
GROUP BY
    SD.Customer_No,
    SD.Part_Product_Family
HAVING
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-6) Then SD.AllAmounts Else 0 End) <= 0 AND
    SUM(Case When SD.InvoiceDate >= Add_Months(Trunc(Sysdate),-18) Then SD.AllAmounts Else 0 End) > 0