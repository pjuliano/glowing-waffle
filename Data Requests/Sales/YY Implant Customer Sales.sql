Select 
    A.Region_Code,
    A.Salesman_Code,
    A.Customer_No,
    A.Customer_Name,
    Sum(
        Case When Extract(Year From A.Invoicedate) = 2016 And Part_Product_Code = 'IMPL'
             Then A.Allamounts
             Else 0
        End) As "2016_IMPL",
    Sum(
        Case When Extract(Year From A.Invoicedate) = 2017 And Part_Product_Code = 'IMPL' And A.InvoiceDate < Trunc(Sysdate -365)
             Then A.Allamounts
             Else 0
        End) As "YTD_2017_IMPL",
    Sum(
        Case When A.Catalog_No In ('15700K','15241K','G31001','15728K','15651K')
             Then 1
             Else 0
        End) As Kits
From
    Kd_Sales_Data_Request A
Where
    A.Corporate_Form = 'DOMDIR'
Group By
    A.Region_Code,
    A.Salesman_Code,
    A.Customer_No,
    A.Customer_Name
Having
    Sum(
        Case When Extract(Year From A.Invoicedate) = 2016 And Part_Product_Code = 'IMPL'
             Then A.Allamounts
             Else 0
        End) < 250 And
    Sum(
        Case When Extract(Year From A.Invoicedate) = 2017 And Part_Product_Code = 'IMPL' And A.InvoiceDate < Trunc(Sysdate -365)
             Then A.Allamounts
             Else 0
        End) > 250
Order By
    A.Region_Code,
    A.Salesman_Code,
    A.Customer_No