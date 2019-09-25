SELECT          
                coce.salesman_code,
                cq.customer_id,
                cq.prior_year_bio,
                (cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustmen_bio AS quota_bio,
                cq.prior_year_impl,
                (cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl AS quota_impl
FROM
                kd_quota_cust_config cq
                LEFT JOIN cust_ord_customer_ent coce ON
                    cq.customer_id = coce.customer_id;
                    
SELECT
                coce.salesman_code,
                SUM(prior_year_bio) AS py_bio,
                SUM((prior_year_bio * (1 + growth_rate_bio)) - cq.adjustment_bio) AS quota_bio,
                SUM(prior_year_impl) AS py_impl,
                SUM((prior_year_impl * (1 + growth_rate_impl)) - cq.adjustment_impl) AS quota_impl
FROM
                kd_quota_cust_config cq
                LEFT JOIN cust_ord_customer_ent coce ON
                    cq.customer_id = coce.customer_id
GROUP BY
                coce.salesman_code;
                
SELECT
                coce.salesman_code,
                cq.customer_id,
                cq.prior_year_bio,
                (cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio AS quota_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(1) AS m1_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(2) AS m2_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(3) AS m3_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(4) AS m4_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(5) AS m5_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(6) AS m6_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(7) AS m7_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(8) AS m8_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(9) AS m9_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(10) AS m19_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(11) AS m11_bio,
                ((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(12) AS m12_bio,
                cq.prior_year_impl,
                (cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl AS quota_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(1) AS m1_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(2) AS m2_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(3) AS m3_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(4) AS m4_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(5) AS m5_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(6) AS m6_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(7) AS m7_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(8) AS m8_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(9) AS m9_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(10) AS m10_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(11) AS m11_impl,
                ((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(12) AS m12_impl
FROM
                kd_quota_cust_config cq
                LEFT JOIN cust_ord_customer_ent coce ON
                    cq.customer_id = coce.customer_id,
                kd_quota_month_dist;
                
SELECT
                rq.salesman_code,
                rq.region_code,
                --cq.customer_id,
                SUM(cq.prior_year_bio),
                SUM((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) AS quota_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(1)) AS m1_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(2)) AS m2_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(3)) AS m3_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(4)) AS m4_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(5)) AS m5_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(6)) AS m6_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(7)) AS m7_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(8)) AS m8_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(9)) AS m9_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(10)) AS m19_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(11)) AS m11_bio,
                SUM(((cq.prior_year_bio * (1 + cq.growth_rate_bio)) - cq.adjustment_bio) * kd_quota_month_dist_api.get_month_dist_decimal(12)) AS m12_bio,
                SUM(cq.prior_year_impl),
                SUM((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) AS quota_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(1)) AS m1_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(2)) AS m2_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(3)) AS m3_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(4)) AS m4_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(5)) AS m5_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(6)) AS m6_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(7)) AS m7_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(8)) AS m8_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(9)) AS m9_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(10)) AS m10_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(11)) AS m11_impl,
                SUM(((cq.prior_year_impl * (1 + cq.growth_rate_impl)) - cq.adjustment_impl) * kd_quota_month_dist_api.get_month_dist_decimal(12)) AS m12_impl
FROM
                kd_quota_cust_config cq
                LEFT JOIN cust_ord_customer_ent coce ON
                    cq.customer_id = coce.customer_id
                LEFT JOIN kd_quota_rep_config rq ON
                    coce.salesman_code = rq.salesman_code
GROUP BY
                rq.salesman_code,
                rq.region_code