Create Or Replace View KD_Commission_Report As
Select
  A.Salesman_Code,
  B.Name As Salesman_Name,
  C.Region,
  A.Customer_No,
  A.Customer_Name,
  A.Invoicedate,
  A.Order_No,
  Sum(A.AllAmounts) As Total,
  Sum(Case
        When
          A.Part_Product_Code Not In ('LIT','REGEN')
        Then
          A.Allamounts
        Else
          0
      End) As Implant_Sales,
  Sum(Case
        When
          A.Part_Product_Code Not In ('LIT','REGEN')
        Then
          Round((A.Allamounts * 0.0975) * .5,2) * Decode(D.Jr_Rep_Pct,Null,1,1-D.Jr_Rep_Pct)
        Else
          0
      End) As Implant_Commission,
  Sum(Case
        When
          A.Part_Product_Code = 'REGEN'
        Then
          A.Allamounts
        Else
          0
      End) As Bio_Sales,
  Sum(Case
        When
          A.Part_Product_Code = 'REGEN'
        Then
          Round((A.Allamounts * 0.06) * .5,2) * Decode(D.Jr_Rep_Pct,Null,1,1-D.Jr_Rep_Pct)
        Else
          0
      End) As Bio_Commission,
  Sum(Case
        When
          A.Part_Product_Code != 'LIT'
        Then
          Round((A.Allamounts - (Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty)),2)
        Else
          0
      End) As Gross_Margin,
  Sum(Case
        When
          A.Part_Product_Code != 'LIT'
        Then
          Round(((A.Allamounts - (Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty)) * .146) * .5,2) * Decode(D.Jr_Rep_Pct,Null,1,1-D.Jr_Rep_Pct)
        Else
          0
      End) As Gross_Margin_Commission
From
  Kd_Sales_Data_Request A Left Join Kd_Jr_Rep_Assignments D
    On A.Salesman_Code = D.Rep_Assignment,
  Person_Info B,
  Srrepquota C
Where
  A.Salesman_Code = B.Person_Id And
  A.Customer_No Not In ('A86088','A35173') And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  ((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or A.Order_No Is Null) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Salesman_Code = C.Repnumber And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null)
Group By
  A.Salesman_Code,
  B.Name,
  C.Region,
  A.Customer_No,
  A.Customer_Name,
  A.Invoicedate,
  A.Order_No
Union All
Select
  B.Person_ID As Salesman_Code,
  B.Name As Salesman_Name,
  C.Region,
  A.Customer_No,
  A.Customer_Name,
  A.Invoicedate,
  A.Order_No,
  Sum(A.AllAmounts) As Total,
  Sum(Case
        When
          A.Part_Product_Code Not In ('LIT','REGEN')
        Then
          A.Allamounts
        Else
          0
      End) As Implant_Sales,
  Sum(Case
        When
          A.Part_Product_Code Not In ('LIT','REGEN')
        Then
          Round((A.Allamounts * 0.0975) * .5,2) * Decode(B.Jr_Rep_Pct,Null,1,B.Jr_Rep_Pct)
        Else
          0
      End) As Implant_Commission,
  Sum(Case
        When
          A.Part_Product_Code = 'REGEN'
        Then
          A.Allamounts
        Else
          0
      End) As Bio_Sales,
  Sum(Case
        When
          A.Part_Product_Code = 'REGEN'
        Then
          Round((A.Allamounts * 0.06) * .5,2) * Decode(B.Jr_Rep_Pct,Null,1,B.Jr_Rep_Pct)
        Else
          0
      End) As Bio_Commission,
  Sum(Case
        When
          A.Part_Product_Code != 'LIT'
        Then
          Round((A.Allamounts - (Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty)),2)
        Else
          0
      End) As Gross_Margin,
  Sum(Case
        When
          A.Part_Product_Code != 'LIT'
        Then
          Round(((A.Allamounts - (Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty)) * .146) * .5,2) * Decode(B.Jr_Rep_Pct,Null,1,B.Jr_Rep_Pct)
        Else
          0
      End) As Gross_Margin_Commission
From
  Kd_Sales_Data_Request A,
  Kd_Jr_Rep_Assignments B,
  Srrepquota C
Where
  A.Salesman_Code = B.Rep_Assignment And
  A.Customer_No Not In ('A86088','A35173') And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  ((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or A.Order_No Is Null) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Salesman_Code = C.Repnumber And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null)
Group By
  B.Person_ID,
  B.Name,
  C.Region,
  A.Customer_No,
  A.Customer_Name,
  A.Invoicedate,
  A.Order_No;