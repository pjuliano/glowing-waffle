Select
  A.Customer_Id,
  Sum(B.Allamounts) As Prior_Year_Sales,
  A.Price_List_No
From
  Customer_Pricelist_Ent A Left Join Kd_Sales_Data_Request B
    On A.Customer_ID = B.Customer_No
Where
  Extract(Year From B.Invoicedate) = Extract(Year From Sysdate) - 1 And
  B.Charge_Type = 'Parts'
Group By
  A.Customer_Id,
  A.Price_List_No;
  
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
  B.Base_Price,
  B.Sales_Price,
  Round(Case 
          When
            B.Base_Price != 0 
          Then
            100 - (B.Sales_Price / B.Base_Price) * 100
          Else
            100
        End,5) As Effective_Discount_Pct
From
  Sales_Price_List_Part B,
  Latest_Price_List_Line C
Where
  B.Valid_From_Date = C.Latest_Date And
  B.Price_List_No = C.Price_List_No And 
  B.Catalog_No = C.Catalog_No And
  B.State = 'Active' And
  Sales_Part_Api.Get_ActiveInD('100',B.Catalog_No) != 'Inactive Part';