CREATE OR REPLACE FORCE VIEW "IFSAPP"."KD_CY_SALES" (
    "CUSTOMER_NO",
    "CYSALES",
    "CYIMPL",
    "CYBIO"
) AS
    SELECT
        Customer_No,
        SUM(Allamounts) AS Cysales,
        SUM(
            CASE
                WHEN Part_Product_Code = 'IMPL' THEN Allamounts
                ELSE 0
            END
        ) AS Cyimpl,
        SUM(
            CASE
                WHEN Part_Product_Code = 'REGEN' THEN Allamounts
                ELSE 0
            END
        ) AS Cybio
    FROM
        Kd_Sales_Data_Request A
    WHERE
        EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
        A.Charge_Type = 'Parts' AND
        --A.Corporate_Form = 'DOMDIR' AND
        A.Catalog_No != '3DBC-22001091' AND
        (
            (
                A.Order_No NOT LIKE 'W%' AND
                A.Order_No NOT LIKE 'X%'
            ) OR
            A.Order_No IS NULL
        ) AND
        (
            A.Market_Code != 'PREPOST' OR
            A.Market_Code IS NULL
        ) AND
        A.Invoice_Id != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
        (
            A.Order_No != 'C512921' Or A.Order_No Is Null
        ) --Kevin Stack's order/return that spanned years.
    GROUP BY
        Customer_No;