Create or Replace View KD_Commercial As
With Firstshipdate As (Select 
                         A.Order_No,
                         Min(A.Date_Applied) As OrigShipDate
                       From
                         Inventory_Transaction_Hist A
                       Group By
                         A.Order_No)
Select
  B.Customer_No,
  C.Customer_PO_NO,
  G.Value,
  H.Addr_1,
  H.Addr_2,
  H.Addr_3,
  H.Addr_4,
  H.Addr_5,
  D.Country_Db As Country_Code,
  D.Country As Isodescription,
  E.Intrastat_Conv_Factor,
  F.Customs_Unit_Meas,
  A.Order_No,
  A.Date_Applied,
  I.OrigShipDate,
  A.Part_No As Catalog_No,
  A.Quantity,
  Substr(E.Customs_Stat_No, 1, 4) || '.' || Substr(E.Customs_Stat_No, 5, 2) || '.' || Substr(E.Customs_Stat_No, 7, 4) As Custstatno,
  F.Description,
  A.Release_No,
  A.Sequence_No,
  Case
    When
      A.Order_No Like 'W%'
    Then
      0
    Else
      Round(((1 - (B.Discount * 0.01)) * A.Quantity * B.Sale_Unit_Price),2) 
  End As Extendedprice,
  Case
    When
      A.Date_Applied = I.Origshipdate
    Then
      (Case 
         When 
           J.Charge_Amount Is Null
         Then
           0
         Else
           J.Charge_Amount
       End)           
    Else
      0
  End As Charge_Amount,
  C.Currency_Code,
  C.Pay_Term_Id,
  A.Quantity * K.List_Price As Qtyxlist,
  A.Quantity * 0.01 As LitPrice
From
  Inventory_Transaction_Hist A Left Join Customer_Order_Line B
    On A.Order_No = B.Order_No And
       A.Release_No = B.Line_No And
       A.Sequence_No = B.Rel_No
                               Left Join Customer_Order C
    On A.Order_No = C.Order_No
                               Left Join Customer_Info_Address D
    On B.Customer_No = D.Customer_Id And
       B.Ship_Addr_No = D.Address_Id
                               Left Join Inventory_Part E
    On A.Part_No = E.Part_No And
       E.Contract = '100'
                               Left Join Customs_Statistics_Number F
    On E.Customs_Stat_No = F.Customs_Stat_No
                               Left Join Comm_Method G
    On B.Customer_No = G.Customer_Id And
       B.Ship_Addr_No = G.Address_Id And
       G.Method_Id_Db = 'PHONE' And
       G.Method_Default = 'TRUE'
                               Left Join Customer_Order_Address H
    On A.Order_No = H.Order_No
                               Left Join Firstshipdate I
    On A.Order_No = I.Order_No
                               Left Join Customer_Order_Charge J
    On A.Order_No = J.Order_No
                               Left Join Sales_Part K
    On A.Part_No = K.Part_No And
       A.Contract = K.Contract;