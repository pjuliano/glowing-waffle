DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := 'AAAUe3AAIAAMrriAAA'; --p1
    C_   VARCHAR2(32000) := '20181207160511'; --p2
    D_   VARCHAR2(32000) := 'ENG_ATTRIBUTE'
                             || Chr(31)
                             || 'MIGR'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    Ifsapp.Sales_Part_Api.Modify__(A_,B_,C_,D_,E_);
END;