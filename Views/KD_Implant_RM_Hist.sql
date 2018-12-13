Create Or Replace View KD_Implant_RM_Hist As
Select
    Mh.Order_Ref1 as Shop_Order,
    So.Part_No As FG_Part,
    Sum(ST.Qty_Onhand) As FG_Qty_OnHand,
    Sum(ST.Qty_Onhand)-Sum(St.Qty_Reserved) as FG_Qty_Available,
    Mh.Part_No As RM_Part_No,
    Ip.Description,
    Mh.Lot_Batch_No,
    Mh.Serial_No,
    Mh.Eng_Chg_Level,
    Ip.Second_Commodity,
    Ih.Order_No,
    Ih.Date_Applied as Received_Date
From
    Material_History MH Left Join Inventory_Part IP On
        MH.Contract = IP.Contract And 
        MH.Part_No = IP.Part_No
                        Left Join Inventory_Transaction_Hist IH On
        MH.Lot_Batch_No = IH.Lot_Batch_No And
        MH.Part_No = IH.Part_No
                        Left Join Shop_Ord So On
        MH.Order_Ref1 = So.Order_No And
        Mh.Order_Ref2 = So.Release_No And
        Mh.Order_Ref3 = So.Sequence_No
                        Left Join Inventory_Part_In_Stock ST On
        So.Order_No = ST.Lot_Batch_No And
        So.Part_No = ST.Part_No
Where
    Ip.Part_Product_Code = 'IMPL' And
    Ip.Second_Commodity Not In ('LABEL','BOX','PKSLV') And
    MH.Lot_Batch_No != Order_Ref1 And
    Ih.Transaction_Code In ('OOREC','ARRIVAL') 
Group By 
    Mh.Order_Ref1, 
    So.Part_No, 
    Mh.Part_No, 
    Ip.Description, 
    Mh.Lot_Batch_No, 
    Mh.Serial_No, 
    Mh.Eng_Chg_Level, 
    Ip.Second_Commodity, 
    Ih.Order_No, 
    Ih.Date_Applied