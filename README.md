```sql
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
```

--------------------------

```sql
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
```

--------------


```sql
-- Étape 1 : Créer une table temporaire pour combiner les périodes avec un FULL OUTER JOIN
WITH combined_periods AS (
    SELECT
        COALESCE(t1.id_part, t2.id_part) AS id_part,
        CASE
            WHEN t1.client = 'OUI' THEN 1
            WHEN t1.client = 'NON' THEN 0
            ELSE NULL
        END AS client,
        COALESCE(t2.isactive, 0) AS isactive,
        GREATEST(COALESCE(t1.dd, '1900-01-01'), COALESCE(t2.dd, '1900-01-01')) AS dd,
        LEAST(COALESCE(t1.df, '9999-12-31'), COALESCE(t2.df, '9999-12-31')) AS df
    FROM
        client_status t1
    FULL OUTER JOIN
        client_activity t2
    ON
        t1.id_part = t2.id_part
    AND
        t1.dd <= t2.df
    AND
        t1.df >= t2.dd
)

-- Étape 2 : Insérer les résultats dans la table finale
SELECT
    id_part,
    CASE
        WHEN client IS NOT NULL THEN client
        ELSE NULL
    END AS client,
    isactive,
    dd,
    df
FROM
    combined_periods
ORDER BY
    id_part, dd;

```
