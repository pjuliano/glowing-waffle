--Comp Plan 2018
With DummyData As (
    Select
        103 as YTD_IMPL_Actual_Pct,
        1015000 As YTD_IMPL_Quota,
        1045450 As YTD_IMPL_Actual_Sales,
        99 As YTD_Bio_Actual_PCt,
        735000 as YTD_Bio_Quota,
        727650 as YTD_Bio_Actual_Sales
    From
        Dual)

Select
    Case When A.YTD_IMPL_Actual_Pct > 85 Then (0.85 * A.YTD_IMPL_Quota) 
         Else A.YTD_IMPL_Actual_Sales End As Level_1_Impl_Sales,
    Case When A.YTD_IMPL_Actual_Pct > 85 Then (0.85 * A.YTD_Impl_Quota) * 0.07059  
         Else A.YTD_IMPL_Actual_Sales * 0.07059 End As Level_1_Impl_Payout,
    Case When A.YTD_Impl_Actual_Pct > 100 Then (0.15 * A.YTD_Impl_Quota) 
         When A.YTD_Impl_Actual_Pct > 85 And A.YTD_Impl_Actual_Pct <= 100 Then A.YTD_IMPL_Actual_Sales - (0.85 * A.YTD_Impl_Quota)
         Else 0 End As Level_2_Impl_Sales,
    Case When A.YTD_Impl_Actual_Pct > 100 Then (0.15 * A.YTD_Impl_Quota) * 0.2
         When A.YTD_Impl_Actual_Pct > 85 And A.YTD_Impl_Actual_Pct <= 100 Then (A.YTD_Impl_Actual_Sales - (0.85 * A.YTD_Impl_Quota)) * .2
         Else 0 End As Level_2_Impl_Payout,
    Case When A.YTD_Impl_Actual_PCT > 105 Then (0.05 * A.YTD_Impl_Quota)
         When A.YTD_Impl_Actual_PCT > 100 And A.YTD_Impl_Actual_PCT <= 105 Then (A.YTD_Impl_Actual_Sales - A.YTD_Impl_Quota)
         Else 0 End As Level_3_Impl_Sales,
    Case When A.YTD_Impl_Actual_PCT > 105 Then (0.05 * A.YTD_Impl_Quota) * 0.22
         When A.YTD_Impl_Actual_PCT > 100 And A.YTD_Impl_Actual_PCT <= 105 Then (A.YTD_Impl_Actual_Sales - A.YTD_Impl_Quota) * 0.22
         Else 0 End As Level_3_Impl_Payout,
    Case When A.YTD_Impl_Actual_Pct > 110 Then (0.05 * A.YTD_Impl_Quota)
         When A.YTD_Impl_Actual_PCT > 105 And A.YTD_Impl_Actual_PCT <= 110 Then (A.YTD_Impl_Actual_Sales - (1.05 * A.YTD_Impl_Quota))
         Else 0 End As Level_4_Impl_Sales,
    Case When A.YTD_Impl_Actual_Pct > 110 Then (0.05 * A.YTD_Impl_Quota) * 0.24
         When A.YTD_Impl_Actual_PCT > 105 And A.YTD_Impl_Actual_PCT <= 110 Then (A.YTD_Impl_Actual_Sales - (1.05 * A.YTD_Impl_Quota)) * 0.24
         Else 0 End As Level_4_Impl_Payout,
    Case When A.YTD_Impl_Actual_Pct > 110 Then A.YTD_Impl_Actual_Sales - (1.10 * A.YTD_Impl_Quota)
         Else 0 End As Level_5_Impl_Sales,
    Case When A.YTD_Impl_Actual_Pct > 110 Then (A.YTD_Impl_Actual_Sales - (1.10 * A.YTD_Impl_Quota)) * 0.26
         Else 0 End As Level_5_Impl_Payout,
         
    Case When A.YTD_BIO_Actual_Pct > 85 Then (0.85 * A.YTD_BIO_Quota) 
         Else A.YTD_BIO_Actual_Sales End As Level_1_BIO_Sales,
    Case When A.YTD_BIO_Actual_Pct > 85 Then (0.85 * A.YTD_BIO_Quota) * 0.0549
         Else A.YTD_BIO_Actual_Sales * 0.0549 End As Level_1_BIO_Payout,
    Case When A.YTD_BIO_Actual_Pct > 100 Then (0.15 * A.YTD_BIO_Quota) 
         When A.YTD_BIO_Actual_Pct > 85 And A.YTD_BIO_Actual_Pct <= 100 Then A.YTD_BIO_Actual_Sales - (0.85 * A.YTD_BIO_Quota)
         Else 0 End As Level_2_BIO_Sales,
    Case When A.YTD_BIO_Actual_Pct > 100 Then (0.15 * A.YTD_BIO_Quota) * 0.15556
         When A.YTD_BIO_Actual_Pct > 85 And A.YTD_BIO_Actual_Pct <= 100 Then (A.YTD_BIO_Actual_Sales - (0.85 * A.YTD_BIO_Quota)) * .15556
         Else 0 End As Level_2_BIO_Payout,
    Case When A.YTD_BIO_Actual_PCT > 105 Then (0.05 * A.YTD_BIO_Quota)
         When A.YTD_BIO_Actual_PCT > 100 And A.YTD_BIO_Actual_PCT <= 105 Then (A.YTD_BIO_Actual_Sales - A.YTD_BIO_Quota)
         Else 0 End As Level_3_BIO_Sales,
    Case When A.YTD_BIO_Actual_PCT > 105 Then (0.05 * A.YTD_BIO_Quota) * 0.17556
         When A.YTD_BIO_Actual_PCT > 100 And A.YTD_BIO_Actual_PCT <= 105 Then (A.YTD_BIO_Actual_Sales - A.YTD_BIO_Quota) * 0.17556
         Else 0 End As Level_3_BIO_Payout,
    Case When A.YTD_BIO_Actual_Pct > 110 Then (0.05 * A.YTD_BIO_Quota)
         When A.YTD_BIO_Actual_PCT > 105 And A.YTD_BIO_Actual_PCT <= 110 Then (A.YTD_BIO_Actual_Sales - (1.05 * A.YTD_BIO_Quota))
         Else 0 End As Level_4_Bio_Sales,
    Case When A.YTD_BIO_Actual_Pct > 110 Then (0.05 * A.YTD_BIO_Quota) * 0.19556
         When A.YTD_BIO_Actual_PCT > 105 And A.YTD_BIO_Actual_PCT <= 110 Then (A.YTD_BIO_Actual_Sales - (1.05 * A.YTD_BIO_Quota)) * 0.19556
         Else 0 End As Level_4_Bio_Payout,
    Case When A.YTD_BIO_Actual_Pct > 110 Then A.Ytd_Bio_Actual_Sales - (1.10 * A.YTD_BIO_Quota)
         Else 0 End As Level_5_Bio_Sales,
    Case When A.YTD_BIO_Actual_Pct > 110 Then (A.YTD_BIO_Actual_Sales - (1.10 * A.YTD_BIO_Quota)) * 0.21556
         Else 0 End As Level_5_Bio_Payout
From
    DummyData A