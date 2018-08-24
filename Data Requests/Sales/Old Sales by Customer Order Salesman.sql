Select
    Customer_Order_Api.Get_Salesman_Code(A.Order_No),
    Sum(A.AllAmounts)
From
    Kd_Sales_Data_Request A
Where
    Customer_Order_Api.Get_Salesman_Code(A.Order_No) = '325' And
    Extract(Year From A.Invoicedate) = '2017' And
    A.Charge_Type = 'Parts'
Group By
    Customer_Order_Api.Get_Salesman_Code(A.Order_No);

Select
    A.Salesman_Code,
    Sum(A.AllAmounts)
From
    Kd_Sales_Data_Request A
Where
    A.Salesman_Code = '325' And
    Extract(Year From A.Invoicedate) = '2017' And
    A.Charge_Type = 'Parts'
Group By
    A.Salesman_Code