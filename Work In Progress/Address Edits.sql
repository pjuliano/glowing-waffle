With Cytotals As (
Select
    A.Customer_No,
    Sum(A.Allamounts) As CYSales
From
    Kd_Sales_Data_Request A
Where 
    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
    A.Charge_Type = 'Parts'
Group By
    A.Customer_No)

Select 
    A.Customer_Id,
    A.Address_Id,
    A.Address1,
    A.Address2,
    A.City,
    A.State,
    A.Zip_Code,
    A.County,
    A.Country,
    B.CySales
From 
    Customer_Info_Address A Left Join Cytotals B
        On A.Customer_Id = B.Customer_No
Where
    (A.Valid_To >= Trunc(Sysdate) Or
    A.Valid_To Is Null) And
    A.Country In ('UNITED STATES', 'CANADA') And
    Kd_Get_Corporate_Form(A.Customer_Id) = 'DOMDIR' And
    (Upper(A.Address2) Like 'SUITE%' Or Upper(A.Address2) Like 'STE%' Or Upper(A.Address1) Like 'SUITE%' Or Upper(A.Address1) Like 'STE%')