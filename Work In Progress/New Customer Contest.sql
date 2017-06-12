Select
  A.Salesman_Code,
  C.Name As Salesman_Name,
  B.Customer_Id,
  B.Name,
  B.Creation_Date,
  Sum(Case When A.Invoicedate Between 
                  To_Date('09/30/' || To_Char(Extract(Year From Sysdate)-2),'MM/DD/YYYY') And 
                  To_Date('12/31/' || To_Char(Extract(Year From Sysdate)-1),'MM/DD/YYYY')
           Then A.Allamounts
           Else 0
      End) As Prior_Year_Sales,
  Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Current_Year_Sales,
  Case When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                      Then A.Allamounts
                      Else 0
                 End) >= 5000) And
            (Round
            ((Sum(Case When Extract(Month From A.Invoicedate) In (1,2,3) And
                            Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                            A.Part_Product_Code != 'LIT' And
                            A.Customer_No Not In ('A86088','A35173') And
                            ((A.Order_No Not Like 'W%' And 
                            A.Order_No Not Like 'X%') Or
                            A.Order_No Is Null) And
                            (A.Market_Code != 'PREPOST' 
                            Or A.Market_Code Is Null)
                       Then A.Allamounts
                       Else 0
                  End) -
               Sum(Case When Extract(Month From A.Invoicedate) In (1,2,3) And
                            Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                            A.Part_Product_Code != 'LIT' And
                            A.Customer_No Not In ('A86088','A35173') And
                            ((A.Order_No Not Like 'W%' And 
                            A.Order_No Not Like 'X%') Or
                            A.Order_No Is Null) And
                            (A.Market_Code != 'PREPOST' 
                            Or A.Market_Code Is Null)
                       Then Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty
                       Else 0
                   End)) / 
               Decode(Sum(Case When Extract(Month From A.Invoicedate) In (1,2,3) And
                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                    A.Part_Product_Code != 'LIT' And
                                    A.Customer_No Not In ('A86088','A35173') And
                                    ((A.Order_No Not Like 'W%' And 
                                    A.Order_No Not Like 'X%') Or
                                    A.Order_No Is Null) And
                                    (A.Market_Code != 'PREPOST' 
                                    Or A.Market_Code Is Null)
                               Then A.Allamounts
                               Else 0
                          End),0,Null,Sum(Case When Extract(Month From A.Invoicedate) In (1,2,3) And
                                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                                    A.Part_Product_Code != 'LIT' And
                                                    A.Customer_No Not In ('A86088','A35173') And
                                                    ((A.Order_No Not Like 'W%' And 
                                                    A.Order_No Not Like 'X%') Or
                                                    A.Order_No Is Null) And
                                                    (A.Market_Code != 'PREPOST' 
                                                    Or A.Market_Code Is Null)
                                               Then A.Allamounts
                                               Else 0
                                          End)),2)) * 100 >= 50
    Then 'QTR1'
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                      Then A.Allamounts
                      Else 0
                 End) >= 5000) And
            (Round
            ((Sum(Case When Extract(Month From A.Invoicedate) In (4,5,6) And
                            Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                            A.Part_Product_Code != 'LIT' And
                            A.Customer_No Not In ('A86088','A35173') And
                            ((A.Order_No Not Like 'W%' And 
                            A.Order_No Not Like 'X%') Or
                            A.Order_No Is Null) And
                            (A.Market_Code != 'PREPOST' 
                            Or A.Market_Code Is Null)
                       Then A.Allamounts
                       Else 0
                  End) -
               Sum(Case When Extract(Month From A.Invoicedate) In (4,5,6) And
                             Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                             A.Part_Product_Code != 'LIT' And
                             A.Customer_No Not In ('A86088','A35173') And
                             ((A.Order_No Not Like 'W%' And 
                             A.Order_No Not Like 'X%') Or
                             A.Order_No Is Null) And
                             (A.Market_Code != 'PREPOST' 
                             Or A.Market_Code Is Null)
                       Then Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty
                       Else 0
                   End)) / 
               Decode(Sum(Case When Extract(Month From A.Invoicedate) In (4,5,6) And
                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                    A.Part_Product_Code != 'LIT' And
                                    A.Customer_No Not In ('A86088','A35173') And
                                    ((A.Order_No Not Like 'W%' And 
                                    A.Order_No Not Like 'X%') Or
                                    A.Order_No Is Null) And
                                    (A.Market_Code != 'PREPOST' 
                                    Or A.Market_Code Is Null)
                               Then A.Allamounts
                               Else 0
                          End),0,Null,Sum(Case When Extract(Month From A.Invoicedate) In (4,5,6) And
                                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                                    A.Part_Product_Code != 'LIT'
                                               Then A.Allamounts
                                               Else 0
                                          End)),2)) * 100 >= 50
    Then 'QTR2'
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                      Then A.Allamounts
                      Else 0
                 End) >= 5000) And
            (Round
            ((Sum(Case When Extract(Month From A.Invoicedate) In (7,8,9) And
                            Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                            A.Part_Product_Code != 'LIT' And
                            A.Customer_No Not In ('A86088','A35173') And
                            ((A.Order_No Not Like 'W%' And 
                            A.Order_No Not Like 'X%') Or
                            A.Order_No Is Null) And
                            (A.Market_Code != 'PREPOST' 
                            Or A.Market_Code Is Null)
                       Then A.Allamounts
                       Else 0
                  End) -
               Sum(Case When Extract(Month From A.Invoicedate) In (7,8,9) And
                             Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                             A.Part_Product_Code != 'LIT' And
                             A.Customer_No Not In ('A86088','A35173') And
                             ((A.Order_No Not Like 'W%' And 
                             A.Order_No Not Like 'X%') Or
                             A.Order_No Is Null) And
                             (A.Market_Code != 'PREPOST' 
                             Or A.Market_Code Is Null)
                       Then Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty
                       Else 0
                   End)) / 
               Decode(Sum(Case When Extract(Month From A.Invoicedate) In (7,8,9) And
                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                    A.Part_Product_Code != 'LIT' And
                                    A.Customer_No Not In ('A86088','A35173') And
                                    ((A.Order_No Not Like 'W%' And 
                                    A.Order_No Not Like 'X%') Or
                                    A.Order_No Is Null) And
                                    (A.Market_Code != 'PREPOST' 
                                    Or A.Market_Code Is Null)
                               Then A.Allamounts
                               Else 0
                          End),0,Null,Sum(Case When Extract(Month From A.Invoicedate) In (7,8,9) And
                                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                                    A.Part_Product_Code != 'LIT' And
                                                    A.Customer_No Not In ('A86088','A35173') And
                                                    ((A.Order_No Not Like 'W%' And 
                                                    A.Order_No Not Like 'X%') Or
                                                    A.Order_No Is Null) And
                                                    (A.Market_Code != 'PREPOST' 
                                                    Or A.Market_Code Is Null)
                                               Then A.Allamounts
                                               Else 0
                                          End)),2)) * 100 >= 50
    Then 'QTR3'
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                      Then A.Allamounts
                      Else 0
                 End) >= 5000) And
            (Round
            ((Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) And
                            Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                            A.Part_Product_Code != 'LIT' And
                            A.Customer_No Not In ('A86088','A35173') And
                            ((A.Order_No Not Like 'W%' And 
                            A.Order_No Not Like 'X%') Or
                            A.Order_No Is Null) And
                            (A.Market_Code != 'PREPOST' 
                            Or A.Market_Code Is Null)
                       Then A.Allamounts
                       Else 0
                  End) -
               Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) And
                             Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                             A.Part_Product_Code != 'LIT' And
                             A.Customer_No Not In ('A86088','A35173') And
                             ((A.Order_No Not Like 'W%' And 
                             A.Order_No Not Like 'X%') Or
                             A.Order_No Is Null) And
                             (A.Market_Code != 'PREPOST' 
                             Or A.Market_Code Is Null)
                       Then Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty
                       Else 0
                   End)) / 
               Decode(Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) And
                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                    A.Part_Product_Code != 'LIT' And
                                    A.Customer_No Not In ('A86088','A35173') And
                                    ((A.Order_No Not Like 'W%' And 
                                    A.Order_No Not Like 'X%') Or
                                    A.Order_No Is Null) And
                                    (A.Market_Code != 'PREPOST' 
                                    Or A.Market_Code Is Null)
                               Then A.Allamounts
                               Else 0
                          End),0,Null,Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) And
                                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                                    A.Part_Product_Code != 'LIT' And
                                                    A.Customer_No Not In ('A86088','A35173') And
                                                    ((A.Order_No Not Like 'W%' And 
                                                    A.Order_No Not Like 'X%') Or
                                                    A.Order_No Is Null) And
                                                    (A.Market_Code != 'PREPOST' 
                                                    Or A.Market_Code Is Null)
                                               Then A.Allamounts
                                               Else 0
                                          End)),2)) * 100 >= 50
    Then 'QTR4'
    Else 'N/A'
  End As Qtr
From
  Customer_Info B Left Join Kd_Sales_Data_Request A
    On B.Customer_Id = A.Customer_No,
  Person_Info C
Where
  A.Salesman_Code = C.Person_Id And
  A.Charge_Type = 'Parts' And
  A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED') And
  A.Corporate_Form = 'DOMDIR'
Group By
  A.Salesman_Code,
  C.Name,
  B.Customer_Id,
  B.Name,
  B.Creation_Date
Having
  Sum(Case When A.Invoicedate Between 
                  To_Date('09/30/' || To_Char(Extract(Year From Sysdate)-2),'MM/DD/YYYY') And 
                  To_Date('12/31/' || To_Char(Extract(Year From Sysdate)-1),'MM/DD/YYYY')
           Then A.Allamounts
           Else 0
      End) < 1000 And
  Case When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                      Then A.Allamounts
                      Else 0
                 End) >= 5000) And
            (Round
            ((Sum(Case When Extract(Month From A.Invoicedate) In (1,2,3) And
                            Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                            A.Part_Product_Code != 'LIT' And
                            A.Customer_No Not In ('A86088','A35173') And
                            ((A.Order_No Not Like 'W%' And 
                            A.Order_No Not Like 'X%') Or
                            A.Order_No Is Null) And
                            (A.Market_Code != 'PREPOST' 
                            Or A.Market_Code Is Null)
                       Then A.Allamounts
                       Else 0
                  End) -
               Sum(Case When Extract(Month From A.Invoicedate) In (1,2,3) And
                            Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                            A.Part_Product_Code != 'LIT' And
                            A.Customer_No Not In ('A86088','A35173') And
                            ((A.Order_No Not Like 'W%' And 
                            A.Order_No Not Like 'X%') Or
                            A.Order_No Is Null) And
                            (A.Market_Code != 'PREPOST' 
                            Or A.Market_Code Is Null)
                       Then Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty
                       Else 0
                   End)) / 
               Decode(Sum(Case When Extract(Month From A.Invoicedate) In (1,2,3) And
                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                    A.Part_Product_Code != 'LIT' And
                                    A.Customer_No Not In ('A86088','A35173') And
                                    ((A.Order_No Not Like 'W%' And 
                                    A.Order_No Not Like 'X%') Or
                                    A.Order_No Is Null) And
                                    (A.Market_Code != 'PREPOST' 
                                    Or A.Market_Code Is Null)
                               Then A.Allamounts
                               Else 0
                          End),0,Null,Sum(Case When Extract(Month From A.Invoicedate) In (1,2,3) And
                                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                                    A.Part_Product_Code != 'LIT' And
                                                    A.Customer_No Not In ('A86088','A35173') And
                                                    ((A.Order_No Not Like 'W%' And 
                                                    A.Order_No Not Like 'X%') Or
                                                    A.Order_No Is Null) And
                                                    (A.Market_Code != 'PREPOST' 
                                                    Or A.Market_Code Is Null)
                                               Then A.Allamounts
                                               Else 0
                                          End)),2)) * 100 >= 50
    Then 'QTR1'
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                      Then A.Allamounts
                      Else 0
                 End) >= 5000) And
            (Round
            ((Sum(Case When Extract(Month From A.Invoicedate) In (4,5,6) And
                            Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                            A.Part_Product_Code != 'LIT' And
                            A.Customer_No Not In ('A86088','A35173') And
                            ((A.Order_No Not Like 'W%' And 
                            A.Order_No Not Like 'X%') Or
                            A.Order_No Is Null) And
                            (A.Market_Code != 'PREPOST' 
                            Or A.Market_Code Is Null)
                       Then A.Allamounts
                       Else 0
                  End) -
               Sum(Case When Extract(Month From A.Invoicedate) In (4,5,6) And
                             Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                             A.Part_Product_Code != 'LIT' And
                             A.Customer_No Not In ('A86088','A35173') And
                             ((A.Order_No Not Like 'W%' And 
                             A.Order_No Not Like 'X%') Or
                             A.Order_No Is Null) And
                             (A.Market_Code != 'PREPOST' 
                             Or A.Market_Code Is Null)
                       Then Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty
                       Else 0
                   End)) / 
               Decode(Sum(Case When Extract(Month From A.Invoicedate) In (4,5,6) And
                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                    A.Part_Product_Code != 'LIT' And
                                    A.Customer_No Not In ('A86088','A35173') And
                                    ((A.Order_No Not Like 'W%' And 
                                    A.Order_No Not Like 'X%') Or
                                    A.Order_No Is Null) And
                                    (A.Market_Code != 'PREPOST' 
                                    Or A.Market_Code Is Null)
                               Then A.Allamounts
                               Else 0
                          End),0,Null,Sum(Case When Extract(Month From A.Invoicedate) In (4,5,6) And
                                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                                    A.Part_Product_Code != 'LIT'
                                               Then A.Allamounts
                                               Else 0
                                          End)),2)) * 100 >= 50
    Then 'QTR2'
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                      Then A.Allamounts
                      Else 0
                 End) >= 5000) And
            (Round
            ((Sum(Case When Extract(Month From A.Invoicedate) In (7,8,9) And
                            Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                            A.Part_Product_Code != 'LIT' And
                            A.Customer_No Not In ('A86088','A35173') And
                            ((A.Order_No Not Like 'W%' And 
                            A.Order_No Not Like 'X%') Or
                            A.Order_No Is Null) And
                            (A.Market_Code != 'PREPOST' 
                            Or A.Market_Code Is Null)
                       Then A.Allamounts
                       Else 0
                  End) -
               Sum(Case When Extract(Month From A.Invoicedate) In (7,8,9) And
                             Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                             A.Part_Product_Code != 'LIT' And
                             A.Customer_No Not In ('A86088','A35173') And
                             ((A.Order_No Not Like 'W%' And 
                             A.Order_No Not Like 'X%') Or
                             A.Order_No Is Null) And
                             (A.Market_Code != 'PREPOST' 
                             Or A.Market_Code Is Null)
                       Then Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty
                       Else 0
                   End)) / 
               Decode(Sum(Case When Extract(Month From A.Invoicedate) In (7,8,9) And
                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                    A.Part_Product_Code != 'LIT' And
                                    A.Customer_No Not In ('A86088','A35173') And
                                    ((A.Order_No Not Like 'W%' And 
                                    A.Order_No Not Like 'X%') Or
                                    A.Order_No Is Null) And
                                    (A.Market_Code != 'PREPOST' 
                                    Or A.Market_Code Is Null)
                               Then A.Allamounts
                               Else 0
                          End),0,Null,Sum(Case When Extract(Month From A.Invoicedate) In (7,8,9) And
                                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                                    A.Part_Product_Code != 'LIT' And
                                                    A.Customer_No Not In ('A86088','A35173') And
                                                    ((A.Order_No Not Like 'W%' And 
                                                    A.Order_No Not Like 'X%') Or
                                                    A.Order_No Is Null) And
                                                    (A.Market_Code != 'PREPOST' 
                                                    Or A.Market_Code Is Null)
                                               Then A.Allamounts
                                               Else 0
                                          End)),2)) * 100 >= 50
    Then 'QTR3'
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                      Then A.Allamounts
                      Else 0
                 End) >= 5000) And
            (Round
            ((Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) And
                            Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                            A.Part_Product_Code != 'LIT' And
                            A.Customer_No Not In ('A86088','A35173') And
                            ((A.Order_No Not Like 'W%' And 
                            A.Order_No Not Like 'X%') Or
                            A.Order_No Is Null) And
                            (A.Market_Code != 'PREPOST' 
                            Or A.Market_Code Is Null)
                       Then A.Allamounts
                       Else 0
                  End) -
               Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) And
                             Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                             A.Part_Product_Code != 'LIT' And
                             A.Customer_No Not In ('A86088','A35173') And
                             ((A.Order_No Not Like 'W%' And 
                             A.Order_No Not Like 'X%') Or
                             A.Order_No Is Null) And
                             (A.Market_Code != 'PREPOST' 
                             Or A.Market_Code Is Null)
                       Then Decode(A.Cost,Null,0,A.Cost) * A.Invoiced_Qty
                       Else 0
                   End)) / 
               Decode(Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) And
                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                    A.Part_Product_Code != 'LIT' And
                                    A.Customer_No Not In ('A86088','A35173') And
                                    ((A.Order_No Not Like 'W%' And 
                                    A.Order_No Not Like 'X%') Or
                                    A.Order_No Is Null) And
                                    (A.Market_Code != 'PREPOST' 
                                    Or A.Market_Code Is Null)
                               Then A.Allamounts
                               Else 0
                          End),0,Null,Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) And
                                                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                                                    A.Part_Product_Code != 'LIT' And
                                                    A.Customer_No Not In ('A86088','A35173') And
                                                    ((A.Order_No Not Like 'W%' And 
                                                    A.Order_No Not Like 'X%') Or
                                                    A.Order_No Is Null) And
                                                    (A.Market_Code != 'PREPOST' 
                                                    Or A.Market_Code Is Null)
                                               Then A.Allamounts
                                               Else 0
                                          End)),2)) * 100 >= 50
    Then 'QTR4'
    Else 'N/A'
  End != 'N/A'