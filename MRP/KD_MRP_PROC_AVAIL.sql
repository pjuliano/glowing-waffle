Create Or Replace View KD_MRP_PROC_AVAIL As
Select
    A.Proc_Part_No,
    B.Open_Po_Proc,
    Decode(C.On_Hand_Proc,Null,0,C.On_Hand_Proc) As On_Hand_Proc,
    D.Open_SO_Proc
From
    KD_MRP_Part_Relationships A Left Join KD_MRP_PROC_Open_PO B
        On A.Proc_Part_No = B.Proc_Part_No
                                Left Join KD_MRP_PROC_ON_HAND C
        On A.Proc_Part_No = C.Proc_Part_No
                                Left Join KD_MRP_Proc_Open_SO D
        On A.Proc_Part_No = D.Proc_Part_No