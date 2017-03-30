--Create Or Replace View KD_New_Customers As
Select
    A.Salesman_Code,
    C.Name As Salesman_Name,
    B.Customer_Id,
    B.Name,
    B.Creation_Date,
    Sum(Case 
          When
            Extract (Year From A.Invoicedate) Between Extract(Year From Sysdate) -2 And Extract(Year From Sysdate) -1 And
            A.Part_Product_Code = 'IMPL' And
            A.Catalog_No Not In ('MAX-8-11',
                                 'MAX-9-11',
                                 'MAX-7-11',
                                 'MAX-7-7',
                                 'MAX-7-9',
                                 'MAX-8-7',
                                 'MAX-8-9',
                                 'MAX-9-7',
                                 'MAX-9-9',
                                 'MAXIT7-11',
                                 'MAXIT7-7',
                                 'MAXIT7-9',
                                 'MAXIT8-11',
                                 'MAXIT8-7',
                                 'MAXIT8-9',
                                 'MAXIT9-11',
                                 'MAXIT9-7',
                                 'MAXIT9-9',
                                 '15707K',
                                 '15705K',
                                 '15706K',
                                 '15710K',
                                 '15708K',
                                 '15709K',
                                 '15713K',
                                 '15711K',
                                 '15712K',
                                 'TRI-MAX7-11',
                                 'TRI-MAX7-7',
                                 'TRI-MAX7-9',
                                 'TRI-MAX8-11',
                                 'TRI-MAX8-7',
                                 'TRI-MAX8-9',
                                 'TRI-MAX9-11',
                                 'TRI-MAX9-7',
                                 'TRI-MAX9-9',
                                 'Z-MAX7-11',
                                 'Z-MAX7-7',
                                 'Z-MAX7-9',
                                 'Z-MAX8-11',
                                 'Z-MAX8-7',
                                 'Z-MAX8-9',
                                 'Z-MAX9-11',
                                 'Z-MAX9-7',
                                 'Z-MAX9-9')
          Then
            A.Allamounts
          Else
            0
        End) As Prior_Year_Sales,
    Sum(Case 
          When
            Extract (Year From A.InvoiceDate) = Extract(Year From Sysdate)
          Then
            A.Allamounts
          Else
            0
        End) As Current_Year_Sales,
  Case
    When
      Sum(Case
            When
              Extract(Month From A.Invoicedate) In (1,2,3) And
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
            Then
              A.Allamounts
            Else
              0
          End) >= 5000 And
      Sum(Case 
            When
              Extract(Month From A.Invoicedate) In (1,2,3) And
              Extract (Year From A.Invoicedate) = Extract(Year From Sysdate) And
              A.Part_Product_Code = 'IMPL'
            Then
              A.Allamounts
            Else
              0
          End) >= 3750
    Then
      'QTR1'
    When
      Sum(Case
            When
              Extract(Month From A.Invoicedate) In (1,2,3,4,5,6) And
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
            Then
              A.Allamounts
            Else
              0
          End) >= 5000 And
      Sum(Case 
            When
              Extract(Month From A.Invoicedate) In (1,2,3,4,5,6) And
              Extract (Year From A.Invoicedate) = Extract(Year From Sysdate) And
              A.Part_Product_Code = 'IMPL'
            Then
              A.Allamounts
            Else
              0
          End) >= 3750
    Then
      'QTR2'
    When
      Sum(Case
            When
              Extract(Month From A.Invoicedate) In (1,2,3,4,5,6,7,8,9) And
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
            Then
              A.Allamounts
            Else
              0
          End) >= 5000 And
      Sum(Case 
            When
              Extract(Month From A.Invoicedate) In (1,2,3,4,5,6,7,8,9) And
              Extract (Year From A.Invoicedate) = Extract(Year From Sysdate) And
              A.Part_Product_Code = 'IMPL'
            Then
              A.Allamounts
            Else
              0
          End) >= 3750
    Then
      'QTR3'
    When
      Sum(Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
            Then
              A.Allamounts
            Else
              0
          End) >= 5000 And
      Sum(Case 
            When
              Extract (Year From A.Invoicedate) = Extract(Year From Sysdate) And
              A.Part_Product_Code = 'IMPL'
            Then
              A.Allamounts
            Else
              0
          End) >= 3750
    Then
      'QTR4'
  End As Qtr
From
  Customer_Info B Left Join Kd_Sales_Data_Request A
    On B.Customer_Id = A.Customer_No,
  Person_Info C
Where
  A.Charge_Type = 'Parts' And
  A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED') And
  A.Corporate_Form = 'DOMDIR'  And
  A.Salesman_Code = C.Person_Id
Group By
  A.Salesman_Code,
  C.Name,
  B.Customer_Id,
  B.Name,
  B.Creation_Date
Having
  Sum(Case 
        When
          Extract (Year From A.Invoicedate) Between Extract(Year From Sysdate) -2 And Extract(Year From Sysdate) -1 And
          A.Part_Product_Code = 'IMPL' And
            A.Catalog_No Not In ('MAX-8-11',
                                 'MAX-9-11',
                                 'MAX-7-11',
                                 'MAX-7-7',
                                 'MAX-7-9',
                                 'MAX-8-7',
                                 'MAX-8-9',
                                 'MAX-9-7',
                                 'MAX-9-9',
                                 'MAXIT7-11',
                                 'MAXIT7-7',
                                 'MAXIT7-9',
                                 'MAXIT8-11',
                                 'MAXIT8-7',
                                 'MAXIT8-9',
                                 'MAXIT9-11',
                                 'MAXIT9-7',
                                 'MAXIT9-9',
                                 '15707K',
                                 '15705K',
                                 '15706K',
                                 '15710K',
                                 '15708K',
                                 '15709K',
                                 '15713K',
                                 '15711K',
                                 '15712K',
                                 'TRI-MAX7-11',
                                 'TRI-MAX7-7',
                                 'TRI-MAX7-9',
                                 'TRI-MAX8-11',
                                 'TRI-MAX8-7',
                                 'TRI-MAX8-9',
                                 'TRI-MAX9-11',
                                 'TRI-MAX9-7',
                                 'TRI-MAX9-9',
                                 'Z-MAX7-11',
                                 'Z-MAX7-7',
                                 'Z-MAX7-9',
                                 'Z-MAX8-11',
                                 'Z-MAX8-7',
                                 'Z-MAX8-9',
                                 'Z-MAX9-11',
                                 'Z-MAX9-7',
                                 'Z-MAX9-9')
        Then
          A.Allamounts
        Else
          0
      End) <= 1000 And
  Sum(Case 
        When
          Extract (Year From A.Invoicedate) = Extract(Year From Sysdate)
        Then
          A.Allamounts
        Else
          0
      End) >= 5000 And
  Sum(Case 
        When
          Extract (Year From A.Invoicedate) = Extract(Year From Sysdate) And
          A.Part_Product_Code = 'IMPL'
        Then
          A.Allamounts
        Else
          0
      End) >= 3750;