Create Or Replace Procedure Insert_Dummy_Records IS
Begin
Execute Immediate
'Insert Into KD_Sales_Data_Request (Site, InvoiceDate, CreateDate, Part_Product_Family, InvoiceMonth, InvoiceQtr, InvoiceQtrYr, InvoiceMthYr, Type_Designation, Corporate_Form, Region_Code, FixedAmounts, AllAmounts, LocalAmount, TrueLocalAmt, Vat_Dom_Amount, Source)
Select 
  ''100'' As Site,
  Sysdate As Invoicedate,
  Sysdate As Createdate,
  A.Family As Part_Product_Family,
  Case
    When
      Extract(Month From Sysdate) = 1
    Then
      ''January''
    When
      Extract(Month From Sysdate) = 2
    Then
      ''February''
    When
      Extract(Month From Sysdate) = 3
    Then
      ''March''
    When
      Extract(Month From Sysdate) = 4
    Then
      ''April''
    When
      Extract(Month From Sysdate) = 5
    Then 
      ''May''
    When
      Extract(Month From Sysdate) = 6
    Then
      ''June''
    When
      Extract(Month From Sysdate) = 7
    Then
      ''July''
    When
      Extract(Month From Sysdate) = 8
    Then
      ''August''
    When
      Extract(Month From Sysdate) = 9
    Then
      ''September''
    When
      Extract(Month From Sysdate) = 10
    Then
      ''October''
    When
      Extract(Month From Sysdate) = 11
    Then
      ''November''
    When
      Extract(Month From Sysdate) = 12
    Then
      ''December''
  End As Invoicemonth,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      ''QTR1''
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      ''QTR2''
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      ''QTR3''
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      ''QTR4''
  End As Invoiceqtr,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      ''QTR1/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      ''QTR2/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      ''QTR3/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      ''QTR4/'' || Extract(Year From Sysdate)
  End As Invoiceqtryr,
  To_Char(Sysdate,''MM/YYYY'') As Invoicemthyr,
  ''Target'' As Type_Designation,
  A.F1 As Corporate_Form,
  Null as Region_Code,
  0 As Fixedamounts,
  0 As Allamounts,
  0 As Localamount,
  0 Truelocalamt,
  0 Vat_Dom_Amt,
  ''DUM'' As Source
From
  Srfcstbyfam A
  
Union All

Select 
  ''100'' As Site,
  Sysdate As Invoicedate,
  Sysdate As Createdate,
  NULL As Part_Product_Family,
  Case
    When
      Extract(Month From Sysdate) = 1
    Then
      ''January''
    When
      Extract(Month From Sysdate) = 2
    Then
      ''February''
    When
      Extract(Month From Sysdate) = 3
    Then
      ''March''
    When
      Extract(Month From Sysdate) = 4
    Then
      ''April''
    When
      Extract(Month From Sysdate) = 5
    Then 
      ''May''
    When
      Extract(Month From Sysdate) = 6
    Then
      ''June''
    When
      Extract(Month From Sysdate) = 7
    Then
      ''July''
    When
      Extract(Month From Sysdate) = 8
    Then
      ''August''
    When
      Extract(Month From Sysdate) = 9
    Then
      ''September''
    When
      Extract(Month From Sysdate) = 10
    Then
      ''October''
    When
      Extract(Month From Sysdate) = 11
    Then
      ''November''
    When
      Extract(Month From Sysdate) = 12
    Then
      ''December''
  End As Invoicemonth,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      ''QTR1''
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      ''QTR2''
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      ''QTR3''
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      ''QTR4''
  End As Invoiceqtr,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      ''QTR1/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      ''QTR2/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      ''QTR3/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      ''QTR4/'' || Extract(Year From Sysdate)
  End As Invoiceqtryr,
  To_Char(Sysdate,''MM/YYYY'') As Invoicemthyr,
  ''Target'' As Type_Designation,
  A.F1 As Corporate_Form,
  Case
    When
      A.F1 = ''ASIA'' 
    Then
      ''ASIA''
    When
      A.F1 = ''CAN''
    Then
      ''CANA''
    When
      A.F1 = ''DOMDIS''
    Then
      ''USDI''
    When
      A.F1 = ''EUR''
    Then
      ''EURO''
    When
      A.F1 = ''LA''
    Then
      ''LATI''
  End As Region_Code,
  0 As Fixedamounts,
  0 As Allamounts,
  0 As Localamount,
  0 Truelocalamt,
  0 Vat_Dom_Amt,
  ''DUM'' As Source
From
  Srfcstnew A
Where
  A.F1 Not In (''Total'',''Grand Total'',''TotalNA'',''Freight'')';
Execute Immediate
'Insert Into KD_Sales_Data_Nightly (Site, InvoiceDate, CreateDate, Part_Product_Family, InvoiceMonth, InvoiceQtr, InvoiceQtrYr, InvoiceMthYr, Type_Designation, Corporate_Form, Region_Code, FixedAmounts, AllAmounts, LocalAmount, TrueLocalAmt, Vat_Dom_Amount, Source)
Select 
  ''100'' As Site,
  Sysdate As Invoicedate,
  Sysdate As Createdate,
  A.Family As Part_Product_Family,
  Case
    When
      Extract(Month From Sysdate) = 1
    Then
      ''January''
    When
      Extract(Month From Sysdate) = 2
    Then
      ''February''
    When
      Extract(Month From Sysdate) = 3
    Then
      ''March''
    When
      Extract(Month From Sysdate) = 4
    Then
      ''April''
    When
      Extract(Month From Sysdate) = 5
    Then 
      ''May''
    When
      Extract(Month From Sysdate) = 6
    Then
      ''June''
    When
      Extract(Month From Sysdate) = 7
    Then
      ''July''
    When
      Extract(Month From Sysdate) = 8
    Then
      ''August''
    When
      Extract(Month From Sysdate) = 9
    Then
      ''September''
    When
      Extract(Month From Sysdate) = 10
    Then
      ''October''
    When
      Extract(Month From Sysdate) = 11
    Then
      ''November''
    When
      Extract(Month From Sysdate) = 12
    Then
      ''December''
  End As Invoicemonth,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      ''QTR1''
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      ''QTR2''
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      ''QTR3''
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      ''QTR4''
  End As Invoiceqtr,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      ''QTR1/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      ''QTR2/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      ''QTR3/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      ''QTR4/'' || Extract(Year From Sysdate)
  End As Invoiceqtryr,
  To_Char(Sysdate,''MM/YYYY'') As Invoicemthyr,
  ''Target'' As Type_Designation,
  A.F1 As Corporate_Form,
  Null as Region_Code,
  0 As Fixedamounts,
  0 As Allamounts,
  0 As Localamount,
  0 Truelocalamt,
  0 Vat_Dom_Amt,
  ''DUM'' As Source
From
  Srfcstbyfam A
  
Union All

Select 
  ''100'' As Site,
  Sysdate As Invoicedate,
  Sysdate As Createdate,
  NULL As Part_Product_Family,
  Case
    When
      Extract(Month From Sysdate) = 1
    Then
      ''January''
    When
      Extract(Month From Sysdate) = 2
    Then
      ''February''
    When
      Extract(Month From Sysdate) = 3
    Then
      ''March''
    When
      Extract(Month From Sysdate) = 4
    Then
      ''April''
    When
      Extract(Month From Sysdate) = 5
    Then 
      ''May''
    When
      Extract(Month From Sysdate) = 6
    Then
      ''June''
    When
      Extract(Month From Sysdate) = 7
    Then
      ''July''
    When
      Extract(Month From Sysdate) = 8
    Then
      ''August''
    When
      Extract(Month From Sysdate) = 9
    Then
      ''September''
    When
      Extract(Month From Sysdate) = 10
    Then
      ''October''
    When
      Extract(Month From Sysdate) = 11
    Then
      ''November''
    When
      Extract(Month From Sysdate) = 12
    Then
      ''December''
  End As Invoicemonth,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      ''QTR1''
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      ''QTR2''
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      ''QTR3''
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      ''QTR4''
  End As Invoiceqtr,
  Case
    When
      Extract(Month From Sysdate) In (1,2,3)
    Then
      ''QTR1/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (4,5,6)
    Then
      ''QTR2/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (7,8,9)
    Then
      ''QTR3/'' || Extract(Year From Sysdate)
    When
      Extract(Month From Sysdate) In (10,11,12)
    Then
      ''QTR4/'' || Extract(Year From Sysdate)
  End As Invoiceqtryr,
  To_Char(Sysdate,''MM/YYYY'') As Invoicemthyr,
  ''Target'' As Type_Designation,
  A.F1 As Corporate_Form,
  Case
    When
      A.F1 = ''ASIA'' 
    Then
      ''ASIA''
    When
      A.F1 = ''CAN''
    Then
      ''CANA''
    When
      A.F1 = ''DOMDIS''
    Then
      ''USDI''
    When
      A.F1 = ''EUR''
    Then
      ''EURO''
    When
      A.F1 = ''LA''
    Then
      ''LATI''
  End As Region_Code,
  0 As Fixedamounts,
  0 As Allamounts,
  0 As Localamount,
  0 Truelocalamt,
  0 Vat_Dom_Amt,
  ''DUM'' As Source
From
  Srfcstnew A
Where
  A.F1 Not In (''Total'',''Grand Total'',''TotalNA'',''Freight'')';
End Insert_Dummy_Records;