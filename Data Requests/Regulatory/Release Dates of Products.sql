Select
  A.Catalog_No,
  A.Characteristic_Code,
  To_Date(Substr(A.Objversion,0,8),'YYYY-MM-DD') As "Date"
From
  Sales_Part_Characteristic A
Where
  A.Catalog_No In ('ITT408','ITT410','ITT412','ITT414','ITT508','ITT510','ITT512','ITT514','ITT608','ITT610','ITT612','ITST12d-508','ITST12d-510','ITST12D-512','ITST12d-514',
                   'MAXIT7-11','MAXIT7-7','MAXIT7-9','MAXIT8-11','MAXIT8-7','MAXIT8-9','MAXIT9-11','MAXIT9-7','MAXIT9-9','P-CAP-40','P-CAP-55','P-CAP6-40','P-CAP6-55',
                   'P-CAP-W40','TT1','TT2','TT3','TT4.5','TT6-1','TT6-2','TT6-3','TT6-5','TT6-6','TT0','TT6-0','ITS6-PA','ITS6-PA-ne','ITS6-PC1','ITS6-PC1ne','ITS-GC1','ITS-GC1ne','ITS-PA','ITS-PA-ne','ITS-PC1','ITS-PC1ne','TSA6-4','TSA6-5.5',
                   'TSAF4','TSAF5.5','WP-GC-S3','ITS6-TC1','ITS6-TC1ne','ITS-TC1','ITS-TC1ne','IIA-1','IIA-2','IIA-6','IIAP4','IIAP5.5','IIAP6-4','IIAP6-5.5','LT6-7/10','LT7/10','LT7/20','ITS6-TRC5','ITS6-TRCne-2','ITS6-TRCne-4','ITS-TRC5','ITS-TRCne-2',
                   'LAF4','LAF5.5','LAF6-4','LAF6-5.5','LITS4','LITS6','LSIT2','GSU1','GSU2','GSU3','GSU9','TSIT2','TS-IT-PA','TST2','TSTZ2','TSU1','TSU2','TSU3','TSU9','TSUZ9','I-KIT-OCT-XT','I-KIT-MAXIT')