WITH delzips AS (
    SELECT              customer_id,
                        cust_ord_customer_api.get_salesman_code(customer_id) AS current_salesman
    FROM                customer_info
    WHERE               kd_get_corporate_form(customer_id) = 'DOMDIR' AND
                        customer_info_address_api.get_zip_code(
                            customer_id,customer_info_address_api.get_default_address(
                                customer_id,'Delivery'
                            )
                        ) IN (   
'89001',
'89002',
'89003',
'89004',
'89005',
'89007',
'89008',
'89010',
'89011',
'89012',
'89013',
'89014',
'89015',
'89017',
'89018',
'89019',
'89020',
'89021',
'89023',
'89025',
'89026',
'89027',
'89029',
'89030',
'89031',
'89032',
'89034',
'89039',
'89040',
'89042',
'89043',
'89044',
'89046',
'89047',
'89048',
'89049',
'89052',
'89054',
'89060',
'89061',
'89074',
'89081',
'89084',
'89085',
'89086',
'890MH',
'890MX',
'89101',
'89102',
'89103',
'89104',
'89106',
'89107',
'89108',
'89109',
'89110',
'89113',
'89115',
'89117',
'89118',
'89119',
'89120',
'89121',
'89122',
'89123',
'89124',
'89128',
'89129',
'89130',
'89131',
'89134',
'89135',
'89138',
'89139',
'89141',
'89142',
'89143',
'89144',
'89145',
'89146',
'89147',
'89148',
'89149',
'89156',
'89158',
'89161',
'89165',
'89166',
'89169',
'89178',
'89179',
'89183',
'89191',
'891MX',
'89314',
'91001',
'91006',
'91007',
'91008',
'91010',
'91011',
'91016',
'91024',
'91030',
'91101',
'91103',
'91104',
'91105',
'91106',
'91107',
'91108',
'91201',
'91202',
'91203',
'91204',
'91205',
'91206',
'91207',
'91208',
'91210',
'91701',
'91702',
'91706',
'91708',
'91709',
'91710',
'91711',
'91722',
'91723',
'91724',
'91730',
'91731',
'91732',
'91737',
'91739',
'91740',
'91741',
'91743',
'91744',
'91746',
'91750',
'91752',
'91759',
'91761',
'91762',
'91763',
'91764',
'91765',
'91766',
'91767',
'91768',
'91773',
'91775',
'91780',
'91784',
'91786',
'92585',
'92586',
'92587',
'92590',
'92591',
'92592',
'92595',
'92596',
'92860',
'92879',
'92880',
'92881',
'92882',
'92883',
'93201',
'93202',
'93203',
'93205',
'93206',
'93207',
'93208',
'93212',
'93215',
'93218',
'93219',
'93221',
'93223',
'93224',
'93226',
'93230',
'93235',
'93238',
'93240',
'93241',
'93244',
'93245',
'93246',
'93247',
'93249',
'93250',
'93251',
'93255',
'93256',
'93257',
'93260',
'93261',
'93263',
'93265',
'93266',
'93267',
'93268',
'93270',
'93271',
'93272',
'93274',
'93276',
'93277',
'93280',
'93283',
'93285',
'93286',
'93287',
'93291',
'93292',
'932MX',
'93301',
'93304',
'93305',
'93306',
'93307',
'93308',
'93309',
'93311',
'93312',
'93313',
'93314',
'93501',
'93505',
'93516',
'93518',
'93519',
'93523',
'93524',
'93527',
'93531',
'93561',
'91789',
'91790',
'91791',
'91792',
'92004',
'92201',
'92203',
'92210',
'92211',
'92220',
'92222',
'92223',
'92225',
'92227',
'92230',
'92231',
'92233',
'92234',
'92236',
'92239',
'92240',
'92241',
'92243',
'92249',
'92250',
'92251',
'92252',
'92253',
'92254',
'92256',
'92257',
'92258',
'92259',
'92260',
'92262',
'92264',
'92266',
'92268',
'92270',
'92274',
'92275',
'92276',
'92277',
'92278',
'92280',
'92281',
'92282',
'92283',
'92284',
'92285',
'922MX',
'92301',
'92304',
'92305',
'92307',
'92308',
'92309',
'92310',
'92311',
'92313',
'92314',
'92315',
'92316',
'92317',
'92318',
'92320',
'92321',
'92322',
'92324',
'92325',
'92327',
'92328',
'92332',
'92333'
                        )),
Sales AS (
SELECT                  customer_no,
                        SUM(CASE WHEN part_product_code = 'REGEN' THEN allamounts ELSE 0 END) AS REGEN,
                        SUM(CASE WHEN part_product_code != 'REGEN' THEN allamounts ELSE 0 END) AS IMPL
FROM                    kd_sales_data_request kdsd
                            WHERE
                                Extract(Year From kdsd.Invoicedate)= Extract(Year From Sysdate)-1 And
                                kdsd.Charge_Type = 'Parts' And
                                kdsd.Corporate_Form = 'DOMDIR' And
                                kdsd.Catalog_No != '3DBC-22001091' And
                                ((kdsd.Order_No Not Like 'W%' And
                                  kdsd.Order_No Not Like 'X%')Or
                                 kdsd.Order_No Is Null)And
                                (kdsd.Market_Code != 'PREPOST' Or
                                 kdsd.Market_Code Is Null)And
                                kdsd.Invoice_Id != 'CR1001802096' And --20180904 Invoice is stuck not posted and cannot be deleted.
                                (kdsd.Order_No != 'C512921' Or kdsd.Order_No Is Null) --Kevin Stack's order/return that spanned years.
GROUP BY                customer_no)

Select delzips.customer_id, delzips.current_salesman, sales.regen, sales.impl From delzips left join sales on delzips.customer_id = sales.customer_no