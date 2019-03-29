Create Or Replace View KD_MRP_PROC2_OPEN_SO As
With Proc_Parts As 
    (
    Select
        A.Proc_Part_No_2
    From
        KD_MRP_Part_Relationships A
    Group By
        A.Proc_Part_No_2
    )
Select
    A.Proc_Part_No_2,
    Decode(Sum(Shop_Ord_Util_Api.Get_Remaining_Qty(C.Order_No,C.Release_No,C.Sequence_No,C.Part_No,C.Order_Code)),Null,0,Sum(Shop_Ord_Util_Api.Get_Remaining_Qty(C.Order_No,C.Release_No,C.Sequence_No,C.Part_No,C.Order_Code))) As Open_SO_Proc
From
    Proc_Parts A Left Join Shop_Ord C
        On A.Proc_Part_No_2 = C.Part_No And 
           C.Contract = '100' And
           (
                C.State = 'Released' Or
                C.State = 'Parked' Or
                C.State = 'Reserved' Or
                C.State = 'Started'
            )
Group By
    A.Proc_Part_No_2