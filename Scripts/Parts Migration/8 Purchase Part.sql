DECLARE
    A_   VARCHAR2(32000) := ''; --p0
    B_   VARCHAR2(32000) := 'AAAUanAAIAAM9FpAAh'; --p1
    C_   VARCHAR2(32000) := '20181207143912'; --p2
    D_   VARCHAR2(32000) := 'BUYER_CODE'
                             || Chr(31)
                             || 'JMPICARIELLO'
                             || Chr(30)
                             || 'STAT_GRP'
                             || Chr(31)
                             || 'IMPL'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    Ifsapp.Purchase_Part_Api.Modify__(A_,B_,C_,D_,E_);
END;