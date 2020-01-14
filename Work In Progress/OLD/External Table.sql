DROP TABLE kd_pl_import_ext;
CREATE TABLE kd_pl_import_ext
    (
        price_list_no VARCHAR2(4000),
        catalog_no VARCHAR2(4000),
        description VARCHAR2(4000),
        current_sales_price VARCHAR2(4000),
        new_price VARCHAR2(4000)
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
                PRICE_LIST_NO,
                CATALOG_NO,
                DESCRIPTION,
                CURRENT_SALES_PRICE,
                NEW_PRICE
            )
        )
        LOCATION ('can.csv')
    )
    REJECT LIMIT UNLIMITED;