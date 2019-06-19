Create Or Replace View KD_MRP_RM_QTYS As 
With RM_Parts As 
    (
    Select 
        A.RM_Part_No
    From 
        KD_MRP_Part_Relationships A
    Group By
        A.RM_Part_No
    )

Select
    A.RM_Part_No,
    NVL(B.Open_PO_RM,0) As Open_PO_RM,
    NVL(C.On_Hand_Rm,0) As On_Hand_RM
From
    RM_Parts A Left Join KD_MRP_RM_OPEN_PO B
        On A.RM_Part_No = B.RM_Part_No
               Left Join KD_MRP_RM_ON_HAND C
        On A.RM_Part_No = C.RM_Part_No