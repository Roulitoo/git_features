{{ config(materialized='table', schema='BV') }}

{% set list_code_prod_exclu_ei_epar = ('00006','00017','03003','00026')  %} 
-- exclusion des produits PART epargne des EI
{% set list_code_prod_exclu_ei_baq = ('10004','00360','00370','00074','00106','00073','10007','00055','00378','00536','00440','00309','9138')  %} 
-- exclusion des produits PART BAQ des EI
{% set list_code_prod_inclu_ei_assur = ('00615','00625','00631','09007','09008','09009','09144','00332')  %} 
-- inclut des produits PRO assurance present que dans les EI
{% set list_code_prod_inclu_ei_baq = ('00414','00534','00415','00416','20511','20513','20514','22012','20895','20893','20563','20562','00837','00838','00843')  %} 
-- inclut des produits PRO BAQ present que dans les EI
{% set list_code_prod_exclu_credit = ('00565','00316','30034','30204','30200','30202','00493','00488','30030')  %}
-- exclusion des produits PRO credit des PRO non essentiel dans le suivi
{% set list_code_prod_exclu_assur = ('00616','00610','00611','00509','00638','01249','00312','00029','00076')  %}
-- exclusion des produits PRO assurance des PRO non essentiel dans le suivi
{% set list_code_prod_exclu_epar_hors_bilan = ('00019','00033','00115','00322','00328','00335','00394','00395','00398','00452','00453','00455','00456','00589','00592','00594','00595','00597','00598','00665','00671','00674','00807','00822','00826','00830','00886','00887','00919','03014','03029','03041','09024','09026','09042','09043','60002')  %}
-- exclusion des produits PRO epargne hors bilan des PRO non essentiel dans le suivi
{% set list_code_prod_exclu_baq = ('00001','09091','09105','09106','09110','09115','09121','09123','09127','09408','09440','09441','09391','09091','09116')  %}
-- exclusion des produits PRO BAQ des PRO non essentiel dans le suivi

WITH pro_clients AS (

    SELECT DISTINCT *
       FROM {{ ref('bv_pro_clients_marketing') }}
       WHERE typ_client IN ('EI','GA','PM') -- On selectionne tous les clients pro sans filtre (contentieux, dav, ptf BP et BDD, prospects / clients)
),


pro_contrat AS (

    SELECT DISTINCT *
       FROM {{ ref('int_contrat') }}
       WHERE
       df_histo={{ var('date_maj') }} 
       AND top_detention_produit=1
),


fam_prod AS (

    SELECT DISTINCT * 
       FROM {{ ref('int_fam_prod') }}
),


pro_produits AS (

    SELECT  DISTINCT 
            pro_clients.id_part,
            pro_clients.typ_client,
            pro_contrat.id_dwr_edc,
			pro_contrat.id_edc,
            fam_prod.cd_prod_cial,
            fam_prod.li_prod_cial,
            fam_prod.cd_fam_prod,
            fam_prod.li_fam_prod,
            fam_prod.cd_fam_prod_10,
            fam_prod.li_fam_prod_10,
            fam_prod.univers
    
    FROM pro_clients
    
    
    LEFT JOIN pro_contrat  ON pro_clients.id_part=pro_contrat.id_part

    LEFT JOIN fam_prod ON fam_prod.cd_prod_cial=pro_contrat.cd_prod_cial
),


pro_produits_typ_client AS (

	SELECT DISTINCT 
            *,
            CASE WHEN typ_client IN ('ET','PM','GA') THEN 'ET'
            ELSE 'EI' END AS choix_typ_client
        FROM pro_produits

),


-- Exlusion des produits part des EI
pro_produits_pp_ei AS (
	SELECT DISTINCT b.*
	   FROM pro_produits_typ_client a
	   INNER JOIN pro_produits_typ_client b on a.cd_prod_cial=b.cd_prod_cial 
	   AND (b.cd_prod_cial NOT IN {{list_code_prod_exclu_ei_epar}}
	   AND b.cd_prod_cial NOT IN {{list_code_prod_exclu_ei_baq}})
	   AND b.choix_typ_client IN ('EI')
	   WHERE a.choix_typ_client IN ('ET')
   
),


-- Inclure les produits pro present que dans les EI
pro_produits_pp_ei_ajout AS (
	SELECT DISTINCT *
	   FROM pro_produits_typ_client
	   WHERE 
	   choix_typ_client IN ('EI')
	   AND (cd_prod_cial IN ('30014') 
	   OR cd_prod_cial IN {{list_code_prod_inclu_ei_assur}}
	   OR cd_prod_cial IN ('00934')
	   OR cd_prod_cial IN {{list_code_prod_inclu_ei_baq}})
       
),


-- Fusion des produits pro typ_client ET/PM/GA avec les EI
fus_pro_produits AS (
	SELECT DISTINCT * 
	FROM pro_produits_typ_client
	WHERE choix_typ_client IN ('ET')
	UNION
	SELECT *
	FROM pro_produits_pp_ei
	UNION
	SELECT *
	FROM pro_produits_pp_ei_ajout

),


-- Exlusion des produits pro non essentiel
exclut_pro_produits AS (
	SELECT DISTINCT *,
	   CASE WHEN cd_fam_prod IN ('RGP10039','RGP10038')
	   OR cd_prod_cial IN {{list_code_prod_exclu_credit}}
	   OR cd_prod_cial IN {{list_code_prod_exclu_assur}}
	   OR cd_prod_cial IN {{list_code_prod_exclu_epar_hors_bilan}}
	   OR cd_fam_prod IN ('RGP10295','RGP10008','RGP10053')
	   OR (cd_fam_prod IN ('RGP10051') 
	   AND (cd_prod_cial LIKE ('005%') OR cd_prod_cial LIKE ('004%')
	   OR cd_prod_cial LIKE ('0085%') OR cd_prod_cial LIKE ('009%')
	   OR cd_prod_cial LIKE ('011%') OR cd_prod_cial LIKE ('0903%') OR cd_prod_cial LIKE ('0905%')
	   OR cd_prod_cial LIKE ('0933%') OR cd_prod_cial LIKE ('0934%') OR cd_prod_cial LIKE ('0935%')
	   OR cd_prod_cial LIKE ('0937%') OR cd_prod_cial LIKE ('0936%')
	   OR (cd_prod_cial LIKE ('0938%') AND cd_prod_cial NOT IN ('09381'))
	   OR (cd_prod_cial LIKE ('0930%') AND cd_prod_cial NOT IN ('09301','09302'))
	   OR cd_prod_cial LIKE ('0932%') OR cd_prod_cial LIKE ('0931%')
	   ))
	   OR cd_prod_cial IN {{list_code_prod_exclu_baq}}    
			 THEN 1 ELSE 0 END AS FLAG

       FROM fus_pro_produits
   
),


pro_univers AS (

	SELECT DISTINCT
		id_dwr_edc,
		id_edc,
		cd_prod_cial,
		li_prod_cial,
		cd_fam_prod,
		li_fam_prod,
		cd_fam_prod_10,
		li_fam_prod_10,
		univers
	 	FROM exclut_pro_produits
	 	WHERE FLAG=0
		AND cd_prod_cial is not null
    
)


SELECT * FROM pro_univers
