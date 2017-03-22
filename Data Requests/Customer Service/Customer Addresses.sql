Select A.Customer_Id,
       A.Name,
			 Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_Id) As "SALESMAN",
			 Person_Info_Api.Get_Name(Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_Id)) As Salesman_Name,
			 Cust_Ord_Customer_Api.Get_Cust_Grp(A.Customer_Id) As Customer_Group,
			 A.Association_No,
       Customer_Info_Address_Api.Get_Address1(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As "Delivery Address 1",
			 Customer_Info_Address_Api.Get_Address2(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As "Delivery Address 2",
       Customer_Info_Address_Api.Get_City(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As "Delivery City",
       Customer_Info_Address_Api.Get_State(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As "Delivery State",
       Customer_Info_Address_Api.Get_Zip_Code(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As "Delivery Zip",
			 Customer_Info_Address_Api.Get_Address1(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Pay')) As "Payment Address 1",
			 Customer_Info_Address_Api.Get_Address2(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Pay')) As "Payment Address 2",
       Customer_Info_Address_Api.Get_City(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Pay')) As "Payment City",
       Customer_Info_Address_Api.Get_State(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Pay')) As "Payment State",
       Customer_Info_Address_Api.Get_Zip_Code(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Pay')) As "Payment Zip",
			 Customer_Info_Comm_Method_Api.Get_Phone(A.Customer_Id) As "PHONE"
  From Customer_Info A
 Where A.Corporate_Form = 'DOMDIR'
