--------------------------------------------------------
--  DDL for View KD_MRP_RM_AVAIL_FORECAST
--------------------------------------------------------

  CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_MRP_RM_AVAIL_FORECAST" ("RM_PART_NO", "FG_PART_NO", "RM_RATIO", "OPEN_PO_RM", "ON_HAND_RM", "RMFG_SPLIT_TOTAL") AS 
  Select
    A.RM_Part_No,
    A.FG_Part_No,
    A.RM_Ratio,
    B.Open_PO_RM,
    B.On_Hand_RM,
    Round((B.Open_PO_RM + B.On_Hand_RM) * A.RM_Ratio) As RMFG_Split_Total
From
    KD_MRP_RM_Ratio_Forecast A,
    KD_MRP_RM_Qtys B
Where
    A.RM_Part_No = B.Rm_Part_No
;
