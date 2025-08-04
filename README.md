{{ config(materialized='table', schema='BV') }}

{% set list_code_prod_exclu_ei_epar = ('00006','00017','03003','00026') %}
{% set list_code_prod_exclu_ei_baq = ('10004','00360','00370','00074','00106','00073','10007','00055','00378','00536','00440','00309','9138') %}
{% set list_code_prod_inclu_ei_assur = ('00615','00625','00631','09007','09008','09009','09144','00332') %}
{% set list_code_prod_inclu_ei_baq = ('00414','00534','00415','00416','20511','20513','20514','22012','20895','20893','20563','20562','00837','00838','00843') %}
{% set list_code_prod_exclu_credit = ('00565','00316','30034','30204','30200','30202','00493','00488','30030') %}
{% set list_code_prod_exclu_assur = ('00616','00610','00611','00509','00638','01249','00312','00029','00076') %}
{% set list_code_prod_exclu_epar_hors_bilan = ('00019','00033','00115','00322','00328','00335','00394','00395','00398','00452','00453','00455','00456','00589','00592','00594','00595','00597','00598','00665','00671','00674','00807','00822','00826','00830','00886','00887','00919','03014','03029','03041','09024','09026','09042','09043','60002') %}
{% set list_code_prod_exclu_baq = ('00001','09091','09105','09106','09110','09115','09121','09123','09127','09408','09440','09441','09391','09091','09116') %}

WITH pro_clients AS (
    SELECT id_part, typ_client
    FROM {{ ref('bv_pro_clients_marketing') }}
    WHERE typ_client IN ('EI', 'GA', 'PM')
),

pro_contrat_filtre AS (
    SELECT id_part, id_dwr_edc, id_edc, cd_prod_cial
    FROM {{ ref('int_contrat') }}
    WHERE df_histo = {{ var('date_maj') }}
      AND top_detention_produit = 1
),

fam_prod_filtre AS (
    SELECT cd_prod_cial, li_prod_cial, cd_fam_prod, li_fam_prod, cd_fam_prod_10, li_fam_prod_10, univers
    FROM {{ ref('int_fam_prod') }}
),

produits_jointures AS (
    SELECT
        cl.id_part,
        cl.typ_client,
        CASE 
            WHEN cl.typ_client IN ('ET','PM','GA') THEN 'ET'
            ELSE 'EI'
        END AS choix_typ_client,
        co.id_dwr_edc,
        co.id_edc,
        co.cd_prod_cial,
        fp.li_prod_cial,
        fp.cd_fam_prod,
        fp.li_fam_prod,
        fp.cd_fam_prod_10,
        fp.li_fam_prod_10,
        fp.univers
    FROM pro_clients cl
    INNER JOIN pro_contrat_filtre co ON cl.id_part = co.id_part
    LEFT JOIN fam_prod_filtre fp ON co.cd_prod_cial = fp.cd_prod_cial
),

produits_filtres AS (
    SELECT *,
        CASE 
            -- Exclusions spécifiques EI
            WHEN choix_typ_client = 'EI' AND cd_prod_cial IN {{ list_code_prod_exclu_ei_epar }} THEN 0
            WHEN choix_typ_client = 'EI' AND cd_prod_cial IN {{ list_code_prod_exclu_ei_baq }} THEN 0

            -- Inclusions spécifiques EI
            WHEN choix_typ_client = 'EI' AND cd_prod_cial IN {{ list_code_prod_inclu_ei_assur }} THEN 1
            WHEN choix_typ_client = 'EI' AND cd_prod_cial IN {{ list_code_prod_inclu_ei_baq }} THEN 1
            WHEN choix_typ_client = 'EI' AND cd_prod_cial IN ('30014', '00934') THEN 1

            -- Exclusions PRO tous types
            WHEN cd_fam_prod IN ('RGP10039','RGP10038','RGP10295','RGP10008','RGP10053') THEN 0
            WHEN choix_typ_client = 'ET' AND cd_prod_cial IN {{ list_code_prod_exclu_credit }} THEN 0
            WHEN choix_typ_client = 'ET' AND cd_prod_cial IN {{ list_code_prod_exclu_assur }} THEN 0
            WHEN choix_typ_client = 'ET' AND cd_prod_cial IN {{ list_code_prod_exclu_epar_hors_bilan }} THEN 0
            WHEN choix_typ_client = 'ET' AND cd_prod_cial IN {{ list_code_prod_exclu_baq }} THEN 0

            -- Exclusions complexes (regex simplifiées)
            WHEN cd_fam_prod = 'RGP10051' AND (
                cd_prod_cial LIKE '005%' OR cd_prod_cial LIKE '004%' OR cd_prod_cial LIKE '0085%' OR
                cd_prod_cial LIKE '009%' OR cd_prod_cial LIKE '011%' OR cd_prod_cial LIKE '0903%' OR
                cd_prod_cial LIKE '0905%' OR cd_prod_cial LIKE '0933%' OR cd_prod_cial LIKE '0934%' OR
                cd_prod_cial LIKE '0935%' OR cd_prod_cial LIKE '0937%' OR cd_prod_cial LIKE '0936%' OR
                (cd_prod_cial LIKE '0938%' AND cd_prod_cial NOT IN ('09381')) OR
                (cd_prod_cial LIKE '0930%' AND cd_prod_cial NOT IN ('09301','09302')) OR
                cd_prod_cial LIKE '0932%' OR cd_prod_cial LIKE '0931%'
            ) THEN 0

            -- Par défaut on garde
            ELSE 1
        END AS flag_keep
    FROM produits_jointures
)

SELECT 
    id_dwr_edc,
    id_edc,
    cd_prod_cial,
    li_prod_cial,
    cd_fam_prod,
    li_fam_prod,
    cd_fam_prod_10,
    li_fam_prod_10,
    univers
FROM produits_filtres
WHERE flag_keep = 1
  AND cd_prod_cial IS NOT NULL
