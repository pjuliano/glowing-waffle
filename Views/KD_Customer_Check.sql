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
SELECT 
                c.customer_id,
                'Address ' || f.address_id || ' should have a region code of ' || coalesce(e.region,'?') || '.'
FROM 
                ifsapp.customer_info c
                LEFT JOIN ifsapp.cust_ord_customer_ent d
                    ON c.customer_id = d.customer_id
                LEFT JOIN ifsapp.srrepquota e
                    ON d.salesman_code = e.repnumber
                LEFT JOIN ifsapp.cust_ord_customer_address_ent f
                    ON c.customer_id = f.customer_id
WHERE
                (e.region != f.region_code OR f.region_code IS NULL) AND
                d.salesman_code != '999' AND
                customer_info_address_api.is_valid(c.customer_id,f.address_id) = 'TRUE' AND
                c.corporate_form = 'DOMDIR'

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
  I.Customer_Id Not In ('A27982','8563','D34057','A35979','1306','D44059',
'A35515',
'A46437',
'15606',
'A26924',
'15836',
'6958',
'A76355',
'7756',
'4393',
'A23551',
'17941',
'A48357',
'15499',
'17085',
'12868',
'5494',
'A35987',
'13567',
'A35979',
'8563',
'A27982',
'3055')

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
  A.Identity Not In ('TEMPLATE','CATEMP','A35173','22008','28331','28621','29627')
  
UNION ALL

SELECT
                customer_id,
                'This customer is assigned to the KEY corporate form.'
FROM
                customer_info
WHERE
                corporate_form = 'KEY'
                    AND customer_id NOT LIKE 'R%'
                    AND UPPER(name) NOT LIKE '%KEYSTONE DENTAL%'
                    AND customer_id NOT LIKE 'N%'
                    AND customer_ID NOT IN 
                        (
                            'FR0107',
                            'IT005242',
                            'IT004877',
                            '32488',
                            'IT004838',
                            '20047',
                            'IT002310',
                            'A24232',
                            'IT005224',
                            'IT004702',
                            '20501',
                            '21257',
                            '22128',
                            '27250',
                            '28676',
                            'IT005076',
                            'DE33320',
                            '5201',
                            '28721',
                            'IT005089',
                            'DE33371',
                            'DE33332',
                            '29779',
                            'FR0102',
                            'SE1124',
                            '4898',
                            '3503',
                            '2990',
                            'IT002160',
                            'FR0003SP',
                            'FR0004SP',
                            'FR0011SP',
                            'FR0009SP',
                            'IT003219',
                            'DE33360',
                            'DE33335',
                            'DE33325',
                            'DE33366',
                            'IT005220',
                            'IT002311',
                            'FR0010SP',
                            'FR0012SP',
                            'FR0002SP',
                            'FR0008SP',
                            'FR0005SP',
                            'IT002347',
                            '30392',
                            'IT005419',
                            'DE67899',
                            'IT003043',
                            'IT004708',
                            'DE35078',
                            'DE33333',
                            'DE33361',
                            'IT005048',
                            'IT004152',
                            'DE33369',
                            '16939',
                            '30134',
                            'DE33321',
                            'IT003475',
                            'DE33370',
                            'DE33300',
                            'DE33306',
                            'DE35012',
                            'IT003237',
                            'IT005200',
                            '4610',
                            '6073',
                            '16763',
                            'B2747',
                            '14224',
                            'IT003687',
                            '8773',
                            '14276',
                            '12032',
                            '14925',
                            'B2802',
                            '14291',
                            '14661',
                            'B2783',
                            '6223',
                            '18638',
                            'D49851',
                            '4958',
                            '30345',
                            'D47986',
                            'A13681',
                            'DE35033',
                            'DE11218',
                            '5256',
                            'B2743',
                            '40000',
                            'IT005199',
                            'D47987',
                            '21875',
                            '21874',
                            'B3081',
                            'A12032',
                            '32015',
                            '2872',
                            'A25206',
                            '5399'
                        )
UNION ALL
SELECT
                customer_id,
                'Customer has no default delivery address or the default address has expired.'
FROM
                kd_customers
WHERE
                deliv_address_id IS NULL   
                    AND corporate_form = 'DOMDIR'   
UNION ALL 
SELECT
                customer_id,
                'Customer has no default billing address or the default address has expired.'
FROM
                kd_customers
WHERE
                address_id IS NULL   
                    AND corporate_form = 'DOMDIR';