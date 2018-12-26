With LY AS (   
    Select
        A.Region_Code,
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
        A.Invoice_ID != 'CR1001802096' And --20180904 Invoice is stuck not posted and cannot be deleted. 
        A.Region_Code != 'UNASSIGNED'
    Group By
        A.Region_Code),
CY As (
    Select
        A.Region_Code,
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
        A.Invoice_ID != 'CR1001802096' And --20180904 Invoice is stuck not posted and cannot be deleted. 
        A.Region_Code != 'UNASSIGNED'
    Group By
        A.Region_Code),
QSum As (
    Select
        A.Region,
        Sum(A.Year) As Quota
    From
        Srrepquota A
    Group By
        A.Region),
Reps As (
    Select 
        A.Salesman_Code,
        B.Regionmgr,
        B.Region,
        Case When A.Salesman_Code = '121' Then (A.This_Year - 38000)/A.Year_Quota
             When A.Salesman_Code In ('123','221') Then (A. This_Year - 30000)/A.Year_Quota
             Else A.This_Year/A.Year_Quota
        End As Year_Quota_Pct
    From 
        Kd_Svq_This_Year A,
        Srrepquota B
    Where
        A.Salesman_Code = B.Repnumber)
Select
    LY.Region_Code,
    Reps.Regionmgr,
    Rank() Over (Order By Case When LY.REgion_Code = 'USCE' Then CY.Total-LY.Total-98000 Else CY.Total-LY.Total End Desc) as Revenue_Growth_Rank,
    Case When LY.Region_Code = 'USCE' Then CY.Total-LY.Total-98000 Else CY.Total-LY.Total End As Revenue_Growth,
    Rank() Over (Order By Case When LY.Region_Code = 'USCE' Then ((CY.Total-LY.Total-98000)/Ly.Total)*100 Else ((CY.Total-LY.Total)/LY.Total)*100 End Desc) As Revenue_Growth_Rank,
    Case When LY.Region_Code = 'USCE' Then ((CY.Total-LY.Total-98000)/Ly.Total)*100 Else ((CY.Total-LY.Total)/LY.Total)*100 End AS Revenue_Growth_Pct,
    Rank() Over (Order By Sum(Case When Reps.Year_Quota_PCt > 1 then 1 else 0 End) Desc) AS Reps_Over_Quota_Rank,
    Sum(Case When Reps.Year_Quota_PCt > 1 then 1 else 0 End) As Reps_Over_Quota,
    Round((Rank() Over (Order By Case When LY.REgion_Code = 'USCE' Then CY.Total-LY.Total-98000 Else CY.Total-LY.Total End Desc) +
    Rank() Over (Order By Case When LY.Region_Code = 'USCE' Then ((CY.Total-LY.Total-98000)/Ly.Total)*100 Else ((CY.Total-LY.Total)/LY.Total)*100 End Desc) +
    Rank() Over (Order By Sum(Case When Reps.Year_Quota_PCt > 1 then 1 else 0 End) Desc))/12,4) As Overall_Rank
From
    LY,
    CY,
    QSum,
    Reps
Where
    LY.Region_Code = CY.Region_Code And
    LY.Region_Code = Qsum.Region And
    LY.Region_Code = Reps.Region
Group By
    LY.Region_Code,
    Reps.Regionmgr,
    Case When LY.Region_Code = 'USCE' Then CY.Total-LY.Total-98000 Else CY.Total-LY.Total End,
    Case When LY.Region_Code = 'USCE' Then ((CY.Total-LY.Total-98000)/Ly.Total)*100 Else ((CY.Total-LY.Total)/LY.Total)*100 End