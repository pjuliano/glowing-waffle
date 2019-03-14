Create Or Replace View KD_MRP_PROC_OPEN_SO As
Select
    A.Proc_Part_No,
    Decode(Sum(Shop_Ord_Util_Api.Get_Remaining_Qty(C.Order_No,C.Release_No,C.Sequence_No,C.Part_No,C.Order_Code)),Null,0,Sum(Shop_Ord_Util_Api.Get_Remaining_Qty(C.Order_No,C.Release_No,C.Sequence_No,C.Part_No,C.Order_Code))) As Open_SO_Proc
From
    KD_MRP_Part_Relationships A Left Join Shop_Ord C
        On A.Proc_Part_No = C.Part_No And 
           C.Contract = '100' And
           (
                C.State = 'Released' Or
                C.State = 'Parked' Or
                C.State = 'Reserved' Or
                C.State = 'Started'
            )
Group By
    A.Proc_Part_No