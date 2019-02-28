Create Or Replace View KD_Customer_Mix As
Select 'Lost' As Status, Count(Customer_No) As Customers, Sum(Rolling_6M) as Rolling_6M From KD_Lost Group By 'Lost'
Union All
Select 'Down', Count(Customer_No), Sum(Rolling_6M) From KD_Down Group by 'Down'
Union All
Select 'Recovered', Count(Customer_No) As Customers, Sum(Rolling_6M) From KD_Recovered Group By 'Recovered'
Union All
Select 'New', Count(Customer_No), Sum(Rolling_6M) From KD_New Group by 'New'
Union All
Select 'Current', Count(Customer_No), Sum(Rolling_6M) From KD_Current Group By 'Current';