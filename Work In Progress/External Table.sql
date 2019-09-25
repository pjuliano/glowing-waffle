DROP TABLE kd_sales_object_import_ext;
CREATE TABLE kd_sales_object_import_ext
    (
        pn VARCHAR2(4000),
        descr VARCHAR2(4000),
        listp VARCHAR2(4000)
    )
    ORGANIZATION EXTERNAL
    (
        TYPE oracle_loader
        DEFAULT DIRECTORY BI
        ACCESS PARAMETERS
        ( 
            RECORDS DELIMITED BY NEWLINE
            SKIP 1
            NOBADFILE 
            NOLOGFILE
            FIELDS TERMINATED BY ',' 
            MISSING FIELD VALUES ARE NULL
            (
                pn,
                descr,
                listp
            )
        )
        LOCATION ('Sales Object Import.csv')
    )
    REJECT LIMIT UNLIMITED;