--Not needed for Paltop Migration.
DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAURcAAIAAM28EABD'; --p1
   c_ VARCHAR2(32000) := '20120326174233'; --p2
   d_ VARCHAR2(32000) := NULL; --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN

    
IFSAPP.PROD_STRUCT_ALTERNATE_API.PLAN__( a_ , b_ , c_ , d_ , e_ );

   ----------------------------------
   ---Dbms_Output Section---
   ----------------------------------
   Dbms_Output.Put_Line('a_=' || a_);
   Dbms_Output.Put_Line('b_=' || b_);
   Dbms_Output.Put_Line('c_=' || c_);
   Dbms_Output.Put_Line('d_=' || d_);
   Dbms_Output.Put_Line('e_=' || e_);
   ----------------------------------

END;
