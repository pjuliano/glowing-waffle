Create Or Replace View KD_MRP_PROC1_OPEN_PO As 
With Proc_Parts As 
    (
    Select
        A.Proc_Part_No_1
    From
        KD_MRP_Part_Relationships A
    Where
        a.proc_part_no_1 IS NOT NULL
    Group By
        A.Proc_Part_No_1
    )
Select
    A.Proc_Part_No_1,
    NVL(Sum(B.Due_At_Dock),0) As Open_PO_Proc
From
    Proc_Parts A Left Join Purchase_Order_Line_New B
        On A.Proc_Part_No_1 = B.Part_No And
           B.Order_No Not Like 'S%'
Group By
    A.Proc_Part_No_1