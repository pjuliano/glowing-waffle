Create Or Replace View Kd_Svq_This_Month As
Select
    B.repnumber AS salesman_code,
    Sum(A.Allamounts)As This_Month,
    Sum(
        Case
            When A.Part_Product_Code Not In(
                'LIT','REGEN'
            )
            Then A.Allamounts
            Else 0
        End
    )As This_Month_Implants,
    Sum(
        Case
            When A.Part_Product_Code = 'REGEN'
            Then A.Allamounts
            Else 0
        End
    )As This_Month_Bio,
    Sum(
        Case
            When A.Part_Product_Code != 'LIT' And
                 A.Order_No Not Like 'W%' And
                 A.Order_No Not Like 'X%'
            Then Round((A.Allamounts -(A.Cost * A.Invoiced_Qty)),2)
        End
    )As This_Month_Gross_Margin,
    Case
        When Extract(Month From Sysdate)= 1
        Then B.Jan
        When Extract(Month From Sysdate)= 2
        Then B.Feb
        When Extract(Month From Sysdate)= 3
        Then B.Mar
        When Extract(Month From Sysdate)= 4
        Then B.Apr
        When Extract(Month From Sysdate)= 5
        Then B.May
        When Extract(Month From Sysdate)= 6
        Then B.June
        When Extract(Month From Sysdate)= 7
        Then B.July
        When Extract(Month From Sysdate)= 8
        Then B.Aug
        When Extract(Month From Sysdate)= 9
        Then B.Sept
        When Extract(Month From Sysdate)= 10
        Then B.Oct
        When Extract(Month From Sysdate)= 11
        Then B.Nov
        When Extract(Month From Sysdate)= 12
        Then B.Dec
        Else 0
    End As Month_Quota,
    Case 
        When Extract(Month From Sysdate)= 1
        Then B.M1_Impl
        When Extract(Month From Sysdate)= 2
        Then B.M2_Impl
        When Extract(Month From Sysdate)= 3
        Then B.M3_Impl
        When Extract(Month From Sysdate)= 4
        Then B.M4_Impl
        When Extract(Month From Sysdate)= 5
        Then B.M5_Impl
        When Extract(Month From Sysdate)= 6
        Then B.M6_Impl
        When Extract(Month From Sysdate)= 7
        Then B.M7_Impl
        When Extract(Month From Sysdate)= 8
        Then B.M8_Impl
        When Extract(Month From Sysdate)= 9
        Then B.M9_Impl
        When Extract(Month From Sysdate)= 10
        Then B.M10_Impl
        When Extract(Month From Sysdate)= 11
        Then B.M11_Impl
        When Extract(Month From Sysdate)= 12
        Then B.M12_Impl
        Else 0
    End As Month_Quota_Impl,
    Case 
        When Extract(Month From Sysdate)= 1
        Then B.M1_BIO
        When Extract(Month From Sysdate)= 2
        Then B.M2_BIO
        When Extract(Month From Sysdate)= 3
        Then B.M3_BIO
        When Extract(Month From Sysdate)= 4
        Then B.M4_BIO
        When Extract(Month From Sysdate)= 5
        Then B.M5_BIO
        When Extract(Month From Sysdate)= 6
        Then B.M6_BIO
        When Extract(Month From Sysdate)= 7
        Then B.M7_BIO
        When Extract(Month From Sysdate)= 8
        Then B.M8_BIO
        When Extract(Month From Sysdate)= 9
        Then B.M9_BIO
        When Extract(Month From Sysdate)= 10
        Then B.M10_BIO
        When Extract(Month From Sysdate)= 11
        Then B.M11_BIO
        When Extract(Month From Sysdate)= 12
        Then B.M12_BIO
        Else 0
    End As Month_Quota_BIO,
    B.Region
From
    Srrepquota    B
    Left Join  Kd_Sales_Data_Request   A
        On A.Salesman_Code = B.Repnumber And
        Extract(Month From A.Invoicedate)= Extract(Month From Sysdate)And
        Extract(Year From A.Invoicedate)= Extract(Year From Sysdate)And
        A.Charge_Type = 'Parts' And
        A.Corporate_Form = 'DOMDIR' And
        A.Catalog_No != '3DBC-22001091' And
        ((A.Order_No Not Like 'W%' And
          A.Order_No Not Like 'X%') Or
        A.Order_No Is Null)And
        (A.Market_Code != 'PREPOST' Or
        A.Market_Code Is Null)And
        A.Invoice_Id != 'CR1001802096' And --20180904 Invoice is stuck not posted and cannot be deleted.
        (A.Order_No != 'C512921' Or A.Order_No Is Null) --Kevin Stack's order/return that spanned years.
Group By
    b.repnumber,
    Case
        When Extract(Month From Sysdate)= 1
        Then B.Jan
        When Extract(Month From Sysdate)= 2
        Then B.Feb
        When Extract(Month From Sysdate)= 3
        Then B.Mar
        When Extract(Month From Sysdate)= 4
        Then B.Apr
        When Extract(Month From Sysdate)= 5
        Then B.May
        When Extract(Month From Sysdate)= 6
        Then B.June
        When Extract(Month From Sysdate)= 7
        Then B.July
        When Extract(Month From Sysdate)= 8
        Then B.Aug
        When Extract(Month From Sysdate)= 9
        Then B.Sept
        When Extract(Month From Sysdate)= 10
        Then B.Oct
        When Extract(Month From Sysdate)= 11
        Then B.Nov
        When Extract(Month From Sysdate)= 12
        Then B.Dec
        Else 0
    End,
    Case 
        When Extract(Month From Sysdate)= 1
        Then B.M1_Impl
        When Extract(Month From Sysdate)= 2
        Then B.M2_Impl
        When Extract(Month From Sysdate)= 3
        Then B.M3_Impl
        When Extract(Month From Sysdate)= 4
        Then B.M4_Impl
        When Extract(Month From Sysdate)= 5
        Then B.M5_Impl
        When Extract(Month From Sysdate)= 6
        Then B.M6_Impl
        When Extract(Month From Sysdate)= 7
        Then B.M7_Impl
        When Extract(Month From Sysdate)= 8
        Then B.M8_Impl
        When Extract(Month From Sysdate)= 9
        Then B.M9_Impl
        When Extract(Month From Sysdate)= 10
        Then B.M10_Impl
        When Extract(Month From Sysdate)= 11
        Then B.M11_Impl
        When Extract(Month From Sysdate)= 12
        Then B.M12_Impl
        Else 0
    End,
    Case 
        When Extract(Month From Sysdate)= 1
        Then B.M1_BIO
        When Extract(Month From Sysdate)= 2
        Then B.M2_BIO
        When Extract(Month From Sysdate)= 3
        Then B.M3_BIO
        When Extract(Month From Sysdate)= 4
        Then B.M4_BIO
        When Extract(Month From Sysdate)= 5
        Then B.M5_BIO
        When Extract(Month From Sysdate)= 6
        Then B.M6_BIO
        When Extract(Month From Sysdate)= 7
        Then B.M7_BIO
        When Extract(Month From Sysdate)= 8
        Then B.M8_BIO
        When Extract(Month From Sysdate)= 9
        Then B.M9_BIO
        When Extract(Month From Sysdate)= 10
        Then B.M10_BIO
        When Extract(Month From Sysdate)= 11
        Then B.M11_BIO
        When Extract(Month From Sysdate)= 12
        Then B.M12_BIO
        Else 0
    End,
    B.Region;