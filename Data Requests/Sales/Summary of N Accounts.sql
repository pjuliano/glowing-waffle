Select
    A.Association_No,
    A.Customer_No,
    A.Customer_Name,
    A.Region_Code,
    A.Salesman_Code,
    Person_Info_Api.Get_Name(A.Salesman_Code) as Salesman_Name,
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate) Then A.AllAmounts Else 0 End) As CY,
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)-1 Then A.AllAmounts Else 0 End) As PY,
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)-2 Then A.AllAmounts Else 0 End) As PY2
From
    KD_Sales_Data_Request A
Where
    A.Association_No Like 'N%' And
    Extract(Year From A.InvoiceDate) >= Extract(Year From Sysdate)-2 And
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
    ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
    (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096'
Group By
    A.Association_No,
    A.Customer_No,
    A.Customer_Name,
    A.Region_Code,
    A.Salesman_Code,
    Person_Info_Api.Get_Name(A.Salesman_Code)
Order By
    A.Association_No,
    A.Salesman_Code,
    A.Customer_No