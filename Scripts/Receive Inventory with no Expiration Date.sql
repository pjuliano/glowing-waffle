DECLARE
   a_ VARCHAR2(32000) := '100'; --p0
   b_ VARCHAR2(32000) := '40-70097'; --p1
   c_ VARCHAR2(32000) := '*'; --p2
   d_ VARCHAR2(32000) := 'BURLINGTON'; --p3
   e_ VARCHAR2(32000) := 'WO-004788'; --p4
   f_ VARCHAR2(32000) := '*'; --p5
   g_ VARCHAR2(32000) := '1'; --p6
   h_ VARCHAR2(32000) := '*'; --p7
   i_ DATE := NULL; --p8
   j_ FLOAT := 5; --p9
   k_ FLOAT := NULL; --p10
   l_ VARCHAR2(32000) := '9998'; --p11
   m_ VARCHAR2(32000) := '0001'; --p12
   n_ VARCHAR2(32000) := ''; --p13
   o_ VARCHAR2(32000) := ''; --p14
   p_ VARCHAR2(32000) := ''; --p15
   q_ VARCHAR2(32000) := ''; --p16
   r_ VARCHAR2(32000) := ''; --p17
   s_ VARCHAR2(32000) := ''; --p18
   t_ VARCHAR2(32000) := ''; --p19
   u_ VARCHAR2(32000) := ''; --p20
   v_ VARCHAR2(32000) := ''; --p21
   w_ FLOAT := NULL; --p22
   x_ VARCHAR2(32000) := ''; --p23
   y_ VARCHAR2(32000) := ''; --p24
BEGIN
    FOR parts IN (SELECT * FROM KD_DATA_MIGRATION WHERE exp_date = '0')
    LOOP    
        a_ := '100'; --p0
        b_ := parts.item_number; --p1
        c_ := '*'; --p2
        d_ := 'BURLINGTON'; --p3
        e_:= parts.batch_number; --p4
        f_ := '*'; --p5
        g_ := '1'; --p6
        h_ := '*'; --p7
        i_ := NULL; --p8
        j_ := parts.qty; --p9
        k_ := NULL; --p10
        l_ := '9998'; --p11
        m_ := '0001'; --p12
        n_ := ''; --p13
        o_ := ''; --p14
        p_ := ''; --p15
        q_ := ''; --p16
        r_ := ''; --p17
        s_ := ''; --p18
        t_ := ''; --p19
        u_ := ''; --p20
        v_ := ''; --p21
        w_ := NULL; --p22
        x_ := ''; --p23
        y_ := ''; --p24
        IFSAPP.Inventory_Part_In_Stock_API.Receive_Part_With_Posting(a_ , b_ , c_ , d_ , e_ , f_ , g_ , h_ , 0, 'NREC', i_ , j_ , 0, k_ , l_ , m_ , n_ , o_ , p_ , q_ , r_ , s_ , t_ , u_ , v_ , NULL, w_ , x_ , y_ );
    END LOOP;
END;
