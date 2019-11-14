--Create Or Replace View Kd_Svq_This_Quarter As
    Select
        b.repnumber AS salesman_code,
        NVL(Sum (A.Allamounts),0) As This_Quarter,
        Sum 
            (
            Case
                When A.Part_Product_Code Not In (
                    'LIT','REGEN'
                )
                Then A.Allamounts
                Else 0
            End
            ) As This_Quarter_Implants,
        Sum (
            Case
                When A.Part_Product_Code = 'REGEN'
                Then A.Allamounts
                Else 0
            End
        ) As This_Quarter_Bio,Case
            When Extract (Month From Sysdate) In (
                1,2,3
            )
            Then B.Qtr1
            When Extract (Month From Sysdate) In (
                4,5,6
            )
            Then B.Qtr2
            When Extract (Month From Sysdate) In (
                7,8,9
            )
            Then B.Qtr3
            When Extract (Month From Sysdate) In (
                10,11,12
            )
            Then B.Qtr4
        End As Qtr_Quota,Case
            When Extract (Month From Sysdate) In (
                1,2,3
            )
            Then B.Qtr1_Impl
            When Extract (Month From Sysdate) In (
                4,5,6
            )
            Then B.Qtr2_Impl
            When Extract (Month From Sysdate) In (
                7,8,9
            )
            Then B.Qtr3_Impl
            When Extract (Month From Sysdate) In (
                10,11,12
            )
            Then B.Qtr4_Impl
        End As Qtr_Quota_Impl,Case
            When Extract (Month From Sysdate) In (
                1,2,3
            )
            Then B.Qtr1_Bio
            When Extract (Month From Sysdate) In (
                4,5,6
            )
            Then B.Qtr2_Bio
            When Extract (Month From Sysdate) In (
                7,8,9
            )
            Then B.Qtr3_Bio
            When Extract (Month From Sysdate) In (
                10,11,12
            )
            Then B.Qtr4_Bio
        End As Qtr_Quota_Bio,B.Region
    From
        kd_quota_rep_tab B
        Left Join Kd_Sales_Data_Request A 
        On A.Salesman_Code = B.Repnumber And
        A.Invoiceqtr =
            Case
                When Extract (Month From Sysdate) In (
                    1,2,3
                )
                Then 'QTR1'
                When Extract (Month From Sysdate) In (
                    4,5,6
                )
                Then 'QTR2'
                When Extract (Month From Sysdate) In (
                    7,8,9
                )
                Then 'QTR3'
                When Extract (Month From Sysdate) In (
                    10,11,12
                )
                Then 'QTR4'
            End And
        Extract (Year From A.Invoicedate) = Extract (Year From Sysdate) And
        A.Charge_Type = 'Parts' And
        A.Corporate_Form = 'DOMDIR' And
        A.Catalog_No != '3DBC-22001091' And
        ((A.Order_No Not Like 'W%' And
        A.Order_No Not Like 'X%') Or
        A.Order_No Is Null) And
        (A.Market_Code != 'PREPOST' Or
        A.Market_Code Is Null) And
        A.Invoice_Id != 'CR1001802096' And --20180904 Invoice is stuck not posted and cannot be deleted.
        (A.Order_No != 'C512921' Or A.Order_No Is Null) --Kevin Stack's order/return that spanned years.    
    Group By
        b.repnumber,
        Case
                When Extract (Month From Sysdate) In (
                    1,2,3
                )
                Then B.Qtr1
                When Extract (Month From Sysdate) In (
                    4,5,6
                )
                Then B.Qtr2
                When Extract (Month From Sysdate) In (
                    7,8,9
                )
                Then B.Qtr3
                When Extract (Month From Sysdate) In (
                    10,11,12
                )
                Then B.Qtr4
            End,Case
                When Extract (Month From Sysdate) In (
                    1,2,3
                )
                Then B.Qtr1_Impl
                When Extract (Month From Sysdate) In (
                    4,5,6
                )
                Then B.Qtr2_Impl
                When Extract (Month From Sysdate) In (
                    7,8,9
                )
                Then B.Qtr3_Impl
                When Extract (Month From Sysdate) In (
                    10,11,12
                )
                Then B.Qtr4_Impl
            End,Case
                When Extract (Month From Sysdate) In (
                    1,2,3
                )
                Then B.Qtr1_Bio
                When Extract (Month From Sysdate) In (
                    4,5,6
                )
                Then B.Qtr2_Bio
                When Extract (Month From Sysdate) In (
                    7,8,9
                )
                Then B.Qtr3_Bio
                When Extract (Month From Sysdate) In (
                    10,11,12
                )
                Then B.Qtr4_Bio
            End,
            B.Region;