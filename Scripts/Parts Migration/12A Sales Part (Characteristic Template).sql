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
    For Parts In (Select A.ObjID, A.ObjVersion, B.* From Sales_Part A, KD_Data_Migration B Where A.Part_No = B.Part_No)
    Loop
        A_ := Null;
        B_ := Parts.Objid;
        C_ := Parts.ObjVersion;
        D_ :=   'ENG_ATTRIBUTE'
                 || Chr(31)
                 || 'MIGR'
                 || Chr(30); --p3
        E_ := 'DO';
        Ifsapp.Sales_Part_Api.Modify__(A_,B_,C_,D_,E_);
    End Loop;
END;