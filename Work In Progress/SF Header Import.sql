Select
  A.Salesman_Code As Salesman_Nbr__C,
  A.Customer_No As Customer_Nbr__C,
  Case When A.Invoice_Id Like 'CR%'
       Then ''
       Else A.Order_No
  End As Order_Nbr__C,
  'Invoiced' As Stagename,
  '012700000001SmVAAU' As Recordtypeid,
  '01s300000001AZ1AAM' As Pricebook2ID,
  A.Invoice_Id As Name,
  Null As Accountid,
  Null As Ownerid,
  Sum(A.Allamounts) As Total,
  A.Invoicedate As Invoice_Date__C,
  A.Invoicedate As Closedate,
  A.Authorize_Code As Coordinator__C,
  A.Region_Code As Region__C,
  A.Createdate As Invoice_Date_Entered__C,
  A.Corporate_Form,
  Max(A.Market_Code) As Market_Code__C,
  A.Pay_Term_Description As Payment_Terms__C,
  A.Kdreference As Authorize_Name__C,
  A.CustomerRef As Customer_Reference__c,
  Case When Instr(A.Invoice_Id,'CR') = 0
       Then B.Customer_Po_No
       Else ''
  End As Customer_Po__c,
  A.Deliverydate,
  A.Ship_Via As Ship_Via__C,
  A.Currency As Currencyisocode,
  A.Invoiceadd1 As Bill_To_Address_1__C,
  A.Invoiceadd2 As Bill_To_Address_2__C,
  A.Invoicecity As Bill_To_Address_3__C,
  A.Invoicestate As Bill_To_Address_4__C,
  A.Invoicezip As Bill_To_Address_5__C,
  A.Delivadd1 As Ship_To_Address_1__C,
  A.Delivadd2 As Ship_To_Address_2__C,
  A.Delivcity As Ship_To_Address_3__C,
  A.Delivstate As Ship_To_Address_4__C,
  A.Delivzip As Ship_To_Address_5__c

From
  Kd_Sales_Data_Request A Left Join Customer_Order B On
    A.Site = B.Contract And
    A.Customer_No = B.Customer_No And
    A.Order_No = B.Order_No,
  KD_Util C

Where
  Site = '100' And
  A.Charge_Type = 'Parts' And
  A.Salesman_Code Not In ('505','506','507','508') And
  A.Customer_No != 'B3730' And
  A.Corporate_Form != 'Freight' And
  A.Corporate_Form In ('DOMDIR','ASIA','DOMDIS') And
  A.Invoice_Id != '0' And
  A.Invoice_ID = C.Column1

Group By
A.Salesman_Code,
  A.Customer_No,
  Case When A.Invoice_Id Like 'CR%'
       Then ''
       Else A.Order_No
  End,
  'Invoiced',
  '012700000001SmVAAU',
  '01s300000001AZ1AAM',
  A.Invoice_Id,
  Null,
  Null,
  A.Invoicedate,
  A.Invoicedate,
  A.Authorize_Code,
  A.Region_Code,
  A.Createdate,
  A.Corporate_Form,
  A.Pay_Term_Description,
  A.Kdreference,
  A.CustomerRef,
  Case When Instr(A.Invoice_Id,'CR') = 0
       Then B.Customer_Po_No
       Else ''
  End,
  A.Deliverydate,
  A.Ship_Via,
  A.Currency,
  A.Invoiceadd1,
  A.Invoiceadd2,
  A.Invoicecity,
  A.Invoicestate,
  A.Invoicezip,
  A.Delivadd1,
  A.Delivadd2,
  A.Delivcity,
  A.Delivstate,
  A.Delivzip