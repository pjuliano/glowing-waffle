select lo.*, ao.object_name from v_$locked_object lo, all_objects ao
where lo.object_id = ao.object_id
/
