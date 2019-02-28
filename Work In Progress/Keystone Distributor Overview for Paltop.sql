SELECT
    Corporate_Form,
    Delivcountry,
    Customer_No,
    Customer_Name,
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-3 And
                  Part_Product_Code = 'REGEN'
             Then AllAmounts
             Else 0
        End) As PY3_Regen,
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-2 And
                  Part_Product_Code = 'REGEN'
             Then AllAmounts
             Else 0
        End) As PY2_Regen,
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-1 And
                  Part_Product_Code = 'REGEN'
             Then AllAmounts
             Else 0
        End) As PY1_Regen,
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate) And
                  Part_Product_Code = 'REGEN'
             Then AllAmounts
             Else 0
        End) As CY_Regen,
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-3 And
                  Part_Product_Code != 'REGEN'
             Then AllAmounts
             Else 0
        End) As PY3_IMPL,
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-2 And
                  Part_Product_Code != 'REGEN'
             Then AllAmounts
             Else 0
        End) As PY2_IMPL,
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-1 And
                  Part_Product_Code != 'REGEN'
             Then AllAmounts
             Else 0
        End) As PY1_IMPL,
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate) And
                  Part_Product_Code != 'REGEN'
             Then AllAmounts
             Else 0
        End) As CY_IMPL
FROM
    Kd_Sales_Data_Request
WHERE
    Extract(Year From InvoiceDate) >= Extract(Year From Sysdate)-3 And
    Corporate_Form Not In ('DOMDIR','DOMDIS','ITL','BENELUX','SWE','GER','FRA','KEY','CAN') And
    Charge_Type = 'Parts' And
    DelivCountry != ' '
GROUP BY
    Corporate_Form,
    Delivcountry,
    Customer_No,
    Customer_Name
ORDER BY
    Corporate_Form,
    DelivCountry