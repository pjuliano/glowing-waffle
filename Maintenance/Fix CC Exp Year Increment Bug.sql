Delete From   
  Language_Sys_Tab
Where  
  Type = 'Logical Unit' And
  Path = 'CreditExpYear' And
  Attribute = 'Client Values';
Commit;

Delete From 
  Language_Context_Tab T
Where 
  Path Like 'CreditExpYear.20%';
Commit;

Begin
  Language_Sys.Refresh_Language_Dictionary_(Lang_Code_ => 'en',
                                            Component_ => 'CRECAR',
                                            Term_Id_ => Null,
                                            Auto_Transaction_ => 'FALSE'); 
End;
