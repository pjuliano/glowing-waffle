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
          --Begin Change 03172017
          --Show 80% of commission for reps with a JR rep
          --Round((A.Allamounts * 0.0975) * .5,2)
          Round((A.Allamounts * 0.0975) * .5,2) * (Decode((Select Count(1) From Kd_Jr_Rep_Assignments Z Where A.Salesman_Code = Z.Rep_Assignment),1,.8,1))
          --End Change 03172017
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
          --Begin Change 03172017
          --Show 80% of commiossion for reps with a JR rep.
          --Round((A.Allamounts * 0.06) * .5,2)
          Round((A.Allamounts * 0.06) * .5,2) * (Decode((Select Count(1) From Kd_Jr_Rep_Assignments Z Where A.Salesman_Code = Z.Rep_Assignment),1,.8,1))
          --End Change 03172017
        Else
          0
      End) As Bio_Commission,
  Sum(Case
        When
          --Begin Change 02142017.1
          --Include records with $0 sales to show negative gross margin dollars per RMs.
          --A.Part_Product_Code != 'LIT' And
          --A.AllAmounts != 0 
          A.Part_Product_Code != 'LIT'
          --End Change 02142017.1 
        Then
          --Round((A.AllAmounts - (A.Cost * A.Invoiced_Qty)),2)
          Round((A.Allamounts - (Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty)),2) --2/22/2017: Added Decode to handle null costs.
        Else
          0
      End) As Gross_Margin,
  Sum(Case
        When
          --Begin Change 02142017.2
          --Include records with $0 sales to show negative gross margin commission per RMs.
          --A.Part_Product_Code != 'LIT' And
          --A.AllAmounts != 0
          A.Part_Product_Code != 'LIT'
          --End Change 02142017.02
        Then
          --Begin Change 02072017
          --Commission percent increase per Kevin Munroe.
          --Round(((A.AllAmounts - (A.Cost * A.Invoiced_Qty) * .141) * .5,2)
          --End Change 02072017
          --Begin Change 02222017
          --Added decode to handle null value costs.
          --Round(((A.AllAmounts - (A.Cost * A.Invoiced_Qty) * .146) * .5,2)
            --Begin Change 03172017
            --Show 80% of commission for reps with a JR rep.
            --Round(((A.Allamounts - (Decode(A.Cost,Null,0,A.Cost)
          Round(((A.Allamounts - (Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty)) * .146) * .5,2) *(Decode((Select Count(1) From Kd_Jr_Rep_Assignments Z Where A.Salesman_Code = Z.Rep_Assignment),1,.8,1))
            --End Change 03172017
          --End Change 02222017
        Else
          0
      End) As Gross_Margin_Commission
From
  Kd_Sales_Data_Request A,
  Person_Info B,
  Srrepquota C
Where
  A.Salesman_Code = B.Person_Id And
  --Begin Change 03202017
  --Exclude accounts that only receive free product per Kevin Munroe.
  A.Customer_No Not In ('A86088','A35173') And
  --End Change 03202017
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  ((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or A.Order_No Is Null) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Salesman_Code = C.Repnumber
Group By
  A.Salesman_Code,
  B.Name,
  C.Region,
  A.Customer_No,
  A.Customer_Name,
  A.Invoicedate,
  A.Order_No
Union All
--This section calculates commissions for junior reps.
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
          --Begin Change 03172017
          --Show 80% of commission for reps with a JR rep.
          --Round((A.Allamounts * 0.0975) * .5,2)
          Round((A.Allamounts * 0.0975) * .5,2) * (Decode((Select Count(1) From Kd_Jr_Rep_Assignments Z Where A.Salesman_Code = Z.Rep_Assignment),1,.2,1))
          --End Change 03172017
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
          --Begin Change 03172017
          --Show 80% of commiossion for reps with a JR rep.
          --Round((A.Allamounts * 0.06) * .5,2)
          Round((A.Allamounts * 0.06) * .5,2) * (Decode((Select Count(1) From Kd_Jr_Rep_Assignments Z Where A.Salesman_Code = Z.Rep_Assignment),1,.2,1))
          --End Change 03172017
        Else
          0
      End) As Bio_Commission,
  Sum(Case
        When
          --Begin Change 02142017.1
          --Include records with $0 sales to show negative gross margin dollars per RMs.
          --A.Part_Product_Code != 'LIT' And
          --A.AllAmounts != 0 
          A.Part_Product_Code != 'LIT'
          --End Change 02142017.1 
        Then
          --Round((A.AllAmounts - (A.Cost * A.Invoiced_Qty)),2)
          Round((A.Allamounts - (Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty)),2) --2/22/2017: Added Decode to handle null costs.
        Else
          0
      End) As Gross_Margin,
  Sum(Case
        When
          --Begin Change 02142017.2
          --Include records with $0 sales to show negative gross margin commission per RMs.
          --A.Part_Product_Code != 'LIT' And
          --A.AllAmounts != 0
          A.Part_Product_Code != 'LIT'
          --End Change 02142017.02
        Then
          --Begin Change 02072017
          --Commission percent increase per Kevin Munroe.
          --Round(((A.AllAmounts - (A.Cost * A.Invoiced_Qty) * .141) * .5,2)
          --End Change 02072017
          --Begin Change 02222017
          --Added decode to handle null value costs.
          --Round(((A.AllAmounts - (A.Cost * A.Invoiced_Qty) * .146) * .5,2)
            --Begin Change 03172017
            --Show 80% of commission for reps with a JR rep.
            --Round(((A.Allamounts - (Decode(A.Cost,Null,0,A.Cost)
          Round(((A.Allamounts - (Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty)) * .146) * .5,2) * (Decode((Select Count(1) From Kd_Jr_Rep_Assignments Z Where A.Salesman_Code = Z.Rep_Assignment),1,.2,1))
            --End Change 03172017
          --End Change 02222017
        Else
          0
      End) As Gross_Margin_Commission
From
  Kd_Sales_Data_Request A,
  Kd_Jr_Rep_Assignments B,
  Srrepquota C
Where
  A.Salesman_Code = B.Rep_Assignment And
  --Begin Change 03202017
  --Exclude accounts that only receive free product per Kevin Munroe.
  A.Customer_No Not In ('A86088','A35173') And
  --End Change 03202017
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  ((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or A.Order_No Is Null) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Salesman_Code = C.Repnumber
Group By
  B.Person_ID,
  B.Name,
  C.Region,
  A.Customer_No,
  A.Customer_Name,
  A.Invoicedate,
  A.Order_No;