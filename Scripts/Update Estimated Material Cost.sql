DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUNvAAIAAM2piAAC'; --p1
   c_ VARCHAR2(32000) := '20180103132853'; --p2
   d_ VARCHAR2(32000) := 'ESTIMATED_MATERIAL_COST'||chr(31)||'5165.7'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    FOR invparts IN
        (
            SELECT          kd_data_migration.part_no,
                            kd_data_migration.estimated_material_cost,
                            inventory_part_config.objid,
                            inventory_part_config.objversion
              FROM          inventory_part_config,
                            kd_data_migration
             WHERE          inventory_part_config.contract = '100'
               AND          kd_data_migration.part_no = inventory_part_config.part_no
        )
    LOOP
        a_ := '';
        b_ := invparts.objid;
        c_ := invparts.objversion;
        d_ := 'ESTIMATED_MATERIAL_COST'||chr(31)||invparts.estimated_material_cost||chr(30);
        e_ := 'DO';
        IFSAPP.INVENTORY_PART_CONFIG_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    END LOOP;
END;
