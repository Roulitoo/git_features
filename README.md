-- Création de la table client_status (Table 1)
CREATE TABLE client_status (
    id_part INT,
    client STRING,
    dd DATE,
    df DATE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Insertion des données dans la table client_status
INSERT INTO client_status VALUES
(1, 'OUI', '2024-08-19', '9999-12-31'),
(1, 'NON', '2023-05-12', '2024-08-19'),
(2, 'NON', '2022-03-10', '2023-06-12'),
(2, 'OUI', '2023-06-12', '9999-12-31'),
(3, 'OUI', '2023-06-12', '9999-12-31');


-- Création de la table client_activity (Table 2)
CREATE TABLE client_activity (
    id_part INT,
    isactive INT,
    dd DATE,
    df DATE
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

-- Insertion des données dans la table client_activity
INSERT INTO client_activity VALUES
(1, 1, '2018-02-10', '9999-12-31'),
(2, 0, '2015-03-10', '2022-03-10'),
(2, 1, '2022-03-10', '9999-12-31'),
(3, 0, '2021-06-10', '9999-12-31');


---------

-- Étape 1 : Créer une table temporaire pour combiner les périodes
WITH combined_periods AS (
    SELECT
        t1.id_part,
        t1.client,
        t2.isactive,
        GREATEST(t1.dd, t2.dd) AS dd,
        LEAST(t1.df, t2.df) AS df
    FROM
        client_status t1
    JOIN
        client_activity t2
    ON
        t1.id_part = t2.id_part
    WHERE
        t1.dd < t2.df AND t1.df > t2.dd
)

-- Étape 2 : Insérer les résultats dans la table finale
INSERT INTO table3 (id_part, client, isactive, dd, df)
SELECT
    id_part,
    CASE 
        WHEN client = 'OUI' THEN 1
        WHEN client = 'NON' THEN 0
    END AS client,
    isactive,
    dd,
    df
FROM
    combined_periods
ORDER BY
    id_part, dd;

