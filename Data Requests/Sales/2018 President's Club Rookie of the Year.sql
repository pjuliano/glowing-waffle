With LY As (Select 
                A.Salesman_Code, 
                Sum(A.AllAmounts) As Total
            From 
                KD_Sales_Data_Request A
            Where
                Extract(Year from A.Invoicedate) = Extract(Year From Sysdate)-1 And
                A.Charge_Type = 'Parts' And
                A.Corporate_Form = 'DOMDIR' And
                A.Catalog_No != '3DBC-22001091' And
                ((A.Order_No Not Like 'W%' And
                A.Order_No Not Like 'X%') Or
                A.Order_No Is Null) And
                (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
                A.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
            Group By
                A.Salesman_Code),
CY as     (Select 
                A.Salesman_Code, 
                Sum(A.AllAmounts) As Total
            From 
                KD_Sales_Data_Request A
            Where
                Extract(Year from A.Invoicedate) = Extract(Year From Sysdate) And
                A.Charge_Type = 'Parts' And
                A.Corporate_Form = 'DOMDIR' And
                A.Catalog_No != '3DBC-22001091' And
                ((A.Order_No Not Like 'W%' And
                A.Order_No Not Like 'X%') Or
                A.Order_No Is Null) And
                (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
                A.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
            Group By
                A.Salesman_Code)
Select
    LY.Salesman_Code,
    Person_Info_Api.Get_Name(LY.Salesman_Code) As Name,
    Rank() Over (Order By CY.Total - LY.Total Desc) As Revenue_Growth_Rank,
    CY.Total - LY.Total As Revenue_Growth,
    Rank() Over (Order by ((CY.Total-LY.Total)/LY.Total)*100 Desc) As Revenue_Growth_PCT_Rank,
    ((Cy.Total-LY.Total)/Ly.Total)*100 As Revenue_Growth_Pct,
    ((Rank() Over (Order By CY.Total - LY.Total Desc)*.6) + (Rank() Over (Order by (CY.Total-LY.Total)/LY.Total Desc)*.4))/2 As Overall_Rank
From
    LY,
    CY
Where
    LY.Salesman_Code = CY.Salesman_Code And
    LY.Salesman_Code IN ('136','217','306','122')