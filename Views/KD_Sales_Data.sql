--Create or Replace View Kd_Sales_Data As
    SELECT
        DECODE(A.Company,'241','240',A.Company) AS Site,
        B.Series_Id || B.Invoice_No AS Invoice_Id,
        TO_CHAR(A.Item_Id) AS Item_Id,
        Trunc(B.D2) AS Invoicedate,
        CASE
                WHEN B.Series_Id = 'CR' AND
                     B.N2 IS NULL THEN 0
                WHEN B.Series_Id = 'CR' AND
                     B.N2 IS NOT NULL THEN A.N2 *-1
                ELSE A.N2
            END
        AS Invoiced_Qty,
        A.N4 AS Sale_Unit_Price,
        A.N5 AS Discount,
        A.Net_Curr_Amount,
        A.Net_Curr_Amount + A.Vat_Curr_Amount AS Gross_Curr_Amount,
        C.Catalog_Desc,
        Customer_Info_Api.Get_Name(B.Identity) AS Customer_Name,
        A.C1 AS Order_No,
        A.C13 AS Customer_No,
        D.Cust_Grp,
        A.C5 AS Catalog_No,
        Substr(B.C1,1,35) AS Authorize_Code,
        D.Salesman_Code,
        E.Commission_Receiver,
        F.District_Code,
        F.Region_Code,
        Trunc(B.Creation_Date) AS Createdate,
        DECODE(A.C5,G.Part_No,G.Part_Product_Code,'OTHER') AS Part_Product_Code,
        DECODE(A.C5,G.Part_No,G.Part_Product_Family,'OTHER') AS Part_Product_Family,
        DECODE(A.C5,G.Part_No,G.Second_Commodity,'OTHER') AS Second_Commodity,
        CASE
                WHEN TO_CHAR(B.D2,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(B.D2,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(B.D2,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(B.D2,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(B.D2,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(B.D2,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(B.D2,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(B.D2,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(B.D2,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(B.D2,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(B.D2,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(B.D2,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM B.D2)
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM B.D2)
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM B.D2)
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM B.D2)
            END
        AS Invoiceqtryr,
        TO_CHAR(B.D2,'MM/YYYY') AS Invoicemthyr,
        Q.Group_Id AS Group_Id,
        DECODE(A.C5,G.Part_No,G.Type_Designation,'Non-Target') AS Type_Designation,
        A.Identity AS Customer_No_Pay,
        H.Corporate_Form,
        DECODE(B.Currency,'SEK', (A.Net_Curr_Amount * 0.13),'EUR', (A.Net_Curr_Amount * 1.4),'DKK', (A.Net_Curr_Amount * 0.13),A.Net_Curr_Amount) AS
Fixedamounts,
        CASE
                WHEN B.Currency = 'CAD' AND
                     Trunc(B.D2) >= TO_DATE('03/01/2013','MM/DD/YYYY') THEN A.Net_Curr_Amount
                WHEN B.Currency != 'USD' THEN A.Net_Curr_Amount * I.Currency_Rate
                ELSE A.Net_Curr_Amount
            END
        AS Allamounts,
        CASE
                WHEN B.Currency IN (
                    'SEK',
                    'DKK'
                ) THEN A.Net_Curr_Amount / J.Currency_Rate
                ELSE A.Net_Curr_Amount
            END
        AS Localamount,
        A.Net_Curr_Amount AS Truelocalamt,
        A.Vat_Dom_Amount,
        A.Vat_Code,
        CASE
                WHEN A.C5 = K.Part_No THEN K.Inventory_Value
                ELSE L.Inventory_Value * 1.4
            END
        AS Cost,
        'Parts' AS Charge_Type,
        'IFS' AS Source,
        M.Market_Code,
        H.Association_No,
        B.Vat_Curr_Amount,
        Payment_Term_Api.Get_Description(B.Company,B.Pay_Term_Id) AS Pay_Term_Description,
        Substr(B.C1,1,35) AS Kdreference,
        Substr(B.C2,1,30) AS Customerref,
        TO_CHAR(B.D3,'MM/DD/YYYY') AS Deliverydate,
        Substr(B.C3,1,35) AS Ship_Via,
        B.Delivery_Identity,
        B.Identity,
        B.Delivery_Address_Id,
        B.Invoice_Address_Id,
        B.Currency,
        B.N2 AS Rma_No,
        N.Address1 AS Invoiceadd1,
        N.Address2 AS Invoiceadd2,
        N.City AS Invoicecity,
        N.State AS Invoicestate,
        N.Zip_Code AS Invoicezip,
        Iso_Country_Api.DECODE(N.Country) AS Invoicecountry,
        N.County AS Invoicecounty,
        O.Address1 AS Delivadd1,
        O.Address2 AS Delivadd2,
        O.City AS Delivcity,
        O.State AS Delivstate,
        O.Zip_Code AS Delivzip,
        Iso_Country_Api.DECODE(O.Country) AS Delivcountry,
        O.County AS Delivcounty
    FROM
        Invoice_Item_Tab A
        LEFT JOIN Sales_Part_Tab C ON A.C5 = C.Catalog_No AND
                                      DECODE(A.Company,'241','240',A.Company) = C.Contract
        LEFT JOIN Cust_Def_Com_Receiver_Tab E ON A.C13 = E.Customer_No
        LEFT JOIN Inventory_Part_Tab G ON A.C5 = G.Part_No AND
                                          DECODE(A.Company,'241','240',A.Company) = G.Contract
        LEFT JOIN Kd_Cost_100 K ON A.C5 = K.Part_No
        LEFT JOIN Kd_Cost_210 L ON A.C5 = L.Part_No
        LEFT JOIN Customer_Order_Tab M ON A.C1 = M.Order_No
        LEFT JOIN Identity_Invoice_Info_Tab Q ON A.Company = Q.Company AND
                                                 A.Identity = Q.Identity AND
                                                 A.Party_Type = Q.Party_Type,Invoice_Tab B
        LEFT JOIN Kd_Currency_Rate_4 I ON B.Currency = I.Currency_Code AND
                                          TO_CHAR(B.D2,'MM/YYYY') = I.Valid_From
        LEFT JOIN Customer_Info_Address_Tab N ON B.Identity = N.Customer_Id AND
                                                 B.Invoice_Address_Id = N.Address_Id
        LEFT JOIN Customer_Info_Address_Tab O ON B.Identity = O.Customer_Id AND
                                                 B.Delivery_Address_Id = O.Address_Id
        LEFT JOIN Kd_Currency_Rate_1 J ON B.Currency = J.Currency_Code AND
                                          TO_CHAR(B.D2,'MM/YYYY') = J.Valid_From,
        Cust_Ord_Customer_Tab D,
        Cust_Ord_Customer_Address_Tab F,
        Customer_Info_Tab H
    WHERE
        A.Invoice_Id = B.Invoice_Id AND
        A.C11 IS NULL AND
        A.C13 = D.Customer_No AND
        B.Delivery_Identity = D.Customer_No AND
        A.C13 = F.Customer_No AND
        A.C13 = H.Customer_Id AND
        H.Customer_Id = D.Customer_No AND
        H.Customer_Id = F.Customer_No AND
        B.Delivery_Identity = H.Customer_Id AND
        B.Rowstate != 'Preliminary' AND
        F.Addr_No = '99' AND
        Trunc(B.D2) >= TO_DATE('01/01/2008','MM/DD/YYYY')
    UNION ALL
    SELECT
        '220' AS Site,
        A.Invoiceno AS Invoice_Id,
        TO_CHAR(A.Itemid) AS Item_Id,
        Trunc(A.Salesdate) AS Invoicedate,
        A.Quantity AS Invoiced_Qty,
        A.Unitprice AS Sales_Unit_Price,
        A.Discount,
        0 AS Net_Curr_Amount,
        0 AS Gross_Curr_Amount,
        A.Partdescription AS Catalog_Desc,
        A.Customername AS Customer_Name,
        A.Ordernumber AS Order_No,
        A.Customerid AS Customer_No,
        ' ' AS Cust_Grp,
        A.Salespartno AS Catalog_No,
        ' ' AS Authorize_Code,
        B.Salesman_Code,
        ' ' AS Commission_Receiver,
        ' ' AS District_Code,
        DECODE(A.Salesrepid,'220-510','BENELUX','220-520','BENELUX','GER') AS Region_Code,
        A.Salesdate AS Createdate,
        Upper(A.Productcode) AS Part_Product_Code,
        Upper(A.Productline) AS Part_Product_Family,
        ' ' AS Second_Commodity,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(A.Salesdate,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(A.Salesdate,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(A.Salesdate,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(A.Salesdate,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(A.Salesdate,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(A.Salesdate,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(A.Salesdate,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(A.Salesdate,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(A.Salesdate,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(A.Salesdate,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(A.Salesdate,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
            END
        AS Invoiceqtryr,
        TO_CHAR(A.Salesdate,'MM/YYYY') AS Invoicemthyr,
        ' ' AS Group_Id,
        'Sub-Part' AS Type_Designation,
        ' ' AS Customer_No_Pay,
        DECODE(A.Salesrepid,'220-510','BENELUX','220-520','BENELUX','GER') AS Corporate_Form,
        A.Amount * 1.4 AS Fixedamounts,
        A.Amount * I.Currency_Rate AS Allamounts,
        A.Amount AS Localamount,
        A.Amount AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        DECODE(A.Salespartno,C.Part_No,C.Inventory_Value,D.Part_No,D.Inventory_Value * 1.4) AS Cost,
        'Parts' AS Charge_Type,
        'GER' AS Source,
        'Market' AS Market_Code,
        ' ' AS Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        ' ' AS Delivery_Identity,
        ' ' AS Identity,
        ' ' AS Delivery_Address_Id,
        ' ' AS Invoice_Address_Id,
        'EUR' AS Currency,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Srordersger A
        LEFT JOIN Cust_Ord_Customer_Tab B ON A.Customerid = B.Customer_No
        LEFT JOIN Kd_Currency_Rate_4 I ON TO_CHAR(A.Salesdate,'MM/YYYY') = I.Valid_From
        LEFT JOIN Inventory_Part_Unit_Cost_Sum C ON A.Salespartno = C.Part_No AND
                                                    C.Contract = '100'
        LEFT JOIN Inventory_Part_Unit_Cost_Sum D ON A.Salespartno = D.Part_No AND
                                                    D.Contract = '210'
    WHERE
        A.Salesrepid IN (
            '220-100',
            '220-110',
            '220-120',
            '220-140',
            '220-145',
            '220-150',
            '220-160',
            '220-170',
            '220-180',
            '220-190',
            '220-200',
            '220-210',
            '220-220',
            '220-230',
            '220-540',
            '220-550',
            '220-510',
            '220-520',
            '220-600',
            '220-610',
            '220-650',
            '220-950',
            '220-998'
        ) AND
        A.Customerid NOT IN (
            'DE43125',
            'DE160010',
            'DE47206',
            'DE35092',
            'DE35084',
            'DE29029',
            'DE55046'
        ) AND
        A.Salesdate >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        I.Currency_Code = 'EUR'
    UNION ALL
    SELECT
        '240' AS Site,
        A.Invoiceno AS Invoice_Id,
        TO_CHAR(A.Itemid) AS Item_Id,
        Trunc(A.Salesdate) AS Invoicedate,
        A.Quantity AS Invoiced_Qty,
        0 AS Sales_Unit_Price,
        A.Discount,
        0 AS Net_Curr_Amount,
        0 AS Gross_Curr_Amount,
        A.Partdescription AS Catalog_Desc,
        A.Customername AS Customer_Name,
        A.Ordernumber AS Order_No,
        A.Customerid AS Customer_No,
        ' ' AS Cust_Grp,
        A.Salespartno AS Catalog_No,
        ' ' AS Authorize_Code,
        B.Salesman_Code,
        ' ' AS Commission_Receiver,
        ' ' AS District_Code,
        'FRA' AS Region_Code,
        A.Salesdate AS Createdate,
        Upper(A.Productcode) AS Part_Product_Code,
        Upper(A.Productline) AS Part_Product_Family,
        ' ' AS Second_Commodity,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(A.Salesdate,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(A.Salesdate,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(A.Salesdate,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(A.Salesdate,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(A.Salesdate,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(A.Salesdate,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(A.Salesdate,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(A.Salesdate,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(A.Salesdate,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(A.Salesdate,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(A.Salesdate,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
            END
        AS Invoiceqtryr,
        TO_CHAR(A.Salesdate,'MM/YYYY') AS Invoicemthyr,
        ' ' AS Group_Id,
        'Sub-Part' AS Type_Designation,
        ' ' AS Customer_No_Pay,
        'FRA' AS Corporate_Form,
        A.Amount * 1.4 AS Fixedamounts,
        A.Amount * I.Currency_Rate AS Allamounts,
        A.Amount AS Localamount,
        A.Amount AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        DECODE(A.Salespartno,C.Part_No,C.Inventory_Value,D.Part_No,D.Inventory_Value * 1.4) AS Cost,
        'Parts' AS Charge_Type,
        'FRA' AS Source,
        'Market' AS Market_Code,
        ' ' AS Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        ' ' AS Delivery_Identity,
        ' ' AS Identity,
        ' ' AS Delivery_Address_Id,
        ' ' AS Invoice_Address_Id,
        'EUR' AS Currency,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Srordersfra A
        LEFT JOIN Cust_Ord_Customer_Tab B ON A.Customerid = B.Customer_No
        LEFT JOIN Kd_Currency_Rate_4 I ON TO_CHAR(A.Salesdate,'MM/YYYY') = I.Valid_From
        LEFT JOIN Inventory_Part_Unit_Cost_Sum C ON A.Salespartno = C.Part_No AND
                                                    C.Contract = '100'
        LEFT JOIN Inventory_Part_Unit_Cost_Sum D ON A.Salespartno = D.Part_No AND
                                                    D.Contract = '210'
    WHERE
        A.Customerid != 'FR0672' AND
        A.Salesdate >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        I.Currency_Code = 'EUR'
    UNION ALL
    SELECT
        '210' AS Site,
        A.Invoiceno AS Invoice_Id,
        TO_CHAR(A.Itemid) AS Item_Id,
        Trunc(A.Salesdate) AS Invoicedate,
        A.Quantity AS Invoiced_Qty,
        0 AS Sales_Unit_Price,
        A.Discount,
        0 AS Net_Curr_Amount,
        0 AS Gross_Curr_Amount,
        A.Partdescription AS Catalog_Desc,
        A.Customername AS Customer_Name,
        A.Ordernumber AS Order_No,
        A.Customerid AS Customer_No,
        ' ' AS Cust_Grp,
        A.Salespartno AS Catalog_No,
        ' ' AS Authorize_Code,
        B.Salesman_Code,
        ' ' AS Commission_Receiver,
        ' ' AS District_Code,
        'ITL' AS Region_Code,
        A.Salesdate AS Createdate,
        Upper(A.Productcode) AS Part_Product_Code,
        DECODE(A.Productline,'Calfor','CALFO','Calmat','CALMA','Dynablast','DYNAB','Dynagraft','DYNAG','DynaMatrix','DYNAM','Renova','RENOV'
,'Restore','RESTO','Stage1','STAGE','Tefgen','TEFGE','Connexus','CONNX','Genesis','GNSIS',Upper(A.Productline) ) AS Part_Product_Family
,
        ' ' AS Second_Commodity,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(A.Salesdate,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(A.Salesdate,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(A.Salesdate,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(A.Salesdate,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(A.Salesdate,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(A.Salesdate,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(A.Salesdate,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(A.Salesdate,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(A.Salesdate,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(A.Salesdate,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(A.Salesdate,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
            END
        AS Invoiceqtryr,
        TO_CHAR(A.Salesdate,'MM/YYYY') AS Invoicemthyr,
        ' ' AS Group_Id,
        'Sub-Part' AS Type_Designation,
        ' ' AS Customer_No_Pay,
        'ITL' AS Corporate_Form,
        A.Amount * 1.4 AS Fixedamounts,
        A.Amount * I.Currency_Rate AS Allamounts,
        A.Amount AS Localamount,
        A.Amount AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        DECODE(A.Salespartno,C.Part_No,C.Inventory_Value,D.Part_No,D.Inventory_Value * 1.4) AS Cost,
        'Parts' AS Charge_Type,
        'ITL' AS Source,
        'Market' AS Market_Code,
        ' ' AS Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        ' ' AS Delivery_Identity,
        ' ' AS Identity,
        ' ' AS Delivery_Address_Id,
        ' ' AS Invoice_Address_Id,
        'EUR' AS Currency,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Srordersitl A
        LEFT JOIN Cust_Ord_Customer_Tab B ON A.Customerid = B.Customer_No
        LEFT JOIN Kd_Currency_Rate_4 I ON TO_CHAR(A.Salesdate,'MM/YYYY') = I.Valid_From
        LEFT JOIN Inventory_Part_Unit_Cost_Sum C ON A.Salespartno = C.Part_No AND
                                                    C.Contract = '100'
        LEFT JOIN Inventory_Part_Unit_Cost_Sum D ON A.Salespartno = D.Part_No AND
                                                    D.Contract = '210'
    WHERE
        A.Customerid NOT IN (
            'IT002945',
            'IT000387',
            'IT000807',
            'IT001014',
            'IT000916',
            'IT000921',
            'IT000465',
            'IT003382',
            'IT003484',
            'IT003575',
            'IT003656',
            'IT003666',
            'IT003693',
            'IT003940',
            'IT002654',
            'IT002541',
            'IT002014',
            ' '
        ) AND
        A.Salesdate >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        A.Salesrepid IN (
            '210-001',
            '210-002',
            '210-003',
            '210-004',
            '210-005',
            '210-006',
            '210-007',
            '210-008',
            '210-009',
            '210-011',
            '210-013',
            '210-014',
            '210-016',
            '210-017',
            '210-018',
            '210-022',
            '210-025',
            '210-027',
            '210-028',
            '210-030',
            '210-031',
            '210-032',
            '210-033',
            '210-034',
            '210-035',
            '210-036',
            '210-037',
            '210-098'
        ) AND
        I.Currency_Code = 'EUR'
    UNION ALL
    SELECT
        '230' AS Site,
        A.Invoiceno AS Invoice_Id,
        TO_CHAR(A.Itemid) AS Item_Id,
        Trunc(A.Salesdate) AS Invoicedate,
        A.Quantity AS Invoiced_Qty,
        0 AS Sales_Unit_Price,
        A.Discount,
        0 AS Net_Curr_Amount,
        0 AS Gross_Curr_Amount,
        A.Partdescription AS Catalog_Desc,
        A.Customername AS Customer_Name,
        A.Ordernumber AS Order_No,
        A.Customerid AS Customer_No,
        ' ' AS Cust_Grp,
        A.Salespartno AS Catalog_No,
        ' ' AS Authorize_Code,
        B.Salesman_Code,
        ' ' AS Commission_Receiver,
        ' ' AS District_Code,
        'SWE' AS Region_Code,
        A.Salesdate AS Createdate,
        Upper(A.Productcode) AS Part_Product_Code,
        Upper(A.Productline) AS Part_Product_Family,
        ' ' AS Second_Commodity,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(A.Salesdate,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(A.Salesdate,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(A.Salesdate,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(A.Salesdate,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(A.Salesdate,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(A.Salesdate,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(A.Salesdate,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(A.Salesdate,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(A.Salesdate,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(A.Salesdate,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(A.Salesdate,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
            END
        AS Invoiceqtryr,
        TO_CHAR(A.Salesdate,'MM/YYYY') AS Invoicemthyr,
        ' ' AS Group_Id,
        'Sub-Part' AS Type_Designation,
        ' ' AS Customer_No_Pay,
        'SWE' AS Corporate_Form,
        A.Amount *.13 AS Fixedamounts,
        A.Amount * I.Currency_Rate AS Allamounts,
        A.Amount * J.Currency_Rate AS Localamount,
        A.Amount AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        DECODE(A.Salespartno,C.Part_No,C.Inventory_Value,D.Part_No,D.Inventory_Value * 1.4) AS Cost,
        'Parts' AS Charge_Type,
        'ITL' AS Source,
        'Market' AS Market_Code,
        ' ' AS Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        ' ' AS Delivery_Identity,
        ' ' AS Identity,
        ' ' AS Delivery_Address_Id,
        ' ' AS Invoice_Address_Id,
        'SEK' AS Currency,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Srordersswe A
        LEFT JOIN Cust_Ord_Customer_Tab B ON A.Customerid = B.Customer_No
        LEFT JOIN Kd_Currency_Rate_4 I ON TO_CHAR(A.Salesdate,'MM/YYYY') = I.Valid_From
        LEFT JOIN Kd_Currency_Rate_4 J ON TO_CHAR(A.Salesdate,'MM/YYYY') = J.Valid_From
        LEFT JOIN Inventory_Part_Unit_Cost_Sum C ON A.Salespartno = C.Part_No AND
                                                    C.Contract = '100'
        LEFT JOIN Inventory_Part_Unit_Cost_Sum D ON A.Salespartno = D.Part_No AND
                                                    D.Contract = '210'
    WHERE
        A.Customerid NOT IN (
            'SE1477',
            'SE1421',
            'SE1424',
            'SE1420',
            'SE1419'
        ) AND
        A.Salesdate >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        I.Currency_Code = 'SEK' AND
        J.Currency_Code = 'EUR'
    UNION ALL
    SELECT
        '220' AS Site,
        A.Invoiceno AS Invoice_Id,
        TO_CHAR(A.Itemid) AS Item_Id,
        Trunc(A.Salesdate) AS Invoicedate,
        A.Quantity AS Invoiced_Qty,
        0 AS Sales_Unit_Price,
        A.Discount,
        0 AS Net_Curr_Amount,
        0 AS Gross_Curr_Amount,
        A.Partdescription AS Catalog_Desc,
        A.Customername AS Customer_Name,
        A.Ordernumber AS Order_No,
        A.Customerid AS Customer_No,
        'DIST' AS Cust_Grp,
        A.Salespartno AS Catalog_No,
        ' ' AS Authorize_Code,
        B.Salesman_Code,
        ' ' AS Commission_Receiver,
        ' ' AS District_Code,
        'EURO' AS Region_Code,
        A.Salesdate AS Createdate,
        Upper(A.Productcode) AS Part_Product_Code,
        DECODE(A.Productline,'Calfor','CALFO','Calmat','CALMA','Dynablast','DYNAB','Dynagraft','DYNAG','DynaMatrix','DYNAM','Renova','RENOV'
,'Restore','RESTO','Stage1','STAGE','Tefgen','TEFGE','Connexus','CONNX',Upper(A.Productline) ) AS Part_Product_Family,
        ' ' AS Second_Commodity,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(A.Salesdate,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(A.Salesdate,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(A.Salesdate,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(A.Salesdate,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(A.Salesdate,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(A.Salesdate,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(A.Salesdate,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(A.Salesdate,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(A.Salesdate,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(A.Salesdate,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(A.Salesdate,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
            END
        AS Invoiceqtryr,
        TO_CHAR(A.Salesdate,'MM/YYYY') AS Invoicemthyr,
        ' ' AS Group_Id,
        'Sub-Part' AS Type_Designation,
        ' ' AS Customer_No_Pay,
        'EUR' AS Corporate_Form,
        A.Amount * 1.4 AS Fixedamounts,
        A.Amount * I.Currency_Rate AS Allamounts,
        A.Amount AS Localamount,
        A.Amount AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        DECODE(A.Salespartno,C.Part_No,C.Inventory_Value,D.Part_No,D.Inventory_Value * 1.4) AS Cost,
        'Parts' AS Charge_Type,
        'GER' AS Source,
        'Market' AS Market_Code,
        ' ' AS Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        ' ' AS Delivery_Identity,
        ' ' AS Identity,
        ' ' AS Delivery_Address_Id,
        ' ' AS Invoice_Address_Id,
        'EUR' AS Currency,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Srordersger A
        LEFT JOIN Cust_Ord_Customer_Tab B ON A.Customerid = B.Customer_No
        LEFT JOIN Kd_Currency_Rate_4 I ON TO_CHAR(A.Salesdate,'MM/YYYY') = I.Valid_From
        LEFT JOIN Inventory_Part_Unit_Cost_Sum C ON A.Salespartno = C.Part_No AND
                                                    C.Contract = '100'
        LEFT JOIN Inventory_Part_Unit_Cost_Sum D ON A.Salespartno = D.Part_No AND
                                                    D.Contract = '210'
    WHERE
        A.Customerid IN (
            'DE55046',
            'DE43125',
            'DE29029',
            'DE47206'
        ) AND
        A.Salesdate >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        I.Currency_Code = 'EUR'
    UNION ALL
    SELECT
        '210' AS Site,
        A.Invoiceno AS Invoice_Id,
        TO_CHAR(A.Itemid) AS Item_Id,
        Trunc(A.Salesdate) AS Invoicedate,
        A.Quantity AS Invoiced_Qty,
        0 AS Sales_Unit_Price,
        A.Discount,
        0 AS Net_Curr_Amount,
        0 AS Gross_Curr_Amount,
        A.Partdescription AS Catalog_Desc,
        A.Customername AS Customer_Name,
        A.Ordernumber AS Order_No,
        A.Customerid AS Customer_No,
        'DIST' AS Cust_Grp,
        A.Salespartno AS Catalog_No,
        ' ' AS Authorize_Code,
        B.Salesman_Code,
        ' ' AS Commission_Receiver,
        ' ' AS District_Code,
        'EURO' AS Region_Code,
        A.Salesdate AS Createdate,
        Upper(A.Productcode) AS Part_Product_Code,
        DECODE(A.Productline,'Calfor','CALFO','Calmat','CALMA','Dynablast','DYNAB','Dynagraft','DYNAG','DynaMatrix','DYNAM','Renova','RENOV'
,'Restore','RESTO','Stage1','STAGE','Tefgen','TEFGE','Connexus','CONNX',Upper(A.Productline) ) AS Part_Product_Family,
        ' ' AS Second_Commodity,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(A.Salesdate,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(A.Salesdate,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(A.Salesdate,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(A.Salesdate,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(A.Salesdate,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(A.Salesdate,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(A.Salesdate,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(A.Salesdate,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(A.Salesdate,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(A.Salesdate,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(A.Salesdate,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
            END
        AS Invoiceqtryr,
        TO_CHAR(A.Salesdate,'MM/YYYY') AS Invoicemthyr,
        ' ' AS Group_Id,
        'Sub-Part' AS Type_Designation,
        ' ' AS Customer_No_Pay,
        'EUR' AS Corporate_Form,
        A.Amount * 1.4 AS Fixedamounts,
        A.Amount * I.Currency_Rate AS Allamounts,
        A.Amount AS Localamount,
        A.Amount AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        DECODE(A.Salespartno,C.Part_No,C.Inventory_Value,D.Part_No,D.Inventory_Value * 1.4) AS Cost,
        'Parts' AS Charge_Type,
        'ITL' AS Source,
        'Market' AS Market_Code,
        ' ' AS Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        ' ' AS Delivery_Identity,
        ' ' AS Identity,
        ' ' AS Delivery_Address_Id,
        ' ' AS Invoice_Address_Id,
        'EUR' AS Currency,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Srordersitl A
        LEFT JOIN Cust_Ord_Customer_Tab B ON A.Customerid = B.Customer_No
        LEFT JOIN Kd_Currency_Rate_4 I ON TO_CHAR(A.Salesdate,'MM/YYYY') = I.Valid_From
        LEFT JOIN Inventory_Part_Unit_Cost_Sum C ON A.Salespartno = C.Part_No AND
                                                    C.Contract = '100'
        LEFT JOIN Inventory_Part_Unit_Cost_Sum D ON A.Salespartno = D.Part_No AND
                                                    D.Contract = '210'
    WHERE
        A.Customerid IN (
            'IT002945',
            'IT000387',
            'IT000807',
            'IT001014',
            'IT000916',
            'IT000921',
            'IT000465',
            'IT003382',
            'IT003484',
            'IT003575',
            'IT003656',
            'IT003666',
            'IT003693',
            'IT003940'
        ) AND
        A.Salesdate >= TO_DATE('01/01/2010','MM/DD/YYYY') AND
        I.Currency_Code = 'EUR'
    UNION ALL
    SELECT
        '100' AS Site,
        A.Invoice_No AS Invoice_Id,
        '1' AS Item_Id,
        Trunc(A.Invoice_Date) AS Invoicedate,
        0 AS Invoiced_Qty,
        0 AS Sale_Unit_Price,
        0 AS Discount,
        A.Net_Curr_Amount AS Net_Curr_Amount,
        A.Net_Curr_Amount + A.Vat_Curr_Amount AS Gross_Curr_Amount,
        'Other' AS Catalog_Desc,
        B.Name AS Customer_Name,
        A.Creators_Reference AS Order_No,
        A.Identity AS Customer_No,
        C.Cust_Grp AS Cust_Grp,
        'Other' AS Catalog_No,
        'Other' AS Authorize_Code,
        C.Salesman_Code AS Salesman_Code,
        E.Commission_Receiver AS Commission_Receiver,
        D.District_Code AS District_Code,
        D.Region_Code AS Region_Code,
        Trunc(A.Invoice_Date) AS Createdate,
        'OTHER' AS Part_Product_Code,
        'OTHER' AS Part_Product_Family,
        'OTHER' AS Second_Commodity,
        CASE
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM A.Invoice_Date)
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM A.Invoice_Date)
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM A.Invoice_Date)
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM A.Invoice_Date)
            END
        AS Invoiceqtryr,
        TO_CHAR(A.Invoice_Date,'MM/YYYY') AS Invoicemthyr,
        F.Group_Id AS Group_Id,
        DECODE(A.Invoice_No,'99086930','Non-Target','Target') AS Type_Designation,
        C.Customer_No_Pay,
        B.Corporate_Form,
        DECODE(A.Currency,'SEK', (A.Net_Curr_Amount *.13),'EUR', (A.Net_Curr_Amount * 1.4),A.Net_Curr_Amount) AS Fixed_Amounts,
        CASE
                WHEN A.Currency = 'CAD' AND
                     Trunc(A.Invoice_Date) >= TO_DATE('03/01/2013','MM/DD/YYYY') THEN A.Net_Curr_Amount
                WHEN A.Currency != 'USD' THEN A.Net_Curr_Amount * I.Currency_Rate
                ELSE A.Net_Curr_Amount
            END
        AS Allamounts,
        CASE
                WHEN A.Currency IN (
                    'SEK',
                    'DKK'
                ) THEN A.Net_Curr_Amount / J.Currency_Rate
                ELSE A.Net_Curr_Amount
            END
        AS Localamount,
        A.Net_Curr_Amount AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        0 AS Cost,
        'Parts' AS Charge_Type,
        'IFS' AS Source,
        'Market' AS Market_Code,
        B.Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        A.Identity AS Delivery_Identity,
        A.Identity AS Identity,
        '99' AS Delivery_Address_Id,
        '99' AS Invoice_Address_Id,
        A.Currency AS Currency,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Invoice_Tab A
        LEFT JOIN Kd_Currency_Rate_4 I ON A.Currency = I.Currency_Code AND
                                          TO_CHAR(A.Invoice_Date,'MM/YYYY') = I.Valid_From
        LEFT JOIN Kd_Currency_Rate_1 J ON A.Currency = J.Currency_Code AND
                                          TO_CHAR(A.Invoice_Date,'MM/YYYY') = J.Valid_From,
        Customer_Info_Tab B,
        Cust_Ord_Customer_Tab C,Cust_Ord_Customer_Address_Tab D
        LEFT JOIN Cust_Def_Com_Receiver_Tab E ON D.Customer_No = E.Customer_No,
        Identity_Invoice_Info_Tab F
    WHERE
        A.Identity = B.Customer_Id AND
        A.Identity = C.Customer_No AND
        B.Customer_Id = C.Customer_No AND
        A.Identity = D.Customer_No AND
        B.Customer_Id = D.Customer_No AND
        C.Customer_No = D.Customer_No AND
        F.Identity = A.Identity AND
        F.Company = '100' AND
        Trunc(A.Invoice_Date) >= TO_DATE('01/01/2010','MM/DD/YYYY') AND
        D.Addr_No = '99' AND
        A.Series_Id IN (
            'CI',
            'II'
        ) AND
        Invoice_Api.Finite_State_Decode__(A.Rowstate) != 'Cancelled' AND
        A.Invoice_No IN (
            'CD99004117-R',
            'CR015275',
            'CR537182',
            'CR538349',
            'CR540408',
            'CR541376',
            'CR541587',
            'CR542690',
            'CR543188',
            'CR543189',
            'CR543190',
            'CR543191',
            'CR543192',
            'CR999901352',
            '9900034',
            '9900035',
            'CD99004403',
            'CD99010910',
            'CD99022855',
            'CD99040559',
            '9900022',
            '9900024',
            '9900037',
            '9900038',
            '9900039',
            '99030194',
            '99031158',
            '99043480',
            '999902606',
            '99031806',
            '99033594',
            'CR531714',
            'CR537323',
            'CR541793',
            'CR541889',
            'CR542334',
            'CR9900021',
            'CR9900023',
            'CR9900030',
            'CR99031806',
            'CR99033594',
            '99051483',
            '99051563',
            '99052156',
            '99052601',
            '99053060',
            '999905308',
            'CR1885',
            'CR316948',
            'CR3691',
            'CR531714B',
            'CR540861',
            '999906495',
            '99055039',
            '9900005',
            '9900044',
            '99062938',
            '1775DISCADJ',
            '99030980CR',
            '99051493CR',
            '99064380CR',
            '99064336',
            'RMA6269',
            '2479_0809CR',
            '99069660A',
            '99070809PD',
            '99075281',
            '20646CR',
            'DYNATRIX',
            '9900048',
            '9900049',
            '9900050',
            '99064576',
            '99990771',
            '990543459',
            '999910219',
            '5418000CR',
            '9900052',
            '2479_1109CR',
            '99085958A',
            '9900054',
            '99077823',
            '99077930',
            '99090097',
            '999909696',
            '2479_1209CR',
            '99091427A',
            '99093418A',
            '9900057',
            '9900058',
            '9900059',
            '99096834A',
            '99076516',
            '99098866',
            '99099245',
            '99093370A',
            '999908479A',
            '99100341A',
            '99101896',
            '99061875',
            '99086484',
            '99100924',
            '99104656',
            '99104708',
            '99105067',
            '99106176',
            '99106235',
            '99106731',
            '99107429',
            '999901456',
            '999901697',
            '999911641',
            '99105630A',
            '99086930',
            '99016153',
            'CD99101896',
            'CD99100138',
            '99103094',
            '99100544',
            '9900025',
            '9900027',
            '9900028',
            '9900029',
            '9900030',
            '9900031',
            '9900032',
            '9900033',
            '9900036',
            'CR99033594',
            'CR999904187',
            'CD99031806',
            '99044415A',
            '99044415R',
            '99047478A',
            '999906450',
            '9900043',
            '99052747',
            '99052967',
            '999905426',
            '999906428DR',
            '999906626A',
            '999909760',
            '99080758',
            '99070809PD',
            '9900042',
            '541784B',
            '9900064',
            '9900065',
            '9900067',
            '99105850',
            '999912837A',
            '2951A',
            '9900068',
            '9900069',
            '999913881'
        )
    UNION ALL
    SELECT
        DECODE(C.Association_No,'DE','220','SE','230','FR','240','IT','210','EU','100','100') AS Site,
        A.Series_Id || A.Invoice_No AS Invoice_Id,
        TO_CHAR(B.Item_Id) AS Item_Id,
        Trunc(A.D2) AS Invoicedate,
        CASE
                WHEN A.Series_Id = 'CR' AND
                     B.N2 IS NULL THEN 0
                WHEN A.Series_Id = 'CR' AND
                     B.N2 IS NOT NULL THEN B.N2 *-1
                ELSE B.N2
            END
        AS Invoiced_Qty,
        B.N4 AS Sale_Unit_Price,
        B.N5 AS Discount,
        A.Net_Curr_Amount,
        B.Net_Curr_Amount + B.Vat_Curr_Amount AS Gross_Curr_Amount,
        B.C6 AS Catalog_Desc,
        C.Name AS Customer_Name,
        B.C1 AS Order_No,
        A.Delivery_Identity AS Customer_No,
        D.Cust_Grp,
        B.C5 AS Catalog_No,
        ' ' AS Authorize_Code,
        D.Salesman_Code,
        ' ' AS Commission_Receiver,
        E.District_Code,
        E.Region_Code,
        Trunc(A.Invoice_Date) AS Createdate,
        ' ' AS Part_Product_Code,
        ' ' AS Part_Product_Family,
        ' ' AS Second_Commodity,
        CASE
                WHEN TO_CHAR(A.D2,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(A.D2,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(A.D2,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(A.D2,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(A.D2,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(A.D2,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(A.D2,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(A.D2,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(A.D2,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(A.D2,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(A.D2,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(A.D2,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(A.D2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(A.D2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(A.D2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(A.D2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(A.D2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM A.D2)
                WHEN TO_CHAR(A.D2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM A.D2)
                WHEN TO_CHAR(A.D2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM A.D2)
                WHEN TO_CHAR(A.D2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM A.D2)
            END
        AS Invoiceqtryr,
        TO_CHAR(A.D2,'MM/YYYY') AS Invoicemthyr,
        F.Group_Id,
        'Freight' AS Type_Designation,
        B.Identity AS Customer_No_Pay,
        'Freight' AS Corporate_Form,
        DECODE(A.Currency,'SEK', (B.Net_Curr_Amount * 0.13),'EUR', (B.Net_Curr_Amount * 0.13),B.Net_Curr_Amount) AS Fixedamounts,
        CASE
                WHEN A.Currency = 'CAD' AND
                     Trunc(A.D2) >= TO_DATE('03/01/2013','MM/DD/YYYY') THEN B.Net_Curr_Amount
                WHEN A.Currency != 'USD' THEN B.Net_Curr_Amount * I.Currency_Rate
                ELSE B.Net_Curr_Amount
            END
        AS Allamounts,
        CASE
                WHEN A.Currency IN (
                    'SEK',
                    'DKK'
                ) THEN B.Net_Curr_Amount / J.Currency_Rate
                ELSE B.Net_Curr_Amount
            END
        AS Localamount,
        B.Net_Curr_Amount AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        0 AS Cost,
        'Freight' AS Charge_Type,
        'IFS' AS Source,
        'Market' AS Market_Code,
        C.Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        A.Delivery_Identity,
        A.Identity,
        A.Delivery_Address_Id,
        A.Invoice_Address_Id,
        A.Currency,
        A.N2 AS Rma_No,
        N.Address1 AS Invoiceadd1,
        N.Address2 AS Invoiceadd2,
        N.City AS Invoicecity,
        N.State AS Invoicestate,
        N.Zip_Code AS Invoicezip,
        Iso_Country_Api.DECODE(N.Country) AS Invoicecountry,
        N.County AS Invoicecounty,
        O.Address1 AS Delivadd1,
        O.Address2 AS Delivadd2,
        O.City AS Delivcity,
        O.State AS Delivstate,
        O.Zip_Code AS Delivzip,
        Iso_Country_Api.DECODE(O.Country) AS Delivcountry,
        O.County AS Delivcounty
    FROM
        Invoice_Tab A
        LEFT JOIN Kd_Currency_Rate_4 I ON A.Currency = I.Currency_Code AND
                                          TO_CHAR(A.D2,'MM/YYYY') = I.Valid_From
        LEFT JOIN Kd_Currency_Rate_1 J ON A.Currency = J.Currency_Code AND
                                          TO_CHAR(A.D2,'MM/YYYY') = J.Valid_From
        LEFT JOIN Customer_Info_Address_Tab N ON A.Identity = N.Customer_Id AND
                                                 A.Invoice_Address_Id = N.Address_Id
        LEFT JOIN Customer_Info_Address_Tab O ON A.Identity = O.Customer_Id AND
                                                 A.Delivery_Address_Id = O.Address_Id,Invoice_Item_Tab B
        LEFT JOIN Identity_Invoice_Info_Tab F ON B.Company = F.Company AND
                                                 B.Identity = F.Identity AND
                                                 B.Party_Type = F.Party_Type,
        Customer_Info_Tab C,
        Cust_Ord_Customer_Tab D,
        Cust_Ord_Customer_Address_Tab E
    WHERE
        A.Invoice_Id = B.Invoice_Id AND
        A.Delivery_Identity = C.Customer_Id AND
        A.Delivery_Identity = D.Customer_No AND
        C.Customer_Id = D.Customer_No AND
        A.Delivery_Identity = E.Customer_No AND
        C.Customer_Id = E.Customer_No AND
        D.Customer_No = E.Customer_No AND
        Trunc(A.Invoice_Date) >= TO_DATE('01/01/2008','MM/DD/YYYY') AND
        B.C5 != 'WAIVESHIPPING' AND
        E.Addr_No = '99' AND
        B.C11 IN (
            'FREIGHT',
            'RESTOCK',
            'DOMFLATRATE'
        ) AND
        C.Corporate_Form != 'KEY'
    UNION ALL
    SELECT
        '100' AS Site,
        '0' AS Invoice_Id,
        '1' AS Item_Id,
        TO_DATE('01/01/9999','MM/DD/YYYY') AS Invoicedate,
        0 AS Invoiced_Qty,
        0 AS Sale_Unit_Price,
        0 AS Discount,
        0 AS Net_Curr_Amount,
        0 AS Gross_Curr_Amount,
        'Other' AS Catalog_Desc,
        ' ' AS Customer_Name,
        ' ' AS Order_No,
        '0' AS Customer_No,
        '0' AS Cust_Grp,
        'Other' AS Catalog_No,
        'Other' AS Authorize_Code,
        ' ' AS Salesman_Code,
        ' ' AS Commission_Receiver,
        ' ' AS District_Code,
        ' ' AS Region_Code,
        TO_DATE('01/01/9999','MM/DD/YYYY') AS Createdate,
        'OTHER' AS Part_Product_Code,
        'OTHER' AS Part_Product_Family,
        'OTHER' AS Second_Commodity,
        ' ' AS Invoicemonth,
        ' ' AS Invoiceqtr,
        ' ' AS Invoiceqtryr,
        ' ' AS Invoicemthyr,
        ' ' AS Group_Id,
        ' ' AS Type_Designation,
        '0' AS Custome_No_Pay,
        'DOMDIRLE' AS Corporate_Form,
        0 AS Fixedamounts,
        0 AS Allamounts,
        0 AS Localamount,
        0 AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        0 AS Cost,
        'Parts' AS Charge_Type,
        'IFS' AS Source,
        'Market' AS Market_Code,
        ' ' AS Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        ' ' AS Delivery_Identity,
        ' ' AS Identity,
        ' ' AS Delivery_Address_Id,
        ' ' AS Invoice_Address_Id,
        ' ' AS Currency,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Dual
    UNION ALL
  --Dummy Record for Target Products
    SELECT
        '100' AS Site,
        '0' AS Invoice_Id,
        '1' AS Item_Id,
        TO_DATE('01/01/9999','MM/DD/YYYY') AS Invoicedate,
        0 AS Invoiced_Qty,
        0 AS Sale_Unit_Price,
        0 AS Discount,
        0 AS Net_Curr_Amount,
        0 AS Gross_Curr_Amount,
        'Other' AS Catalog_Desc,
        ' ' AS Customer_Name,
        ' ' AS Order_No,
        '0' AS Customer_No,
        '0' AS Cust_Grp,
        'Other' AS Catalog_No,
        'Other' AS Authorize_Code,
        ' ' AS Salesman_Code,
        ' ' AS Commission_Receiver,
        ' ' AS District_Code,
        ' ' AS Region_Code,
        TO_DATE('01/01/9999','MM/DD/YYYY') AS Createdate,
        'OTHER' AS Part_Product_Code,
        'OTHER' AS Part_Product_Family,
        'OTHER' AS Second_Commodity,
        ' ' AS Invoicemonth,
        ' ' AS Invoiceqtr,
        ' ' AS Invoiceqtryr,
        ' ' AS Invoicemthyr,
        ' ' AS Group_Id,
        ' ' AS Type_Designation,
        '0' AS Customer_No_Pay,
        'DOMDIRPR' AS Corporate_Form,
        0 AS Fixedamounts,
        0 AS Allamounts,
        0 AS Localamount,
        0 AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        0 AS Cost,
        'Parts' AS Charge_Type,
        'IFS' AS Source,
        'Market' AS Market_Code,
        ' ' AS Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        ' ' AS Delivery_Identity,
        ' ' AS Identity,
        ' ' AS Delivery_Address_Id,
        ' ' AS Invoice_Address_Id,
        ' ' AS Currency,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Dual
    UNION ALL
    SELECT
        DECODE(A.Company,'241','240',A.Company) AS Site,
        B.Series_Id || B.Invoice_No AS Invoice_Id,
        TO_CHAR(A.Item_Id) AS Item_Id,
        Trunc(B.D2) AS Invoice_Date,
        CASE
                WHEN B.Series_Id = 'CR' AND
                     A.N2 IS NULL THEN 0
                WHEN B.Series_Id = 'CR' AND
                     A.N2 IS NOT NULL THEN A.N2 *-1
                ELSE A.N2
            END
        AS Invoiced_Qty,
        A.N4 AS Sale_Unit_Price,
        A.N5 AS Discount,
        A.Net_Curr_Amount,
        A.Net_Curr_Amount + A.Vat_Curr_Amount AS Gross_Curr_Amount,
        C.Catalog_Desc,
        Customer_Info_Api.Get_Name(B.Identity) AS Customer_Name,
        A.C1 AS Order_No,
        A.C13 AS Customer_No,
        D.Cust_Grp,
        A.C5,
        Substr(B.C1,1,35) AS Authorize_Code,
        D.Salesman_Code,
        E.Commission_Receiver,
        F.District_Code,
        F.Region_Code,
        Trunc(B.Creation_Date) AS Createdate,
        DECODE(A.C5,G.Part_No,G.Part_Product_Code,'OTHER') AS Part_Product_Code,
        DECODE(A.C5,G.Part_No,G.Part_Product_Family,'OTHER') AS Part_Product_Family,
        DECODE(A.C5,G.Part_No,G.Second_Commodity,'OTHER') AS Second_Commodity,
        CASE
                WHEN TO_CHAR(B.D2,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(B.D2,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(B.D2,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(B.D2,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(B.D2,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(B.D2,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(B.D2,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(B.D2,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(B.D2,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(B.D2,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(B.D2,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(B.D2,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM B.D2)
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM B.D2)
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM B.D2)
                WHEN TO_CHAR(B.D2,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM B.D2)
            END
        AS Invoiceqtryr,
        TO_CHAR(B.D2,'MM/YYYY') AS Invoicemthyr,
        K.Group_Id AS Group_Id,
        DECODE(A.C5,G.Part_No,G.Type_Designation,'Non-Target') AS Type_Designation,
        A.Identity AS Customer_No_Pay,
        DECODE(A.C1,'C99916','DOMDIR','ASIA') AS Corporate_Form,
        A.Net_Curr_Amount AS Fixedamounts,
        A.Net_Curr_Amount AS Allamounts,
        A.Net_Curr_Amount AS Localamount,
        A.Net_Curr_Amount AS Truelocalamt,
        A.Vat_Dom_Amount,
        A.Vat_Code,
        CASE
                WHEN A.C5 = K.Part_No THEN K.Inventory_Value
                ELSE L.Inventory_Value * 1.4
            END
        AS Cost,
        'Parts' AS Charge_Type,
        'IFS' AS Source,
        M.Market_Code,
        H.Association_No,
        B.Vat_Curr_Amount,
        Payment_Term_Api.Get_Description(B.Company,B.Pay_Term_Id) AS Pay_Term_Description,
        Substr(B.C1,1,35) AS Kdreference,
        Substr(B.C2,1,30) AS Customerref,
        TO_CHAR(B.D3,'MM/DD/YYYY') AS Deliverydate,
        Substr(B.C3,1,35) AS Ship_Via,
        B.Delivery_Identity,
        B.Identity,
        B.Delivery_Address_Id,
        B.Invoice_Address_Id,
        B.Currency,
        B.N2 AS Rma_No,
        N.Address1 AS Invoiceadd1,
        N.Address2 AS Invoiceadd2,
        N.City AS Invoicecity,
        N.State AS Invoicestate,
        N.Zip_Code AS Invoicezip,
        Iso_Country_Api.DECODE(N.Country) AS Invoicecountry,
        N.County AS Invoicecounty,
        O.Address1 AS Delivadd1,
        O.Address2 AS Delivadd2,
        O.City AS Delivcity,
        O.State AS Delivstate,
        O.Zip_Code AS Delivzip,
        Iso_Country_Api.DECODE(O.Country) AS Delivcountry,
        O.County AS Delivcounty
    FROM
        Invoice_Item_Tab A
        LEFT JOIN Sales_Part_Tab C ON A.C5 = C.Catalog_No AND
                                      DECODE(A.Company,'241','240',A.Company) = C.Contract
        LEFT JOIN Cust_Def_Com_Receiver_Tab E ON A.C13 = E.Customer_No
        LEFT JOIN Inventory_Part_Tab G ON A.C5 = G.Part_No AND
                                          DECODE(A.Company,'241','240',A.Company) = G.Contract
        LEFT JOIN Kd_Cost_100 K ON A.C5 = K.Part_No
        LEFT JOIN Kd_Cost_210 L ON A.C5 = L.Part_No
        LEFT JOIN Customer_Order_Tab M ON A.C1 = M.Order_No
        LEFT JOIN Identity_Invoice_Info_Tab K ON A.Company = K.Company AND
                                                 A.Identity = K.Identity AND
                                                 A.Party_Type = K.Party_Type,Invoice_Tab B
        LEFT JOIN Customer_Info_Address_Tab N ON B.Identity = N.Customer_Id AND
                                                 B.Invoice_Address_Id = N.Address_Id
        LEFT JOIN Customer_Info_Address_Tab O ON B.Identity = O.Customer_Id AND
                                                 B.Delivery_Address_Id = O.Address_Id,
        Cust_Ord_Customer_Tab D,
        Cust_Ord_Customer_Address_Tab F,
        Customer_Info_Tab H
    WHERE
        A.Invoice_Id = B.Invoice_Id AND
        A.C11 IS NULL AND
        A.C13 = D.Customer_No AND
        B.Delivery_Identity = D.Customer_No AND
        A.C13 = F.Customer_No AND
        A.C13 = H.Customer_Id AND
        H.Customer_Id = D.Customer_No AND
        H.Customer_Id = F.Customer_No AND
        B.Delivery_Identity = H.Customer_Id AND
        B.Rowstate != 'Preliminary' AND
        F.Addr_No = '99' AND
        A.C1 IN (
            'C99894',
            'C99904',
            'C99913',
            'C99917',
            'C99919',
            'K1348',
            'K1351',
            'C99916'
        ) AND
        Trunc(B.D2) >= TO_DATE('01/01/2010','MM/DD/YYYY')
    UNION ALL
    SELECT
        '240' AS Site,
        A.Invoiceno AS Invoice_Id,
        TO_CHAR(A.Itemid) AS Item_Id,
        Trunc(A.Salesdate) AS Invoicedate,
        A.Quantity AS Invoiced_Qty,
        0 AS Sales_Unit_Price,
        A.Discount,
        0 AS Net_Curr_Amount,
        0 AS Gross_Curr_Amount,
        A.Partdescription AS Catalog_Desc,
        A.Customername AS Customer_Name,
        A.Ordernumber AS Order_No,
        A.Customerid AS Customer_No,
        ' ' AS Cust_Grp,
        A.Salespartno AS Catalog_No,
        ' ' AS Authorize_Code,
        'CAD' AS Salesman_Code,
        ' ' AS Commission_Receiver,
        ' ' AS District_Code,
        'FRA' AS Region_Code,
        A.Salesdate AS Createdate,
        'EGSW' AS Part_Product_Code,
        'EG' AS Part_Product_Family,
        ' ' AS Second_Commodity,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(A.Salesdate,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(A.Salesdate,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(A.Salesdate,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(A.Salesdate,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(A.Salesdate,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(A.Salesdate,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(A.Salesdate,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(A.Salesdate,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(A.Salesdate,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(A.Salesdate,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(A.Salesdate,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
                WHEN TO_CHAR(A.Salesdate,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM A.Salesdate)
            END
        AS Invoiceqtryr,
        TO_CHAR(A.Salesdate,'MM/YYYY') AS Invoicemthyr,
        ' ' AS Group_Id,
        'Sub-Part' AS Type_Designation,
        ' ' AS Customer_No_Pay,
        'FRA' AS Corporate_Form,
        A.Amount AS Fixedamounts,
        A.Amount AS Allamounts,
        A.Amount AS Localamount,
        A.Amount AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        0 AS Cost,
        'Parts' AS Charge_Type,
        'FRA' AS Source,
        'Market' AS Market_Code,
        ' ' AS Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        ' ' AS Delivery_Identity,
        ' ' AS Identity,
        ' ' AS Delivery_Address_Id,
        ' ' AS Invoice_Address_Id,
        'EUR' AS Currency,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Srcadsalesorder A
    WHERE
        A.Salesdate >= TO_DATE('01/01/2010','MM/DD/YYYY')
    UNION ALL
    SELECT DISTINCT
        DECODE(C.Association_No,'DE','220','SE','230','FR','240','IT','210','EU','100','100') AS Site,
        R.Invoice_No AS Invoice_Id,
        TO_CHAR(R.Row_No) AS Item_Id,
        Trunc(R.Invoice_Date) AS Invoicedate,
        R.Quantity AS Invoiced_Qty,
        R.Price AS Sale_Unit_Price,
        0 AS Discount,
        R.Net_Curr_Amount,
        0 Gross_Curr_Amount,
        R.Description AS Catalog_Desc,
        C.Name AS Customer_Name,
        R.Order_No,
        R.Customer_No,
        D.Cust_Grp,
        R.Object AS Catalog_No,
        ' ' AS Authorize_Code,
        D.Salesman_Code,
        F.Commission_Receiver AS Commission_Receiver,
        E.District_Code,
        E.Region_Code,
        Trunc(R.Order_Date) AS Create_Date,
        DECODE(R.Object,B.Part_No,Upper(B.Part_Product_Code),'OTHER') AS Part_Product_Code,
        DECODE(R.Object,B.Part_No,Upper(B.Part_Product_Family),'OTHER') AS Part_Product_Family,
        DECODE(R.Object,B.Part_No,Upper(B.Second_Commodity),'OTHER') AS Second_Commodity,
        CASE
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM R.Invoice_Date)
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM R.Invoice_Date)
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM R.Invoice_Date)
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM R.Invoice_Date)
            END
        AS Invoiceqtryr,
        TO_CHAR(R.Invoice_Date,'MM/YYYY') AS Invoicemthyr,
        K.Group_Id AS Group_Id,
        DECODE(B.Type_Designation,NULL,'Target',B.Type_Designation) AS Type_Designation,
        D.Customer_No_Pay,
        C.Corporate_Form,
        DECODE(R.Currency_Code,'SEK', (R.Net_Curr_Amount * 0.13),'EUR', (R.Net_Curr_Amount * 1.4),'DKK', (R.Net_Curr_Amount * 0.13),R.Net_Curr_Amount
) AS Fixedamounts,
        CASE
                WHEN R.Currency_Code = 'CAD' AND
                     Trunc(R.Invoice_Date) >= TO_DATE('03/01/2013','MM/DD/YYYY') THEN R.Net_Curr_Amount
                WHEN R.Currency_Code != 'USD' THEN R.Net_Curr_Amount * I.Currency_Rate
                ELSE R.Net_Curr_Amount
            END
        AS Allamounts,
        CASE
                WHEN R.Currency_Code IN (
                    'SEK',
                    'DKK'
                ) THEN R.Net_Curr_Amount / J.Currency_Rate
                ELSE R.Net_Curr_Amount
            END
        AS Localamount,
        R.Net_Curr_Amount AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        CASE
                WHEN R.Object = K.Part_No THEN K.Inventory_Value
                ELSE L.Inventory_Value * 1.4
            END
        AS Cost,
        'Parts' AS Charge_Type,
        'IFS' AS Source,
        'Market' AS Market_Code,
        ' ' AS Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        R.Customer_No AS Delivery_Identity,
        R.Customer_No AS Identity,
        '99' AS Delivery_Address_Id,
        '99' AS Invoice_Address_Id,
        R.Currency_Code,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceoadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Instant_Invoice_Rep R
        LEFT JOIN Inventory_Part_Tab B ON R.Object = B.Part_No AND
                                          B.Contract = '100'
        LEFT JOIN Kd_Currency_Rate_4 I ON TO_CHAR(R.Invoice_Date,'MM/YYYY') = I.Valid_From AND
                                          R.Currency_Code = I.Currency_Code
        LEFT JOIN Kd_Currency_Rate_1 J ON TO_CHAR(R.Invoice_Date,'MM/YYYY') = J.Valid_From AND
                                          R.Currency_Code = J.Currency_Code
        LEFT JOIN Identity_Invoice_Info_Tab K ON R.Customer_No = K.Identity AND
                                                 R.Company = '100'
        LEFT JOIN Inventory_Part_Unit_Cost_Sum K ON R.Object = K.Part_No AND
                                                    K.Contract = '100'
        LEFT JOIN Inventory_Part_Unit_Cost_Sum L ON R.Object = K.Part_No AND
                                                    K.Contract = '210',
        Customer_Info_Tab C,
        Cust_Ord_Customer_Tab D,Cust_Ord_Customer_Address_Tab E
        LEFT JOIN Cust_Def_Com_Receiver_Tab F ON E.Customer_No = F.Customer_No
    WHERE
        R.Customer_No = C.Customer_Id AND
        R.Customer_No = D.Customer_No AND
        C.Customer_Id = D.Customer_No AND
        R.Customer_No = E.Customer_No AND
        C.Customer_Id = E.Customer_No AND
        D.Customer_No = E.Customer_No AND
        R.Invoice_Date >= TO_DATE('08/03/2010','MM/DD/YYYY') AND
        E.Addr_No = '99' AND
        R.Row_Type = '1' AND
        R.Object != 'FREIGHT' AND
        R.Invoice_No NOT LIKE 'EI%' AND
        C.Corporate_Form != 'KEY'
    UNION ALL
    SELECT DISTINCT
        DECODE(C.Association_No,'DE','220','SE','230','FR','240','IT','210','EU','100','100') AS Site,
        R.Invoice_No AS Invoice_Id,
        TO_CHAR(R.Row_No) AS Item_Id,
        Trunc(R.Invoice_Date) AS Invoicedate,
        R.Quantity AS Invoiced_Qty,
        R.Price AS Sale_Unit_Price,
        0 AS Discount,
        R.Net_Curr_Amount,
        0 Gross_Curr_Amount,
        R.Description AS Catalog_Desc,
        C.Name AS Customer_Name,
        R.Order_No,
        R.Customer_No,
        D.Cust_Grp,
        R.Object AS Catalog_No,
        ' ' AS Authorize_Code,
        D.Salesman_Code,
        ' ' AS Commission_Receiver,
        E.District_Code,
        E.Region_Code,
        Trunc(R.Order_Date) AS Create_Date,
        'Freight' AS Part_Product_Code,
        'Freight' AS Part_Product_Family,
        'Freight' AS Second_Commodity,
        CASE
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(R.Invoice_Date,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM R.Invoice_Date)
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM R.Invoice_Date)
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM R.Invoice_Date)
                WHEN TO_CHAR(R.Invoice_Date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM R.Invoice_Date)
            END
        AS Invoiceqtryr,
        TO_CHAR(R.Invoice_Date,'MM/YYYY') AS Invoicemthyr,
        K.Group_Id AS Group_Id,
        'Freight' AS Type_Designation,
        D.Customer_No_Pay,
        'Freight' AS Corporate_Form,
        DECODE(R.Currency_Code,'SEK', (R.Net_Curr_Amount * 0.13),'EUR', (R.Net_Curr_Amount * 1.4),'DKK', (R.Net_Curr_Amount * 0.13),R.Net_Curr_Amount
) AS Fixedamounts,
        CASE
                WHEN R.Currency_Code = 'CAD' AND
                     Trunc(R.Invoice_Date) >= TO_DATE('03/01/2013','MM/DD/YYYY') THEN R.Net_Curr_Amount
                WHEN R.Currency_Code != 'USD' THEN R.Net_Curr_Amount * I.Currency_Rate
                ELSE R.Net_Curr_Amount
            END
        AS Allamounts,
        CASE
                WHEN R.Currency_Code IN (
                    'SEK',
                    'DKK'
                ) THEN R.Net_Curr_Amount / J.Currency_Rate
                ELSE R.Net_Curr_Amount
            END
        AS Localamount,
        R.Net_Curr_Amount AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        0 AS Cost,
        'Freight' AS Charge_Type,
        'IFS' AS Source,
        'Market' AS Market_Code,
        ' ' AS Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customerref,
        ' ' AS Deliverydate,
        ' ' AS Ship_Via,
        R.Customer_No AS Delivery_Identity,
        R.Customer_No AS Identity,
        '99' AS Delivery_Address_Id,
        '99' AS Invoice_Address_Id,
        R.Currency_Code,
        0 AS Rma_No,
        ' ' AS Invoiceadd1,
        ' ' AS Invoiceoadd2,
        ' ' AS Invoicecity,
        ' ' AS Invoicestate,
        ' ' AS Invoicezip,
        ' ' AS Invoicecountry,
        ' ' AS Invoicecounty,
        ' ' AS Delivadd1,
        ' ' AS Delivadd2,
        ' ' AS Delivcity,
        ' ' AS Delivstate,
        ' ' AS Delivzip,
        ' ' AS Delivcountry,
        ' ' AS Delivcounty
    FROM
        Instant_Invoice_Rep R
        LEFT JOIN Inventory_Part_Tab B ON R.Object = B.Part_No AND
                                          B.Contract = '100'
        LEFT JOIN Kd_Currency_Rate_4 I ON TO_CHAR(R.Invoice_Date,'MM/YYYY') = I.Valid_From AND
                                          R.Currency_Code = I.Currency_Code
        LEFT JOIN Kd_Currency_Rate_1 J ON TO_CHAR(R.Invoice_Date,'MM/YYYY') = J.Valid_From AND
                                          R.Currency_Code = J.Currency_Code
        LEFT JOIN Identity_Invoice_Info_Tab K ON R.Customer_No = K.Identity AND
                                                 R.Company = '100'
        LEFT JOIN Inventory_Part_Unit_Cost_Sum K ON R.Object = K.Part_No AND
                                                    K.Contract = '100'
        LEFT JOIN Inventory_Part_Unit_Cost_Sum L ON R.Object = K.Part_No AND
                                                    K.Contract = '210',
        Customer_Info_Tab C,
        Cust_Ord_Customer_Tab D,Cust_Ord_Customer_Address_Tab E
        LEFT JOIN Cust_Def_Com_Receiver_Tab F ON E.Customer_No = F.Customer_No
    WHERE
        R.Customer_No = C.Customer_Id AND
        R.Customer_No = D.Customer_No AND
        C.Customer_Id = D.Customer_No AND
        R.Customer_No = E.Customer_No AND
        C.Customer_Id = E.Customer_No AND
        D.Customer_No = E.Customer_No AND
        R.Invoice_Date >= TO_DATE('07/01/2010','MM/DD/YYYY') AND
        E.Addr_No = '99' AND
        R.Row_Type = '1' AND
        R.Object = 'FREIGHT' AND
        R.Invoice_No NOT LIKE 'EI%' AND
        C.Corporate_Form != 'KEY'
    UNION ALL
    SELECT
        '100' AS Site,
        A.Invoice AS Invoice_Id,
        TO_CHAR(A.Linenumber) AS Item_Id,
        Trunc(A.Invoice_Date) Invoicedate,
        A.Qty AS Invoiced_Qty,
        A.Price AS Sales_Unit_Price,
        A.Discount,
        0 AS Net_Curr_Amount,
        0 AS Gross_Curr_Amount,
        Ip.Description AS Catalog_Desc,
        C.Name AS Customer_Name,
        A.Sales_Order AS Order_No,
        A.Key_Code AS Customer_No,
        D.Cust_Grp,
        A.Product_Code AS Catalog_No,
        A.Rowkey AS Authorize_Code,
        D.Salesman_Code,
        ' ' AS Commission_Receiver,
        E.District_Code,
        E.Region_Code,
        Trunc(A.Order_Date) AS Create_Date,
        DECODE(A.Product_Code,Ip.Part_No,Ip.Part_Product_Code,'OTHER') AS Part_Product_Code,
        DECODE(A.Product_Code,Ip.Part_No,Ip.Part_Product_Family,'OTHER') AS Part_Product_Family,
        DECODE(A.Product_Code,Ip.Part_No,Ip.Second_Commodity,'OTHER') AS Second_Commodity,
        CASE
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '01' THEN 'January'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '02' THEN 'February'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '03' THEN 'March'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '04' THEN 'April'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '05' THEN 'May'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '06' THEN 'June'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '07' THEN 'July'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '08' THEN 'August'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '09' THEN 'September'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '10' THEN 'October'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '11' THEN 'November'
                WHEN TO_CHAR(A.Invoice_Date,'MM') = '12' THEN 'December'
            END
        AS Invoicemonth,
        CASE
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
            END
        AS Invoiceqtr,
        CASE
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '01',
                    '02',
                    '03'
                ) THEN 'QTR1'
                       || '/'
                       || EXTRACT(YEAR FROM A.Invoice_Date)
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '04',
                    '05',
                    '06'
                ) THEN 'QTR2'
                       || '/'
                       || EXTRACT(YEAR FROM A.Invoice_Date)
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '07',
                    '08',
                    '09'
                ) THEN 'QTR3'
                       || '/'
                       || EXTRACT(YEAR FROM A.Invoice_Date)
                WHEN TO_CHAR(A.Invoice_Date,'MM') IN (
                    '10',
                    '11',
                    '12'
                ) THEN 'QTR4'
                       || '/'
                       || EXTRACT(YEAR FROM A.Invoice_Date)
            END
        AS Invoiceqtryr,
        TO_CHAR(A.Invoice_Date,'MM/YYYY') AS Invoicemthyr,
        ' ' AS Group_Id,
        DECODE(A.Product_Code,Ip.Part_No,Ip.Type_Designation,'Non-Target') AS Type_Designation,
        A.Key_Code AS Customer_No_Pay,
        C.Corporate_Form,
        A.Extensioncurrdisk AS Fixedamounts,
        CASE
                WHEN A.Currencycode = 'CAD' AND
                     Trunc(A.Invoice_Date) >= TO_DATE('03/01/2013','MM/DD/YYYY') THEN A.Extensioncurrdisk
                WHEN A.Currencycode != 'USD' THEN A.Extensioncurrdisk * G.Currency_Rate
                ELSE A.Extensioncurrdisk
            END
        AS Allamounts,
        A.Extensioncurrdisk AS Localamount,
        A.Extensioncurrdisk AS Truelocalamt,
        0 AS Vat_Dom_Amount,
        ' ' AS Vat_Code,
        Cs.Inventory_Value AS Cost,
        'Parts' AS Charge_Type,
        'SI' AS Source,
        'Market' AS Market_Code,
        C.Association_No,
        0 AS Vat_Curr_Amount,
        ' ' AS Pay_Term_Description,
        ' ' AS Kdreference,
        ' ' AS Customer_Ref,
        TO_CHAR(A.Invoice_Date,'MM/DD/YYYY') AS Deliverydate,
        ' ' AS Ship_Via,
        A.Key_Code AS Delivery_Identity,
        A.Key_Code AS Identity,
        '99' AS Delivery_Address_Id,
        '99' AS Invoice_Address_Id,
        A.Currencycode AS Currency,
        0 AS Rma_No,
        Cis.Address1 AS Invoiceadd1,
        Cis.Address2 AS Invoiceadd2,
        Cis.City AS Invoicecity,
        Cis.State AS Invoicestate,
        Cis.Zip_Code AS Invoicezip,
        Iso_Country_Api.DECODE(Cis.Country) AS Invoicecountry,
        Cis.County AS Invoicecounty,
        Cis.Address1 AS Delivadd1,
        Cis.Address2 AS Delivadd2,
        Cis.City AS Delivcity,
        Cis.State AS Delivstate,
        Cis.Zip_Code AS Delivzip,
        Iso_Country_Api.DECODE(Cis.Country) AS Delivcountry,
        Cis.County AS Delivcounty
    FROM
        Srinvoicessi A
        LEFT JOIN Inventory_Part_Tab Ip ON A.Product_Code = Ip.Part_No AND
                                           Ip.Contract = '100'
        LEFT JOIN Inventory_Part_Unit_Cost_Sum Cs ON A.Product_Code = Cs.Part_No AND
                                                     Cs.Contract = '100'
        LEFT JOIN Customer_Info_Address_Tab Cis ON A.Key_Code = Cis.Customer_Id AND
                                                   Cis.Address_Id = '99'
        LEFT JOIN Identity_Invoice_Info_Tab F ON A.Key_Code = F.Identity AND
                                                 F.Company = '100'
        LEFT JOIN Kd_Currency_Rate_4 G ON A.Currencycode = G.Currency_Code AND
                                          TO_CHAR(A.Invoice_Date,'MM/YYYY') = G.Valid_From,
        Customer_Info_Tab C,
        Cust_Ord_Customer_Tab D,
        Cust_Ord_Customer_Address_Tab E
    WHERE
        A.Key_Code = C.Customer_Id AND
        A.Key_Code = D.Customer_No AND
        A.Key_Code = E.Customer_No AND
        C.Customer_Id = D.Customer_No AND
        C.Customer_Id = E.Customer_No AND
        D.Customer_No = E.Customer_No AND
        Trunc(A.Invoice_Date) >= TO_DATE('01/01/2010','MM/DD/YYYY') AND
        E.Addr_No = '99'
UNION ALL
    Select * From KD_PT_Sales_Data;