CREATE OR REPLACE VIEW kd_svq AS
SELECT
                a.salesman_code,
                e.name,
                a.region,
                nvl(d.today,0) AS today,
                nvl(c.this_month,0) AS this_month,
                nvl(l.py_this_month_sd,0) AS pymtd_sd,
                nvl(c.this_month_implants,0) AS this_month_implants,
                nvl(c.this_month_bio,0) AS this_month_bio,
                nvl(c.month_quota_pct,0) AS month_quota_pct,
                nvl(c.month_quota_pct_impl,0) AS month_quota_pct_impl,
                nvl(c.month_quota_pct_bio,0) AS month_quota_pct_bio,
                c.mtd_quota,
                c.mtd_quota_impl,
                c.mtd_quota_bio,
                c.mtd_quota_remaining,
                c.mtd_quota_impl_remaining,
                c.mtd_quota_bio_remaining,
                nvl(c.mtd_quota_pct,0) AS mtd_quota_pct,
                c.mtd_quota_pct_impl,
                c.mtd_quota_pct_bio,
                c.month_remaining,
                c.month_remaining_impl,
                c.month_remaining_bio,
                nvl(b.this_quarter,0) AS this_quarter,
                nvl(k.py_this_quarter_sd,0) AS pyqtd_sd,
                b.this_quarter_implants,
                b.this_quarter_bio,
                nvl(b.quarter_quota_pct,0) AS quarter_quota_pct,
                b.quarter_quota_pct_impl,
                b.quarter_quota_pct_bio,
                nvl(b.qtd_quota_pct,0) AS qtd_quota_pct,
                b.qtd_quota_pct_impl,
                b.qtd_quota_pct_bio,
                b.quarter_remaining,
                b.quarter_remaining_impl,
                b.quarter_remaining_bio,
                nvl(a.this_year,0) AS this_year,
                a.this_year_implants,
                a.this_year_bio,
                nvl(j.py_year_sd,0) AS pyytd_sd,
                nvl(a.year_quota_pct,0) AS year_quota_pct,
                a.year_quota_pct_impl,
                a.year_quota_pct_bio,
                a.ytd_quota,
                nvl(a.ytd_quota_pct,0) AS ytd_quota_pct,
                a.ytd_quota_remaining,
                a.ytd_quota_impl,
                a.ytd_quota_pct_impl,
                a.ytd_quota_impl_remaining,
                a.ytd_quota_bio,
                a.ytd_quota_pct_bio,
                a.ytd_quota_bio_remaining,
                a.year_remaining,
                a.year_remaining_impl,
                a.year_remaining_bio,
                h.month_quota_pct_reg,
                h.month_quota_pct_impl_reg,
                h.month_quota_pct_bio_reg,
                h.mtd_quota_pct_reg,
                h.mtd_quota_pct_impl_reg,
                h.mtd_quota_pct_bio_reg,
                h.py_mtd_sd_reg,
                g.quarter_quota_pct_reg,
                g.quarter_quota_pct_impl_reg,
                g.quarter_quota_pct_bio_reg,
                g.qtd_quota_pct_reg,
                g.qtd_quota_pct_impl_reg,
                g.qtd_quota_pct_bio_reg,
                g.py_qtd_sd_reg,
                f.year_quota_pct_reg,
                f.year_quota_pct_impl_reg,
                f.year_quota_pct_bio_reg,
                f.ytd_quota_pct_reg,
                f.ytd_quota_pct_impl_reg,
                f.ytd_quota_pct_bio_reg,
                f.py_ytd_sd_reg,
                i.year_quota_pct_total,
                i.year_quota_pct_impl_total,
                i.year_quota_pct_bio_total,
                i.ytd_quota_pct_total,
                i.ytd_quota_pct_impl_total,
                i.ytd_quota_pct_bio_total,
                i.py_year_sd_total,
                i.quarter_quota_pct_total,
                i.quarter_quota_pct_impl_total,
                i.quarter_quota_pct_bio_total,
                i.qtd_quota_pct_total,
                i.qtd_quota_pct_impl_total,
                i.qtd_quota_pct_bio_total,
                i.py_quarter_sd_total,
                i.month_quota_pct_total,
                i.month_quota_pct_impl_total,
                i.month_quota_pct_bio_total,
                i.mtd_quota_pct_total,
                i.mtd_quota_pct_impl_total,
                i.mtd_quota_pct_bio_total,
                i.py_month_sd_total
FROM
                kd_svq_ytd a 
                    LEFT JOIN kd_svq_qtd b
                        ON a.salesman_code = b.salesman_code
                   LEFT JOIN kd_svq_mtd c
                        ON a.salesman_code = c.salesman_code
                   LEFT JOIN kd_svq_today d
                        ON a.salesman_code = d.salesman_code
                   LEFT JOIN person_info e
                        ON a.salesman_code = e.person_id
                   LEFT JOIN kd_svq_ytd_reg f
                        ON a.region = f.region
                   LEFT JOIN kd_svq_qtd_reg g
                        ON a.region = g.region
                   LEFT JOIN kd_svq_mtd_reg h
                        ON a.region = h.region
                   LEFT JOIN kd_py_year_sd j
                        ON a.salesman_code = j.salesman_code
                   LEFT JOIN kd_py_qtr_sd k
                        ON a.salesman_code = k.salesman_code
                   LEFT JOIN kd_py_month_sd l
                        ON a.salesman_code = l.salesman_code,
                kd_svq_totals_td i;