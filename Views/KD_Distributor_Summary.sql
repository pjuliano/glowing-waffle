CREATE OR REPLACE VIEW Kd_Distributor_Summary AS
    SELECT
        A.Customer_No,
        A.Customer_Name,
        A.Corporate_Form,
        SUM(
            CASE
                WHEN A.Invoicedate = Trunc(SYSDATE) THEN A.Allamounts
                ELSE 0
            END
        ) AS Today,
        SUM(
            CASE
                WHEN EXTRACT(MONTH FROM A.Invoicedate) = EXTRACT(MONTH FROM SYSDATE) AND
                     EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) THEN A.Allamounts
                ELSE 0
            END
        ) AS Current_Month,
        SUM(
            CASE
                WHEN EXTRACT(MONTH FROM A.Invoicedate) = EXTRACT(MONTH FROM SYSDATE) AND
                     EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
                     A.Part_Product_Code = 'REGEN' THEN A.Allamounts
                ELSE 0
            END
        ) AS Cm_Bio,
        SUM(
            CASE
                WHEN EXTRACT(MONTH FROM A.Invoicedate) = EXTRACT(MONTH FROM SYSDATE) AND
                     EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
                     A.Part_Product_Code != 'REGEN' THEN A.Allamounts
                ELSE 0
            END
        ) AS Cm_Implants,
        SUM(
            CASE
                WHEN EXTRACT(MONTH FROM A.Invoicedate) = EXTRACT(MONTH FROM SYSDATE) AND
                     EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
                     A.Part_Product_Family = 'PRIMA' THEN A.Allamounts
                ELSE 0
            END
        ) AS Cm_Prima,
        SUM(
            CASE
                WHEN EXTRACT(MONTH FROM A.Invoicedate) = EXTRACT(MONTH FROM SYSDATE) AND
                     EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
                     A.Part_Product_Family = 'PRMA+' THEN A.Allamounts
                ELSE 0
            END
        ) AS "CM_PRMA+",
        SUM(
            CASE
                WHEN EXTRACT(MONTH FROM A.Invoicedate) = EXTRACT(MONTH FROM SYSDATE) AND
                     EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
                     A.Part_Product_Family = 'GNSIS' THEN A.Allamounts
                ELSE 0
            END
        ) AS Cm_Gnsis,
        SUM(
            CASE
                WHEN TO_CHAR(A.Invoicedate,'Q') > 1 THEN(
                    CASE
                        WHEN TO_CHAR(A.Invoicedate,'Q') = TO_CHAR(SYSDATE,'Q') - 1 AND
                             EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) THEN A.Allamounts
                        ELSE 0
                    END
                )
                WHEN TO_CHAR(A.Invoicedate,'Q') = 1 THEN(
                    CASE
                        WHEN TO_CHAR(A.Invoicedate,'Q') = 4 AND
                             EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) - 1 THEN A.Allamounts
                        ELSE 0
                    END
                )
                ELSE 0
            END
        ) AS Pq,
        SUM(
            CASE
                WHEN TO_CHAR(A.Invoicedate,'Q') = TO_CHAR(SYSDATE,'Q') AND
                     EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) THEN A.Allamounts
                ELSE 0
            END
        ) AS Cq,
        SUM(
            CASE
                WHEN A.Invoicedate BETWEEN TO_DATE('01/01/'
                                                     || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1),'MM/DD/YYYY') AND TO_DATE(TO_CHAR(EXTRACT(MONTH FROM SYSDATE) )
                                                                                                                                   || '/'
                                                                                                                                   || TO_CHAR(EXTRACT(DAY FROM SYSDATE) )
                                                                                                                                   || '/'
                                                                                                                                   || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1),'MM/DD/YYYY') AND
                     TO_CHAR(A.Invoicedate,'Q') = TO_CHAR(SYSDATE,'Q') THEN A.Allamounts
                ELSE 0
            END
        ) AS Pyqtd,
        SUM(
            CASE
                WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) THEN A.Allamounts
                ELSE 0
            END
        ) AS Cy,
        SUM(
            CASE
                WHEN A.Invoicedate BETWEEN TO_DATE('01/01/'
                                                     || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1),'MM/DD/YYYY') AND TO_DATE(TO_CHAR(EXTRACT(MONTH FROM SYSDATE) )
                                                                                                                                   || '/'
                                                                                                                                   || TO_CHAR(EXTRACT(DAY FROM SYSDATE) )
                                                                                                                                   || '/'
                                                                                                                                   || TO_CHAR(EXTRACT(YEAR FROM SYSDATE) - 1),'MM/DD/YYYY') THEN A.Allamounts
                ELSE 0
            END
        ) AS Pytd
    FROM
        Kd_Sales_Data_Request A
    WHERE
        A.Corporate_Form IN (
            'DOMDIS',
            'ASIA',
            'EUR',
            'CAN',
            'LA'
        ) AND
        A.Charge_Type = 'Parts' AND
        EXTRACT(YEAR FROM A.Invoicedate) >= EXTRACT(YEAR FROM SYSDATE) - 2 AND
        A.Customer_Name NOT LIKE 'Dr%' AND
        A.Customer_No NOT IN (
            'B3563',
            'B1882',
            'B1419',
            'IT001014',
            'I44776'
        )
    GROUP BY
        A.Customer_No,
        A.Customer_Name,
        A.Corporate_Form