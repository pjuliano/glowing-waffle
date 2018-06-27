Select 
   A.Commission_Receiver,
   A.Customer_No,
   Customer_Info_Api.Get_Name(A.Customer_No) As Name,
   Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_No) As Salesman_Code,
   B.Is_Rep_Id
From 
  Cust_Def_Com_Receiver A,
  Kd_Inside_Rep_Assignments B
Where
  Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_No) = B.Rep_Id And
  A.Commission_Receiver != B.Is_Rep_Id;

Select * From Kd_Inside_Rep_Assignments