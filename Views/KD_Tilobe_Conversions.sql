Create Or Replace View KD_TILOBE_CONVERSIONS As
Select
  A.Salesman_Code,
  Person_Info_Api.Get_Name(A.Salesman_Code) As Salesman_Name,
  A.Customer_NO,
  A.Customer_Name,
  Sum(Case
        When
          Extract(Year From A.Invoicedate) In (Extract(Year From Sysdate) - 2,Extract(Year From Sysdate) -1) And
          A.Part_Product_Family In ('TRINX','OCT','EXHEX')
        Then
          A.Allamounts
        Else
          0
      End) As P2y_Trilobe_Sales,
  Sum(Case
        When
          Extract (Year From A.Invoicedate) = Extract(Year From Sysdate) And
          A.Part_Product_Family In ('PRIMA','GNSIS')
        Then
          A.Allamounts
        Else
          0
      End) As Cy_Tilobe_Sales,
  Sum(Case
        When
          Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
          A.Part_Product_Family In ('PRIMA','GNSIS') And
          A.PArt_Product_Code = 'IMPL'
        Then
          A.Allamounts
        Else
          0
      End) As Cy_Tilobe_Impl_Sales,
  Case
    When
      Sum(Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
              Extract(Month From A.InvoiceDate) In (1,2,3) And
              A.Part_Product_Family In ('PRIMA','GNSIS')
            Then
              A.Allamounts
            Else
              0
          End) >= 5000 And
      Sum(Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
              Extract(Month From A.InvoiceDate) In (1,2,3) And
              A.Part_Product_Family In ('PRIMA','GNSIS') And
              A.PArt_Product_Code = 'IMPL'
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
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
              Extract(Month From A.InvoiceDate) In (1,2,3,4,5,6) And
              A.Part_Product_Family In ('PRIMA','GNSIS')
            Then
              A.Allamounts
            Else
              0
          End) >= 5000 And
      Sum(Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
              Extract(Month From A.InvoiceDate) In (1,2,3,4,5,6) And
              A.Part_Product_Family In ('PRIMA','GNSIS') And
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
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
              Extract(Month From A.InvoiceDate) In (1,2,3,4,5,6,7,8,9) And
              A.Part_Product_Family In ('PRIMA','GNSIS')
            Then
              A.Allamounts
            Else
              0
          End) >= 5000 And
      Sum(Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
              Extract(Month From A.InvoiceDate) In (1,2,3,4,5,6,7,8,9) And
              A.Part_Product_Family In ('PRIMA','GNSIS') And
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
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
              A.Part_Product_Family In ('PRIMA','GNSIS')
            Then
              A.Allamounts
            Else
              0
          End) >= 5000 And
      Sum(Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
              A.Part_Product_Family In ('PRIMA','GNSIS') And
              A.Part_Product_Code = 'IMPL'
            Then
              A.Allamounts
            Else
              0
          End) >= 3750
    Then
      'QTR4'
  End As QTR
From
  Kd_Sales_Data_Request A
Group By
  A.Salesman_Code,
  Person_Info_Api.Get_Name(A.Salesman_Code),
  A.Customer_No,
  A.Customer_Name
Having
  Sum(Case
        When
          Extract(Year From A.Invoicedate) In (Extract(Year From Sysdate) - 2,Extract(Year From Sysdate) -1) And
          A.Part_Product_Family In ('TRINX','OCT','EXHEX')
        Then
          A.Allamounts
        Else
          0
      End) >= 5000 And
  Sum(Case
        When
          Extract (Year From A.Invoicedate) = Extract(Year From Sysdate) And
          A.Part_Product_Family In ('PRIMA','GNSIS')
        Then
          A.Allamounts
        Else
          0
      End) >= 5000 And
  Sum(Case
        When
          Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
          A.Part_Product_Family In ('PRIMA','GNSIS') And
          A.PArt_Product_Code = 'IMPL'
        Then
          A.Allamounts
        Else
          0
      End) >= 3750;