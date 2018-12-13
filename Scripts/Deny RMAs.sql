DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUd9AAIAAMg43AA0'; --p1
   c_ VARCHAR2(32000) := '20080922100121'; --p2
   d_ VARCHAR2(32000) := NULL; --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    For RMAS In (   Select
                        RM.Rma_No,
                        RM.ObjVersion,
                        RM.ObjID,
                        RM.Date_Requested,
                        RM.Cust_Ref,
                        Count(RL.RMA_No) As Planned_Lines,
                        Sum(Rl.Qty_To_Return * Rl.Base_Sale_Unit_Price) As Total_Pending$
                    From
                        Return_Material RM Left Join Return_Material_Line RL
                            On RM.RMA_No = RL.Rma_No And
                               RL.State = 'Planned'
                    Where
                        RM.State = 'Planned' And
                        RM.Date_Requested < To_Date('12/01/2016','MM/DD/YYYY') And
                        RM.RMA_No Not In ('4584','39220','41473','31725')
                    Group By
                        RM.RMA_No,
                        RM.OBJVersion,
                        RM.OBJID,
                        RM.Date_Requested,
                        RM.Cust_Ref
                    Having
                        Count(RL.RMA_No) = 0 Or (Sum(Rl.Qty_To_Return * Rl.Base_Sale_Unit_Price) Is Null Or Sum(Rl.Qty_To_Return * Rl.Base_Sale_Unit_Price) = 0)
                    Order By
                        RM.Date_Requested Asc)
    Loop
        A_ := Null;
        B_ := RMAS.OBJID;
        C_ := RMAS.OBJVERSION;
        D_ := 'NULL';
        E_ := 'DO';
        IFSAPP.RETURN_MATERIAL_API.DENY__( a_ , b_ , c_ , d_ , e_ );
    End Loop;
END;
