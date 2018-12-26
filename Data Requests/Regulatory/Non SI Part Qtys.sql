Select
    Extract(Year From A.InvoiceDate) As Year,
    NVL(A.Delivcountry,A.Invoicecountry) As Country,
    A.Catalog_No,
    A.Catalog_Desc,
    Sum(A.Invoiced_Qty) As Total_Invoiced_Qty
From
    KD_Sales_Data_Request A
Where
    Extract(Year From A.InvoiceDate) >= Extract(Year From Sysdate)-2 And
    Sales_Part_Api.Get_Sales_Price_Group_ID(A.Site,A.Catalog_No) != 'SIMPLNT' And
    Order_No Not Like 'R%'
Group By
    Extract(Year From A.InvoiceDate),
    NVL(A.Delivcountry,A.Invoicecountry),
    A.Catalog_No,
    A.Catalog_Desc
Order By
    Extract(Year From A.InvoiceDate) Asc,
    NVL(A.Delivcountry,A.Invoicecountry) Asc