 SELECT
        'GlobalDist' AS Segment,
        Case When A.Region_Code = 'USDI' Then 'US'
             When A.Region_Code = 'CANA' Then 'CAN'
             Else A.Region_Code
        End As Region_Code,
        SUM(
            CASE
                WHEN A.Invoicedate = Trunc(SYSDATE) THEN A.Allamounts
                ELSE 0
            END
        ) AS Today_Sales,
        SUM(
            CASE
                WHEN EXTRACT(MONTH FROM A.Invoicedate) = EXTRACT(MONTH FROM SYSDATE) AND
                     EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) THEN A.Allamounts
                ELSE 0
            END
        ) AS Mtd,
        E.Mtd_Quota Mtd_Goal,
        SUM(
            CASE
                WHEN EXTRACT(MONTH FROM A.Invoicedate) = EXTRACT(MONTH FROM SYSDATE) AND
                     EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) THEN A.Allamounts
                ELSE 0
            END
        ) - E.Mtd_Quota Mtd_Variance,
        SUM(
            CASE
                WHEN DECODE(EXTRACT(MONTH FROM SYSDATE),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11
,'QTR4',12,'QTR4') = DECODE(EXTRACT(MONTH FROM A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3'
,9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') AND
                     EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) THEN A.Allamounts
                ELSE 0
            END
        ) AS Qtd,
        F.Qtd_Quota Qtd_Goal,
        SUM(
            CASE
                WHEN DECODE(EXTRACT(MONTH FROM SYSDATE),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11
,'QTR4',12,'QTR4') = DECODE(EXTRACT(MONTH FROM A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3'
,9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') AND
                     EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) THEN A.Allamounts
                ELSE 0
            END
        ) - F.Qtd_Quota Qtd_Variance,
        SUM(
            CASE
                WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) THEN A.Allamounts
                ELSE 0
            END
        ) AS Ytd,
        G.Ytd_Quota Ytd_Goal,
        SUM(
            CASE
                WHEN EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) THEN A.Allamounts
                ELSE 0
            END
        ) - G.Ytd_Quota Ytd_Variance
    FROM
        Kd_Sales_Data_Request A,
        Kd_Nadis_Month_Quota E,
        Kd_Nadis_Qtr_Quota F,
        Kd_Nadis_Year_Quota G
    WHERE
        E.Region = F.Region AND
        E.Region = G.Region AND
        A.Charge_Type = 'Parts' AND
        EXTRACT(YEAR FROM A.Invoicedate) = EXTRACT(YEAR FROM SYSDATE) AND
        A.Corporate_Form IN (
            'CAN',
            'DOMDIS'
        ) AND
        A.Region_Code != 'ITL' AND
        A.District_Code = E.Region
    GROUP BY
        'GlobalDist',
        Case When A.Region_Code = 'USDI' Then 'US'
             When A.Region_Code = 'CANA' Then 'CAN'
             Else A.Region_Code
        End,
        E.Mtd_Quota,
        F.Qtd_Quota,
        G.Ytd_Quota;