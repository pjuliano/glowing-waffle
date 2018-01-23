Create Or Replace Procedure Kd_Search_Text As 
Begin
Declare
  Match_Count Number;
-- Type the owner of the tables you are looking at
  V_Owner Varchar2(255) :='IFSAPP';

-- Type the data type you are look at (in CAPITAL)
-- VARCHAR2, NUMBER, etc.
  V_Data_Type Varchar2(255) :='VARCHAR2';

-- Type the string you are looking at
  V_Search_String Varchar2(4000) := '%would mail them separately%';

  V_Table_Column Varchar2(2000);
Begin
  For T In (Select Table_Name, Column_Name From All_Tab_Cols Where Owner=V_Owner And Data_Type = V_Data_Type) 
  Loop
    V_Table_Column := T.Table_Name || '.' || T.Column_Name;
    Execute Immediate 
      'SELECT COUNT(*) FROM '||T.Table_Name||' WHERE '||T.Column_Name||' LIKE :1'
      Into Match_Count
      Using V_Search_String;
    If Match_Count > 0 Then
      Execute Immediate
          'INSERT INTO KD_SEARCHRESULTS Values (:1)'
      Using V_Table_Column;
    End If;
  End Loop;
End;
End;