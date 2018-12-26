--Modify existing.
DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := 'AAAUVBAAIAAMmFhAA0'; --p1
    C_   VARCHAR2(32000) := '20181220110016'; --p2
    D_   VARCHAR2(32000) := 'EFF_PHASE_IN_DATE'
                             || Chr(31)
                             || '2008-12-02-00.00.00'
                             || Chr(30)
                             || 'REVISION_TEXT'
                             || Chr(31)
                             || 'U'
                             || Chr(30)
                             || 'ENG_REVISION'
                             || Chr(31)
                             || 'KD01'
                             || Chr(30)
                             || 'ENG_REVISION_DESC'
                             || Chr(31)
                             || 'Silly Nilly'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN FOR Parts IN (SELECT A.Objid, A.Objversion, B.* FROM Part_Revision A, Kd_Data_Migration B WHERE A.Part_No = B.Part_No)
    Loop
        A_ := NULL;
        B_ := Parts.Objid;
        C_ := Parts.Objversion;
        D_ :=   'EFF_PHASE_IN_DATE'
                 || Chr(31)
                 || To_Char(To_Date(Parts.Eff_Phase_In_Date,'MM/DD/YYYY'),'YYYY-MM-DD-HH24:MI:SS')
                 || Chr(30)
                 || 'REVISION_TEXT'
                 || Chr(31)
                 || Parts.Revision_Text
                 || Chr(30)
                 || 'ENG_REVISION'
                 || Chr(31)
                 || Parts.Eng_Revision
                 || Chr(30)
                 || 'ENG_REVISION_DESC'
                 || Chr(31)
                 || Parts.Eng_Revision_Desc
                 || Chr(30); --p3
        E_ := 'DO';
        Ifsapp.Part_Revision_Api.Modify__(A_,B_,C_,D_,E_);
    End Loop;
END;
