DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUe3AAIAAAEkDAAA'; --p1
   c_ VARCHAR2(32000) := '20170216154652'; --p2
   d_ VARCHAR2(32000) := 'SALES_PRICE_GROUP_ID'||chr(31)||'DYNAG'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    For Parts in (  Select
                        OBJID,
                        OBJVersion,
                        Inventory_Part_Api.Get_Part_Product_Family(Contract,Catalog_No) As Family
                    From
                        Sales_Part
                    Where
                        ActiveInd_DB = 'Y' And
                        Contract = '100' And
                        Inventory_Part_Api.Get_Part_Product_Family(Contract,Catalog_No) In ('TARGET',
                                                                                            'DYNAC',
                                                                                            'PRMA+',
                                                                                            'EXHEX',
                                                                                            'CYTOP',
                                                                                            'IHMAX',
                                                                                            'PCOMM',
                                                                                            'SIMPLNT',
                                                                                            'DYNAB',
                                                                                            'DYNAM',
                                                                                            'SUST',
                                                                                            'SYNTH',
                                                                                            'ZMAX',
                                                                                            'CALMA',
                                                                                            'MTF',
                                                                                            'RESTO',
                                                                                            'COMM',
                                                                                            'TLMAX',
                                                                                            'TEFGE',
                                                                                            'GNSIS',
                                                                                            'OTMED',
                                                                                            'CONNX',
                                                                                            'STAGE',
                                                                                            'TRINX',
                                                                                            'BVINE',
                                                                                            'RENOV',
                                                                                            'DYNAG',
                                                                                            'CALFO',
                                                                                            'BONE',
                                                                                            'MEMB',
                                                                                            'SW',
                                                                                            'DRILL',
                                                                                            'COL',
                                                                                            'EG',
                                                                                            'REGEN',
                                                                                            'XP1',
                                                                                            'MOTOR',
                                                                                            'IMPLNT',
                                                                                            'GOLD',
                                                                                            'ED',
                                                                                            '*',
                                                                                            'PROS',
                                                                                            'SURG',
                                                                                            'PRIMA',
                                                                                            'OTMEDICAL'))
    Loop
        A_ := '';
        B_ := Parts.ObjID;
        C_ := Parts.Objversion;
        D_ := 'SALES_PRICE_GROUP_ID'||chr(31)||Parts.Family||chr(30);
        E_ := 'DO';
        IFSAPP.SALES_PART_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    End Loop;
END;
