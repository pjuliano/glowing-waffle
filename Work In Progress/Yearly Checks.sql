Select
    Person_Info_Api.Get_Name(Salesman_Code),
    Extract(Year From A.InvoiceDate) as Year,
    Sum(A.Total),
    Count(A.Invoice_ID)
From
    KD_Boomi_Invoice_Headers A
Where
    Extract(Year From InvoiceDate) = 2019
Group By
    Person_Info_Api.Get_Name(Salesman_Code),
    Extract(Year From A.InvoiceDate)
Order by
    Person_Info_Api.Get_Name(Salesman_Code),
    Extract(Year From A.InvoiceDate);
    
    Select * From KD_SvQ