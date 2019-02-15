Truncate Table KD_view_Source;
Insert into KD_view_source SELECT view_name, to_lob(text) FROM all_views;
Select * From KD_View_Source Where Text Like '%CR1001802096%' and Text Not Like '%C512921%';
