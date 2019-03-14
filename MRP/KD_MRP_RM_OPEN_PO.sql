Create Or Replace View KD_MRP_RM_OPEN_PO As 
With RM_Parts As 
    (
    Select
        A.RM_part_No
    From
        KD_MRP_Part_Relationships A
    Group By
        A.RM_Part_No
    )
Select
    A.RM_Part_No,
    Decode(Sum(B.Due_At_Dock),Null,0,Sum(B.Due_At_Dock)) As Open_PO_RM
From
    RM_Parts A Left Join Purchase_Order_Line_New B
        On A.RM_Part_No = B.Part_No And
           B.Order_No Not Like 'S%'
Group By
    A.RM_Part_No