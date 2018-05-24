Select 
  A.Rma_No,
  B.Customer_No,
  Customer_Info_Api.Get_Name(B.Customer_No) As Customer_Name,
  A.Catalog_No,
  A.Catalog_Desc,
  A.Order_No,
  Customer_Order_Api.Get_Date_Entered(A.Order_No) As Order_Date_Entered,
  A.Qty_To_Return,
  A.Sale_Unit_Price * A.Qty_To_Return As Net_Amount,
  Person_Info_Api.Get_Name(Cust_Ord_Customer_Api.Get_Salesman_Code(B.Customer_No)) As Salesman,
  Return_Material_Reason_Api.Get_Return_Reason_Description(A.Return_Reason_Code) As Return_Reason
From 
  Ifsapp.Return_Material B,
  Ifsapp.Return_Material_Line A 
Where 
  A.Rma_No = B.Rma_No And
  A.State = 'Planned' And
  Cust_Ord_Customer_Api.Get_Salesman_Code(B.Customer_No) = '&Salesman_Code' And
  B.Date_Requested Between To_Date('&DateFrom','MM/DD/YYYY') And To_Date('&DateTo','MM/DD/YYYY')