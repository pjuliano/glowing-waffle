Create Or Replace View KD_MRP_PROC1_AVAIL As
With Proc_Parts As 
    (
    Select
        A.Proc_Part_No_1
    From
        KD_MRP_Part_Relationships A
    Where
        A.Proc_Part_No_1 Is Not Null
    Group By
        A.Proc_Part_No_1
    )
Select
    A.Proc_Part_No_1,
    B.Open_Po_Proc,
    NVL(C.On_Hand_Proc,0) As On_Hand_Proc,
    D.Open_SO_Proc
From
    Proc_Parts A Left Join KD_MRP_PROC1_Open_PO B
        On A.Proc_Part_No_1 = B.Proc_Part_No_1
                                Left Join KD_MRP_PROC1_ON_HAND C
        On A.Proc_Part_No_1 = C.Proc_Part_No_1
                                Left Join KD_MRP_Proc1_Open_SO D
        On A.Proc_Part_No_1 = D.Proc_Part_No_1