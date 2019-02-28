Create Or Replace Force View "IFSAPP"."KD_CUSTOMER_CHECK" ("CUSTOMER", "ISSUE") As 
--Check to see if there is an address 99.
Select 
  A.Customer_Id As "CUSTOMER",
  Case
   When B.Address_Id != '99' Then
     'Customer does not have an address 99.'
  End As "ISSUE"
From 
  Ifsapp.Customer_Info A,
  Ifsapp.Customer_Info_Address B
Where 
  A.Customer_Id = B.Customer_Id And
  Not Exists (Select 
                Address_Id
              From 
                Ifsapp.Customer_Info_Address Z
              Where 
                A.Customer_Id = Z.Customer_Id And
                Z.Address_Id = '99') And
  A.Corporate_Form = 'DOMDIR'
  
Union All
--Section 2. Check if Salesman region is correct.
Select 
  C.Customer_Id,
  'Address ' || F.Address_Id || ' should have a region code of ' || E.Region || '.'
From 
  Ifsapp.Customer_Info C,
	Ifsapp.Cust_Ord_Customer_Ent D,
	Ifsapp.Srrepquota E,
	Ifsapp.Cust_Ord_Customer_Address_Ent F
Where
  C.Customer_Id = D.Customer_Id And
  D.Salesman_Code = E.Repnumber And
  C.Customer_Id = F.Customer_Id And
  (E.Region != F.Region_Code Or F.Region_Code Is Null) And
  D.Salesman_Code != '999' And
  Customer_Info_Address_Api.Is_Valid(C.Customer_Id,F.Address_Id) = 'TRUE' And
  C.Corporate_Form = 'DOMDIR'

Union All
--Check to see if there is a non-email in the email address field.
Select 
  A.Customer_Id, '"' || A.Value || '" is not a valid email address.' As Error
  From Customer_Info_Comm_Method A
Where 
  A.Method_Id = 'E-Mail' And
  A.Customer_Id Not Like 'IT%' And
	A.Customer_Id Not Like 'DE%' And
	A.Customer_Id Not Like 'FR%' And
	A.Customer_Id Not Like 'SE%' And
  (A.Value Not Like '%_@_%.__%' Or A.Value Like '% %' Or
  A.Value Like '%<%' Or A.Value Like '%>%' Or A.Value Like '%(%' Or
  A.Value Like '%)%' Or A.Value Like '%[%' Or A.Value Like '%]%' Or
  A.Value Like '%?%' Or A.Value Like '%.___.' Or 
  A.Value LIke '%amp;%' Or A.Value Like '%@%@%' Or
  A.Value Like '#39;' Or
  A.Value Like '%:%' Or A.Value Like '%,%' Or A.Value Like '%/%' Or A.Value like '%''%') And
  A.Value Not Like '%@%.___;%@%' 

Union All
--Section 3. Check if Commission Receiver is NULL.
Select 
  G.Customer_Id,
  'Commission receiver does not exist.'
From
  Ifsapp.Customer_Info G Left Join Ifsapp.Cust_Def_Com_Receiver H 
    On G.Customer_Id = H.Customer_No
Where 
  H.Commission_Receiver Is Null And
  G.Corporate_Form = 'DOMDIR' And
  G.Customer_Id Not In ('CATEMP','TEMPLATE','5593','A29830') And
  Cust_Ord_Customer_Api.Get_Salesman_Code(G.Customer_Id) != '999' And
  Cust_Ord_Customer_Api.Get_Salesman_Code(G.Customer_ID) != '318'


Union All
--Check if Commission Receiver is correct.
Select 
  I.Customer_Id,
 'Commission receiver should be ' || K.Is_Rep_Id || '.'
From 
  Ifsapp.Customer_Info I,
	Ifsapp.Cust_Def_Com_Receiver J,
	Ifsapp.Kd_Inside_Rep_Assignments K,
	Ifsapp.Cust_Ord_Customer_Ent L
Where 
  I.Customer_Id = J.Customer_No And
  J.Customer_No = L.Customer_Id And
	K.Rep_Id = L.Salesman_Code And
	K.Is_Rep_Id != J.Commission_Receiver And
  Cust_Ord_Customer_Api.Get_Salesman_Code(I.Customer_ID) != '318' And
  I.Customer_Id Not In ('A27982','8563','D34057','A35979','1306')--('1871','A20529','12879','16833','1244','24129','12803','16849','A53502','A22850','17013','A68001','A76095','17899','6198','10990','14308','15381','A23610','D36013','5074')

Union All
--Check if someone used 317.
Select 
  M.Customer_Id,
  'Not a valid Salesman Code.'
From 
  Customer_Info M,
	Cust_Ord_Customer_Ent N
Where 
  M.Customer_Id = N.Customer_Id And
  Upper(Ifsapp.Person_Info_Api.Get_Name(N.Salesman_Code)) Like 'DO NOT%' And
	M.Customer_Id Not In ('TEMPLATE','INTL','FRTEMP','SETEMP','DETEMP','ITTEMP','BETEMP','CATEMP','UKTEMP') And
  M.Customer_Id Not Like 'DE%'
  
Union All
--Check to make sure there actually is a salesman code.
Select 
  M.Customer_Id,
  'This account has no salesman code.'
From 
  Customer_Info M,
	Cust_Ord_Customer_Ent N
Where 
  M.Customer_Id = N.Customer_Id And
  Upper(Ifsapp.Person_Info_Api.Get_Name(N.Salesman_Code)) Is Null And
	M.Customer_Id Not In ('TEMPLATE','INTL','FRTEMP','SETEMP','DETEMP','ITTEMP','BETEMP','CATEMP','UKTEMP') And
  M.Customer_Id Not Like 'DE%' And M.Customer_Id Not Like 'FR%' And M.Customer_Id Not Like 'IT%' 
  
Union All
--Check to see if there is an AR Contact on the account.
Select
  A.Identity,
  'Customer does not have an AR Contact.' As Issue
From
  Identity_Pay_Info A Left Join Identity_Invoice_Info B
    On A.Customer_Id = B.Customer_Id
                      Left Join Customer_Info C
    On A.Customer_ID = C.Customer_ID
Where
  A.Ar_Contact Is Null And
  B.Expire_Date Is Null And
  A.Company = '100' And 
  C.Corporate_Form = 'DOMDIR' And
  A.Identity Not In ('TEMPLATE','CATEMP','A35173','22008','28331','28621','29627');