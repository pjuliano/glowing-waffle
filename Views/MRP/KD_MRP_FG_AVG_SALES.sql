Create Or Replace View KD_MRP_FG_AVG_SALES As
Select Distinct
    A.FG_Part_No,
    A.FG_Part_Index,
    Round((Sysdate - B.Date_Entered) / 30) As Active_Months,
    C.Units_Sold_12m,
    Case When Round((Sysdate - B.Date_Entered) / 30) < 12
         Then Round(C.Units_Sold_12M / Round((Sysdate - B.Date_Entered) / 30),1)
         Else Round(C.Units_Sold_12M / 12,1)
    End As Avg_Monthly_Sales
From
    KD_MRP_Part_Relationships A 
        Left Join Sales_Part B
            On A.FG_Part_No = B.Part_No And
                B.Contract = '100'
        Left Join KD_MRP_FG_Sales_Qty C
            On A.FG_Part_No = C.Fg_Part_No