Select
  A.Customer_Id,
  Customer_Info_Api.Get_Name(A.Customer_ID) As Name,
  Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_ID) As Salesman_Code,
  Cust_Ord_Customer_Address_Api.Get_Region_Code(A.Customer_ID,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Region,
  Sum(Case When Extract(Year From B.Invoicedate) = Extract(Year From Sysdate)-1
           Then B.Allamounts
           Else 0
      End) As Prior_Year_Sales,
  Sum(Case When Extract(Year From B.Invoicedate) = Extract(Year From Sysdate)
           Then B.Allamounts
           Else 0
      End) As Current_Year_Sales,
  Sum(Case When Extract(Year From B.Invoicedate) = Extract(Year From Sysdate)
           Then B.Allamounts
           Else 0
      End) -
  Sum(Case When Extract(Year From B.Invoicedate) = Extract(Year From Sysdate)-1
           Then B.Allamounts
           Else 0
      End) As Delta,  
  A.Price_List_No,
  Sales_Price_List_Api.Get_Valid_To_Date(A.Price_List_No) As Expiration_Date
From
  Customer_Pricelist_Ent A Left Join Kd_Sales_Data_Request B
    On A.Customer_ID = B.Customer_No
Where
  Extract(Year From B.Invoicedate) >= Extract(Year From Sysdate)-1 And
  B.Charge_Type = 'Parts'
Group By
  A.Customer_Id,
  Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_ID),
  Cust_Ord_Customer_Address_Api.Get_District_Code(A.Customer_ID,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')),
  A.Price_List_No
Order By
  Cust_Ord_Customer_Address_Api.Get_District_Code(A.Customer_ID,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')),
  Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_ID),
  A.Customer_ID;
  
With Latest_Price_List_Line As
  (
  Select
    A.Price_List_No,
    B.Catalog_No,
    Max(B.Valid_From_Date) As Latest_Date
  From
    Customer_Pricelist_Ent A,
    Sales_Price_List_Part B
  Where
    A.Price_List_No = B.Price_List_No
  Group By
    A.Price_List_No,
    B.Catalog_No               
  )
Select
  B.Price_List_No,
  B.Catalog_No,
  Sales_Part_Api.Get_Catalog_Desc(B.Base_Price_Site,B.Catalog_No) As Description,  
  Sales_Part_Api.Get_List_Price(B.Base_Price_Site,B.Catalog_No) As Real_List_Price,
  B.Base_Price,
  B.Sales_Price,
  Round(Case 
          When
            B.Base_Price != 0 
          Then
            100 - (B.Sales_Price / B.Base_Price) * 100
          Else
            100
        End,5) As Effective_Discount_Pct,
  D.Inventory_Value,
  Round((B.Sales_Price - D.Inventory_Value) / Nullif(B.Sales_Price,0),4) * 100 As Margin
From
  Sales_Price_List_Part B,
  Latest_Price_List_Line C Left Join KD_Cost_100 D
    On C.Catalog_No = D.Part_No
Where
  B.Valid_From_Date = C.Latest_Date And
  B.Price_List_No = C.Price_List_No And 
  B.Catalog_No = C.Catalog_No And
  B.State = 'Active' And
  Sales_Part_Api.Get_Activeind('100',B.Catalog_No) != 'Inactive Part'
Order By
  B.Price_List_No,
  B.Catalog_No