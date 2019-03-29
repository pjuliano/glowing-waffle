Create Or Replace View KD_MRP_PROC2_OPEN_PO As 
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
    Decode(Sum(B.Due_At_Dock),Null,0,Sum(B.Due_At_Dock)) As Open_PO_Proc
From
    Proc_Parts A Left Join Purchase_Order_Line_New B
        On A.Proc_Part_No_2 = B.Part_No And
           B.Order_No Not Like 'S%'
Group By
    A.Proc_Part_No_2