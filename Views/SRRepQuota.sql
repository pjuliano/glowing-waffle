Create or Replace View srrepquota As 
Select 
    Territory_Number as RepNumber,
    Rep_Name,
    Sum(M1) As Jan,
    Sum(M2) As Feb,
    Sum(M3) As Mar,
    Sum(M4) As Apr,
    Sum(M5) As May,
    Sum(M6) As June,
    Sum(M7) As July,
    Sum(M8) As Aug,
    Sum(M9) As Sept,
    Sum(M10) As Oct,
    Sum(M11) As Nov,
    Sum(M12) As Dec,
    Sum(M1 + M2 + M3) As QTR1,
    Sum(M4 + M5 + M6) As QTR2,
    Sum(M7 + M8 + M9) As QTR3,
    Sum(M10 + M11 + M12) As QTR4,
    Region,
    Decode(Region,'USSC','Chris Johnson','USEC','Christian Villarroel','USNC','Michael Braun','USWC','RM USWC','UNASSIGNED','Brian Bashaw',Null) As Regionmgr,
    Sum(M1+ M2 + M3 + M4 + M5 + M6 + M7 + M8 + M9 + M10 + M11 + M12) As Year
From
    KD_Rep_Quotas
Group By
    Territory_Number,
    Rep_Name,
    Region,
    Decode(Region,'USSC','Chris Johnson','USEC','Christian Villarroel','USNC','Michael Braun','USWC','RM USWC','UNASSIGNED','Brian Bashaw',Null)