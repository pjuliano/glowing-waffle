--Add Inventory Part Characteristic template
DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := 'AAAUN9AARAAAt3zAAA'; --p1
    C_   VARCHAR2(32000) := '20181206124105'; --p2
    D_   VARCHAR2(32000) := 'ENG_ATTRIBUTE'
                             || Chr(31)
                             || 'PROC'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    For Parts In (  Select
                        A.ObjID,
                        A.ObjVersion,
                        B.Eng_Attribute
                    From
                        Inventory_Part A,
                        KD_Data_Migration B
                    Where
                        A.PArt_No = B.Part_No)
    Loop
        A_ := Null;
        B_ := Parts.ObjID;
        C_ := Parts.ObjVersion;
        D_ :=   'ENG_ATTRIBUTE'
                 || Chr(31)
                 || Parts.Eng_Attribute
                 || Chr(30); --p3
        E_ := 'DO';
        Ifsapp.Inventory_Part_Api.Modify__(A_,B_,C_,D_,E_);
    End Loop;
END;