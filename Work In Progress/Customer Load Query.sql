With Sales As (
  Select
    B.Customer_No,
    Decode(Sum(B.Allamounts),Null,0,Sum(B.Allamounts)) As CySales,
    Decode(Sum(Case When B.Part_Product_Code = 'IMPL'
                    Then B.Allamounts
                    Else 0
               End),Null,0,
           Sum(Case When B.Part_Product_Code = 'IMPL'
                    Then B.Allamounts
                    Else 0
               End)) As Cyimpl,
    Decode(Sum(Case When B.Part_Product_Code = 'REGEN'
                    Then B.Allamounts
                    Else 0
               End),Null,0,
           Sum(Case When B.Part_Product_Code = 'REGEN'
                    Then B.Allamounts
                    Else 0
               End)) As Cybio
  From  
      Kd_Sales_Data_Request B
  Where
    Extract(Year From B.Invoicedate) = Extract(Year From Sysdate) And
    B.Charge_Type = 'Parts' And
    B.Corporate_Form In ('DOMDIR','LATAM')
  Group By
    B.Customer_No
  Order By
    B.Customer_No)

Select
  A.Customer_Id,
  A.Name,
  B.Address_Id,
  C.Address_Type_Code_Db,
  Decode(Length(B.Address2),Null,B.Address1,B.Address1 || ' ' || B.Address2) As Address,
  B.City,
  B.State,
  B.Zip_Code,
  B.Country,
  D.Address_Id As Deliv_Address_Id,
  E.Address_Type_Code_Db As Deliv_Address_Type_Code,
  Decode(Length(D.Address2),Null,D.Address1,D.Address1 || ' ' || D.Address2) As DelivAddress,
  D.City As Delivcity,
  D.State As Delivstate,
  D.Zip_Code As Delivzipcode,
  D.Country As Delivcountry,
  F.Salesman_Code,
  A.Corporate_Form,
  A.Association_No,
  B.Primary_Contact,
  G.Pay_Term_Id,
  F.Cust_Grp,
  Case When F.Date_Del Is Null 
       Then 'FALSE'
       Else 'TRUE'
  End As Inactive,
  F.Market_Code,
  F.Order_Id,
  H.Commission_Receiver,
  A.Creation_Date,
  B.Valid_To,
  I.District_Code As Region,
  Decode(J.Cysales,Null,'0.0',J.Cysales) As Cysales,
  Decode(J.Cyimpl,Null,'0.0',J.Cyimpl) As Cyimpl,
  Decode(J.Cybio,Null,'0.0',J.CyBio) As CyBio,
  Case When K.Price_List_No Is Not Null And L.Price_List_No Is Not Null
       Then K.Price_List_No || ', ' || L.Price_List_No
       When K.Price_List_No Is Not Null And L.Price_List_No Is Null
       Then K.Price_List_No 
       When K.Price_List_No Is Null And L.Price_List_No Is Not Null
       Then L.Price_List_No 
       When K.Price_List_No Is Null And L.Price_List_No Is Null 
       Then Null
  End As Loaded_Discount
From
  Customer_Info A Left Join Cust_Def_Com_Receiver H
    On A.Customer_Id = H.Customer_No
                  Left Join Sales J
    On A.Customer_Id = J.Customer_No
                  Left Join Customer_Pricelist_Ent K
    On A.Customer_Id = K.Customer_Id And
       K.Sales_Price_Group_ID = 'TARGET'
                  Left Join Customer_Pricelist_Ent L
    On A.Customer_Id = L.Customer_Id And
       L.Sales_Price_Group_ID = 'SIMPLNT',
  Customer_Info_Address B,
  Customer_Info_Address_Type C,
  Customer_Info_Address D,
  Customer_Info_Address_Type E,
  Cust_Ord_Customer_Ent F,
  Identity_Invoice_Info G,
  Cust_Ord_Customer_Address_Ent I
Where
  A.Customer_Id = B.Customer_Id And
  B.Customer_Id = C.Customer_Id And
  B.Address_Id = C.Address_Id And
  A.Customer_Id = D.Customer_Id And
  D.Customer_Id = E.Customer_Id And
  D.Address_Id = E.Address_Id And
  A.Customer_Id = F.Customer_Id And
  A.Customer_Id = G.Identity And
  A.Customer_Id = I.Customer_Id And
  B.Address_Id = I.Address_Id And
  C.Def_Address = 'TRUE' And
  C.Address_Type_Code_Db = 'PAY' And
  E.Def_Address = 'TRUE' And
  E.Address_Type_Code_Db = 'DELIVERY'
Order By
  A.Customer_ID