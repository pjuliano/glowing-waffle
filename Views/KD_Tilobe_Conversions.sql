Create Or Replace View KD_Tilobe_Conversions As 
Select
  A.Salesman_Code,
  B.Name As Salesman_Name,
  A.Customer_No,
  A.Customer_Name,
  Sum(Case When A.Invoicedate Between
                To_Date('09/30/' || To_Char(Extract(Year From Sysdate)-2),'MM/DD/YYYY') And
                To_Date('12/31/' || To_Char(Extract(Year From Sysdate)-1),'MM/DD/YYYY') And
                A.Part_Product_Family In ('TRINX','OCT','EXHEX')
           Then A.Allamounts
           Else 0
      End) As P2y_Trilobe_Sales,
  Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                A.Part_Product_Family In ('PRIMA','GNSIS')
           Then A.Allamounts
           Else 0
      End) As Cy_Tilobe_Sales,
    Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                A.Part_Product_Family In ('PRIMA','GNSIS') And
                A.Part_Product_Code = 'IMPL'
           Then A.Allamounts
           Else 0
      End) As Cy_Tilobe_IMPL_Sales,
  Case When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                           A.Part_Product_Family In ('PRIMA','GNSIS')
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
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                        A.Part_Product_Family In ('PRIMA','GNSIS')
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
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                        A.Part_Product_Family In ('PRIMA','GNSIS')
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
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                        A.Part_Product_Family In ('PRIMA','GNSIS')
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
  Kd_Sales_Data_Request A,
  Person_Info B
Where
  A.Salesman_Code = B.Person_Id And
  A.Charge_Type = 'Parts' And
  A.Catalog_No Not Like 'LODI%'
Having
  Case When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                           A.Part_Product_Family In ('PRIMA','GNSIS')
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
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                        A.Part_Product_Family In ('PRIMA','GNSIS')
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
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                        A.Part_Product_Family In ('PRIMA','GNSIS')
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
    When (Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                        A.Part_Product_Family In ('PRIMA','GNSIS')
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
  End != 'N/A' And
  Sum(Case When A.Invoicedate Between
                To_Date('09/30/' || To_Char(Extract(Year From Sysdate)-2),'MM/DD/YYYY') And
                To_Date('12/31/' || To_Char(Extract(Year From Sysdate)-1),'MM/DD/YYYY') And
                A.Part_Product_Family In ('TRINX','OCT','EXHEX')
           Then A.Allamounts
           Else 0
      End) >= 5000
Group By
  A.Salesman_Code,
  B.Name,
  A.Customer_No,
  A.Customer_Name