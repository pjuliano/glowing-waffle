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
    Q.Repnumber As Salesman_Code,
    Q.Rep_name as Name,
    Q.Region,
    Rank() Over (Order By       Case When LY.Salesman_Code = '121' Then ((CY.Total - 38000)/Q.Year) * 100
                                     When LY.Salesman_Code = '123' Then ((CY.Total - 30000)/Q.Year) * 100
                                     When LY.Salesman_Code = '221' Then ((CY.Total - 30000)/Q.Year) * 100
                                     Else CY.Total/Q.Year * 100
                                End Desc) As Quota_Pct_Rank,
    Case When LY.Salesman_Code = '121' Then ((CY.Total - 38000)/Q.Year) * 100
         When LY.Salesman_Code = '123' Then ((CY.Total - 30000)/Q.Year) * 100
         When LY.Salesman_Code = '221' Then ((CY.Total - 30000)/Q.Year) * 100
         Else CY.Total/Q.Year * 100
    End As QUOTA_PCT,
    Rank() Over (   Order By    Case When LY.Salesman_Code = '121' Then (CY.Total-LY.total-38000)
                                     When LY.Salesman_Code = '123' Then (CY.Total-LY.total-30000)
                                     When LY.Salesman_Code = '221' Then (CY.Total-LY.total-30000)
                                     Else CY.Total-LY.total
                                End Desc) As Revenue_Growth_Rank,
    Case When LY.Salesman_Code = '121' Then (CY.Total-LY.total-38000)
         When LY.Salesman_Code = '123' Then (CY.Total-LY.total-30000)
         When LY.Salesman_Code = '221' Then (CY.Total-LY.total-30000)
         Else CY.Total-LY.total
    End As Revenue_Growth,
    Rank() Over (Order By       Case When LY.Salesman_Code = '121' Then ((CY.Total-LY.total-38000)/LY.Total)*100
                                     When LY.Salesman_Code = '123' Then ((CY.Total-LY.total-30000)/LY.Total)*100
                                     When LY.Salesman_Code = '221' Then ((CY.Total-LY.total-30000)/LY.Total)*100
                                     Else ((CY.Total-LY.total)/LY.Total)*100
                                End Desc) As Revenue_Growth_Pct_Rank,
    Case When LY.Salesman_Code = '121' Then ((CY.Total-LY.total-38000)/LY.Total)*100
         When LY.Salesman_Code = '123' Then ((CY.Total-LY.total-30000)/LY.Total)*100
         When LY.Salesman_Code = '221' Then ((CY.Total-LY.total-30000)/LY.Total)*100
         Else ((CY.Total-LY.total)/LY.Total)*100
    End As Revenue_Growth_Pct,
    Round((Rank() Over (Order By       Case When LY.Salesman_Code = '121' Then ((CY.Total - 38000)/Q.Year) * 100
                                     When LY.Salesman_Code = '123' Then ((CY.Total - 30000)/Q.Year) * 100
                                     When LY.Salesman_Code = '221' Then ((CY.Total - 30000)/Q.Year) * 100
                                     Else CY.Total/Q.Year * 100
                                End Desc) + 
    Rank() Over (   Order By    Case When LY.Salesman_Code = '121' Then (CY.Total-LY.total-38000)
                                     When LY.Salesman_Code = '123' Then (CY.Total-LY.total-30000)
                                     When LY.Salesman_Code = '221' Then (CY.Total-LY.total-30000)
                                     Else CY.Total-LY.total
                                End Desc) + 
    Rank() Over (Order By       Case When LY.Salesman_Code = '121' Then ((CY.Total-LY.total-38000)/LY.Total)*100
                                     When LY.Salesman_Code = '123' Then ((CY.Total-LY.total-30000)/LY.Total)*100
                                     When LY.Salesman_Code = '221' Then ((CY.Total-LY.total-30000)/LY.Total)*100
                                     Else ((CY.Total-LY.total)/LY.Total)*100
                                End Desc))/90,4) As Overall_Rank
From
    LY,
    CY,
    SrRepQuota Q
Where
    LY.Salesman_Code = CY.Salesman_Code And
    LY.Salesman_Code = Q.Repnumber And
    LY.Salesman_Code Not In ('136','217','306','122','311','304','999','124','308')