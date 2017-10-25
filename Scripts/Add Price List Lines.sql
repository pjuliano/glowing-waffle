Declare
   A_   Varchar2(32000) := Null;     -- __lsResult
   B_   Varchar2(32000) := Null;     -- __sObjid
   C_   Varchar2(32000) := Null;     -- __lsObjversion
   D_   Varchar2(32000) := Null;
   E_   Varchar2(32000) := 'DO';     -- __sAction
Begin
    
    For Cur In (Select 
                  A.Catalog_No,
                  '100' As Site,
                  Sales_Part_Api.Get_List_Price('100',A.Catalog_No) As Base_Price,
                  '0' As Minimum_Qty,
                  (To_Char(Sysdate,'YYYY-MM-DD') || '-00:00:00') As Valid_From_Date,
                  A.Percentage_Offset,
                  '0' As Amount_Offset,
                  Sales_Part_Api.Get_List_Price('100',A.Catalog_No) * ((100 + A.Percentage_Offset)/100) As Sales_Price,
                  '2' As Rounding,
                  A.Price_List_No
                From 
                  Kd_Price_List_Upload A
                Where
                  A.Status Is Null)
		Loop
      Update Kd_Price_List_Upload A Set A.Status = 'FAILED' Where A.Catalog_No = Cur.Catalog_No And A.Price_List_No = Cur.Price_List_No;
      Commit;
		  D_ := 'CATALOG_NO' || Chr(31) || Cur.Catalog_No || Chr(30) || 'BASE_PRICE_SITE' || Chr(31) || Cur.Site || Chr(30) || 'BASE_PRICE' || Chr(31) || Cur.Base_Price || Chr(30) || 'MIN_QUANTITY' || Chr(31) || Cur.Minimum_Qty || Chr(30) || 'VALID_FROM_DATE' || Chr(31) || Cur.Valid_From_Date || Chr(30) || 'PERCENTAGE_OFFSET' || Chr(31) || Cur.Percentage_Offset || Chr(30) || 'AMOUNT_OFFSET' || Chr(31) || Cur.Amount_Offset || Chr(30) || 'SALES_PRICE' || Chr(31) || Cur.Sales_Price || Chr(30) || 'ROUNDING' || Chr(31) || Cur.Rounding || Chr(30) || 'BASE_PRICE' || Chr(31) || Cur.Base_Price || Chr(30) || 'PRICE_LIST_NO' || Chr(31) || Cur.Price_List_No || Chr(30) || '';
	    Ifsapp.Sales_Price_List_Part_Api.New__( A_, B_, C_, D_, E_ );
      Update KD_Price_List_Upload A Set A.Status = 'SUCCESS' Where A.CAtalog_No = Cur.Catalog_No;
      Commit;
	 End Loop;

   -------------------------------------------
   --- Dbms_Output Section ---
   -------------------------------------------
   Dbms_Output.Put_Line('a_ = ' || A_);
   Dbms_Output.Put_Line('b_ = ' || B_);
   Dbms_Output.Put_Line('c_ = ' || C_);
   Dbms_Output.Put_Line('d_ = ' || D_);
   Dbms_Output.Put_Line('e_ = ' || E_);
   -------------------------------------------
End;