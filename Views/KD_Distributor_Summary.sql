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
            'I44776',
            'B3728',
            'B2970',
            'B3605',
            '30127',
            'B2967',
            'B3638',
            'B2971',
            'B2968',
            'B3114',
            'IT005061',
            'B6625',
            'B6503',
            '32517',
            'B6646',
            'IT005041',
            'B6546',
            'IT000916',
            'B3155',
            'B6706',
            'B6532',
            'IT005058',
            'B6684',
            'IT000807',
            'B6552',
            'B6488',
            'B2940',
            'B6782',
            '32527',
            'IT005270',
            'IT000387',
            'B6705',
            'B3584',
            'B2492',
            'B6783',
            'B6645',
            'B6636',
            'B3667',
            'B6676',
            'B6536',
            'B3324',
            'B3055',
            'B6551',
            'B2960',
            'B6512',
            'B3568'     )
    GROUP BY
        A.Customer_No,
        A.Customer_Name,
        A.Corporate_Form