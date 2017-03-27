Create Or Replace View KD_New_Customers As
Select
    A.Salesman_Code,
    C.Name As Salesman_Name,
    B.Customer_Id,
    B.Name,
    B.Creation_Date,
    Sum(Case 
          When
            Extract (Year From A.InvoiceDate) = Extract(Year From Sysdate) -1
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
          Extract (Year From A.InvoiceDate) = Extract(Year From Sysdate) -1
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