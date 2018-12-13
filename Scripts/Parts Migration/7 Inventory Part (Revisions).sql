DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := NULL; --p1
    C_   VARCHAR2(32000) := NULL; --p2
    D_   VARCHAR2(32000) := 'CONTRACT'
                             || Chr(31)
                             || '100'
                             || Chr(30)
                             || 'PART_NO'
                             || Chr(31)
                             || 'PT-TEST-4'
                             || Chr(30)
                             || 'ENG_CHG_LEVEL'
                             || Chr(31)
                             || ''
                             || Chr(30)
                             || 'EFF_PHASE_IN_DATE'
                             || Chr(31)
                             || '2018-12-07-00.00.00'
                             || Chr(30)
                             || 'REVISION_TEXT'
                             || Chr(31)
                             || '2'
                             || Chr(30)
                             || 'EFFECTIVE_STATUS'
                             || Chr(31)
                             || 'Not In Effect'
                             || Chr(30)
                             || 'EFFECTIVE_REPAIR_STATUS'
                             || Chr(31)
                             || 'Not In Effect'
                             || Chr(30)
                             || 'ENG_REVISION'
                             || Chr(31)
                             || 'U'
                             || Chr(30)
                             || 'ENG_REVISION_DESC'
                             || Chr(31)
                             || 'Description text'
                             || Chr(30)
                             || 'PART_REVISION_LOCK'
                             || Chr(31)
                             || 'Not locked'
                             || Chr(30)
                             || 'PART_REVISION_REPORT'
                             || Chr(31)
                             || 'No Report'
                             || Chr(30)
                             || 'PART_REVISION_STATUS'
                             || Chr(31)
                             || 'Not decided'
                             || Chr(30)
                             || 'PART_REVISION_USAGE'
                             || Chr(31)
                             || 'Unlimited'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    Ifsapp.Part_Revision_Api.New__(A_,B_,C_,D_,E_);
END;