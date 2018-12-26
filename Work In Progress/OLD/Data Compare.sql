Delete
From
    Kd_Sales_Data_Request A
Where
    A.Corporate_Form = 'DOMDIR' And
    Extract(Year From A.InvoiceDate) = 2009