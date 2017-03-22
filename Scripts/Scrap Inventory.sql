Declare
   A_ Varchar2(32000) := '210'; --p0 Site
   B_ Varchar2(32000) := '7357'; --p1 Part
   C_ Varchar2(32000) := '*'; --p2 Config
   D_ Varchar2(32000) := '2003K'; --p3 Location
   E_ Varchar2(32000) := 'I19CC'; --p4 Lot
   F_ Varchar2(32000) := '*'; --p5 Serial
   G_ Varchar2(32000) := '1'; --p6 Eng Chg
   H_ Varchar2(32000) := '*'; --p7 W/D/R
   I_ Float := 3; --p8 Qty
   J_ Float := Null; --p9
   K_ Varchar2(32000) := '1251'; --p10 
   L_ Varchar2(32000) := '0000'; --p11
   M_ Varchar2(32000) := ''; --p12
   N_ Varchar2(32000) := ''; --p13
   O_ Varchar2(32000) := ''; --p14
   P_ Varchar2(32000) := ''; --p15
   Q_ Varchar2(32000) := ''; --p16
   R_ Varchar2(32000) := ''; --p17
   S_ Varchar2(32000) := ''; --p18
   T_ Varchar2(32000) := ''; --p19
   U_ Varchar2(32000) := ''; --p20
   V_ Float := Null; --p21
   W_ Varchar2(32000) := ''; --p22
Begin
   For Cur In (Select * From Kd_Scrap Where Comments is Null)
   Loop
     A_ := Cur.Site;
     B_ := Cur.Part_No;
     C_ := '*';
     D_ := Cur.Location;
     E_ := Cur.Lot;
     F_ := '*';
     G_ := Cur.Eng_Chg;
     H_ := '*';
     I_ := Cur.Qty;
     J_ := Null;
     K_ := '1251';
     L_ := '0000';
     M_ := '';
     N_ := '';
     O_ := '';
     P_ := '';
     Q_ := '';
     R_ := '';
     S_ := '';
     T_ := '';
     U_ := '';
     V_ := Null;
     W_ := '';
     Update Kd_Scrap A Set A.Comments = 'Failed' Where A.Part_No = Cur.Part_No And A.Location = Cur.Location And A.Lot = Cur.Lot;
     Commit;
     Ifsapp.Inventory_Part_In_Stock_Api.Issue_Part_With_Posting(A_ , B_ , C_ , D_ , E_ , F_ , G_ , H_ , 0, 'NISS', I_ , J_ , K_ , L_ , M_ , N_ , O_ , P_ , Q_ , R_ , S_ , T_ , U_ , V_ , W_ );
     Commit;
     Update Kd_Scrap A Set A.Comments = 'Success' Where A.Part_No = Cur.Part_No And A.Location = Cur.Location And A.Lot = Cur.Lot;
     Commit;
  End Loop;
End;
