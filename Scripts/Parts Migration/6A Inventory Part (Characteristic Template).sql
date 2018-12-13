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
    Ifsapp.Inventory_Part_Api.Modify__(A_,B_,C_,D_,E_);

   ----------------------------------
   ---Dbms_Output Section---
   ----------------------------------
    Dbms_Output.Put_Line('a_=' || A_);
    Dbms_Output.Put_Line('b_=' || B_);
    Dbms_Output.Put_Line('c_=' || C_);
    Dbms_Output.Put_Line('d_=' || D_);
    Dbms_Output.Put_Line('e_=' || E_);
   ----------------------------------
END;