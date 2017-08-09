Create or Replace View KD_SVQ_CY_MARGIN As
Select A.Salesman_Code,
  B.Region,
  Sum(A.Allamounts) As Total_Sales,
  Round(Sum(A.Invoiced_Qty * A.Cost),2) As Total_Cost,
  Round(Sum(Case
              When
                Extract(Month From A.Invoicedate) = Extract(Month From Sysdate)
              Then
                A.Invoiced_Qty * A.Cost
              End),2) As MTD_Cost,
  Round((Sum(Case
              When
                Extract(Month From A.Invoicedate) = Extract(Month From Sysdate)
              Then
                A.Allamounts
              End) - 
        Sum(Case
              When
                Extract(Month From A.Invoicedate) = Extract(Month From Sysdate)
              Then
                A.Invoiced_Qty * A.Cost
              End)) / 
          NullIf(
          Sum(Case
              When
                Extract(Month From A.Invoicedate) = Extract(Month From Sysdate)
              Then
                A.Allamounts
              End),0) * 100,2) As Mtd_Margin,
  Round((Sum(A.Allamounts) - Sum(A.Invoiced_Qty * A.Cost)) / NullIf(Sum(A.Allamounts),0) * 100,2) As Cy_Margin
From 
  Kd_Sales_Data_Request A Left Join Srrepquota B
    On A.Salesman_Code   = B.Repnumber
Where 
  A.Charge_Type  = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null)
Group By A.Salesman_Code,
  B.Region;