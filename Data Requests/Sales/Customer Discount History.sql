With PLCS as (  Select
                    A.Customer_ID,
                    ListAgg(B.Price_List_No,', ') Within Group (Order by A.Customer_ID, A.Name) as Price_Lists
                From
                    Customer_Info A,
                    Customer_PriceList_Ent B, 
                    Sales_Price_List C
                Where
                    A.Customer_ID = B.Customer_Id And
                    B.Price_List_No = C.Price_List_No And
                    C.Valid_To_Date >= Trunc(Sysdate) And
                    KD_Get_Corporate_Form(A.Customer_Id) = 'DOMDIR'
                Group By
                    A.Customer_ID, A.Name)
Select
    A.Customer_No,
    A.Customer_Name, 
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)-1 And
                  A.Charge_Type = 'Parts'
             Then A.AllAmounts
             Else 0
        End) PY_Sales_Total,
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)-1 And
                  A.Charge_Type = 'Parts' And
                  A.AllAmounts = 0 
             Then Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No) * A.Invoiced_Qty
             Else 0
        End) As PY_Free_Goods_At_List,
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)-1 And
                  A.Charge_Type = 'Parts'
             Then A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site, A.Catalog_No)
             Else 0
        End) As PY_Sales_At_List,
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)-1 And
                  A.Charge_Type = 'Parts'
             Then (A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site, A.Catalog_No)) - A.AllAmounts
             Else 0
        End) as PY_Total_Discount_Dollars,
    Round(Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)-1 And
                  A.Charge_Type = 'Parts'
             Then (A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site, A.Catalog_No)) - A.AllAmounts
             Else 0
        End) /
    Nullif(Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)-1 And
                  A.Charge_Type = 'Parts'
             Then A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site, A.Catalog_No)
             Else 0
        End),0),4)*100 As PY_Effective_Discount,
    Round((Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)-1 And
                  A.Charge_Type = 'Parts'
             Then A.AllAmounts
             Else 0
        End) - 
    Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)-1 And
                  A.Charge_Type = 'Parts'
             Then A.Cost * A.Invoiced_Qty
             Else 0
        End)) /
    Nullif(Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)-1 And
                  A.Charge_Type = 'Parts'
             Then A.AllAmounts
             Else 0
        End),0),4)*100 As PY_Margin,
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate) And
                  A.Charge_Type = 'Parts'
             Then A.AllAmounts
             Else 0
        End) CY_Sales_Total,
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate) And
                  A.Charge_Type = 'Parts' And
                  A.AllAmounts = 0 
             Then Sales_Part_Api.Get_List_Price(A.Site,A.Catalog_No) * A.Invoiced_Qty
             Else 0
        End) As CY_Free_Goods_At_List,
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate) And
                  A.Charge_Type = 'Parts'
             Then A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site, A.Catalog_No)
             Else 0
        End) As CY_Sales_At_List,
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate) And
                  A.Charge_Type = 'Parts'
             Then (A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site, A.Catalog_No)) - A.AllAmounts
             Else 0
        End) as CY_Total_Discount_Dollars,
    Round(Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate) And
                  A.Charge_Type = 'Parts'
             Then (A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site, A.Catalog_No)) - A.AllAmounts
             Else 0
        End) /
    Nullif(Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate) And
                  A.Charge_Type = 'Parts'
             Then A.Invoiced_Qty * Sales_Part_Api.Get_List_Price(A.Site, A.Catalog_No)
             Else 0
        End),0),4)*100 As CY_Effective_Discount,
    Round((Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                  A.Charge_Type = 'Parts'
             Then A.AllAmounts
             Else 0
        End) - 
    Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                  A.Charge_Type = 'Parts'
             Then A.Cost * A.Invoiced_Qty
             Else 0
        End)) /
    Nullif(Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                  A.Charge_Type = 'Parts'
             Then A.AllAmounts
             Else 0
        End),0),4) *100 As CY_Margin,
    B.Price_Lists
From
    KD_Sales_Data_Request A,
    PLCS B
Where
    A.Customer_No = B.Customer_ID And
    ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
    (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null)
Group By
    A.Customer_No,
    A.Customer_Name,
    B.Price_Lists
Order By
    A.Customer_No