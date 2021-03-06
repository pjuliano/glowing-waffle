Create Or Replace View KD_MRP_FG_OPEN_SO As
Select
    A.Fg_Part_No,
    NVL(Sum(Shop_Ord_Util_Api.Get_Remaining_Qty(C.Order_No,C.Release_No,C.Sequence_No,C.Part_No,C.Order_Code) * Nvl(A.FG_Multiplier,1)),0) As Open_SO_FG
From
    KD_MRP_Part_Relationships A Left Join Shop_Ord C
        On A.FG_Part_No = C.Part_No And 
           C.Contract = '100' And
           (
                C.State = 'Released' Or
                C.State = 'Parked' Or
                C.State = 'Reserved' Or
                C.State = 'Started'
            )
Group By
    A.FG_Part_No