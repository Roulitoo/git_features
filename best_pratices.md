# Comment structurer son projet DBT

Cette note de développement n'a pas de garantis dans le temps et évoluera avec les oritentations projets!

## Terminologie

**Upstream** : Element en amont qui va être consommé par votre .sql

**Dowstream** : Element en aval qui va consommer par votre .sql

**DRY** : Don't repeat yourself

## 1-Présentation des différentes couches

### Raw layer

Cette couche reprend l'ensembles des données dont nous disposons. On y retrouve des données :

- First(CRM)
- Second(Filiale)
- Third party(DMP)

Leurs structures & conventions leurs son propres. On ne doit pas modifier leur structure et coller au maximun à leur structure d'origine!

> Les références à ces sources de données doivent être limitées autant que possible.

### Staging Layer

La couche de 'staging' est la fondation de votre modèle. Vous allez ramener les fondations des futures transformations que vous allez réaliser par la suite.

Chaque bloc de staging doit vous permettre de construire les concepts métier sous-jacent.

Cette couche sera representée par un répertoire dans ``/models`` sous le nom de stg.

#### Files and folders management

```bash
models/stg
├── applicatif partenaire
│   ├── _partenaire__docs.md
│   ├── _partenaire__models.yml
│   ├── _partenaire__sources.yml
│   ├── base
│   │   ├── base_partenaire__customers.sql
│   │   └── base_jaffle_shop__deleted_customers.sql
│   ├── stg_jaffle_shop__customers.sql
│   └── stg_jaffle_shop__orders.sql
├── applicatif contrat
│    ├── _stripe__models.yml
│    ├── _stripe__sources.yml
│    └── stg_stripe__payments.sql
│── applicatif produit
    ├── _stripe__models.yml
    ├── _stripe__sources.yml
    └── stg_stripe__payments.sql

```

Il est déconseillé de regrouper par logique business. Le business peut avoir des définitions différentes de chaque concept et nous l'introduirons dans la phase de business view.

🔍 Regroupement par applicatif de données? 🔍

> TIM pour les paiements, Conso, etc..

#### Nom des fichiers & répertoires

##### Folder

La structure en répertoire est extrement important dans DBT. Pas uniquement pour se répérer dans le code en tant que développeur.

L'architecture en folder permet de:

- Représenter le flux de processus de vos données et comment elles circules à travers les transformations
- Facilite la sélection de DBT pour exécuter des sous ensembles de fichiers
- Améliorer la documentation et sa lecture

> dbt build --select stg.part+
>
> Executer l'ensemble des fichiers disponible dans le répertoire /stg/part/

❌ Pas de folder métier à l'étape de stagging, la logique métier intervient plus loin. Ici on traite les données 'brutes'

##### Files

Proposition de naming pour les fichiers.

Attention, il faut séparer la source de l'entité par un double underscore.

✅ `[layer]_[source]__[entity]s.sql`

layer = {raw, stg, bv, uv}

source = Applicatif qui génére la donnée

entity = nom explicite de ce que fait votre script

#### Staging convention

Voici la liste des opérations autorisées et non autorisées dans la phase de staging

✅ Renommer des colonnes

✅ Changer le type des données

✅ Opération sur colonnes basiques ( substr, ...)

✅ Categorisation (case when)

✅ Autoriser d'utiliser la macro `source`

❌ Jointure interdite ( join)

❌ Aggregation intedite (group by)

La relation entre le staging et la RAW est 1:1.

> Les tables raw n'étant pas maitrisées, on limite leur référence à partir de staging car elles peuvent évoluer. Ainsi l'adaptation du code se fera à un unique endroit dans stg.

> 📝 Ces éléments seront vérifiés dans la CI/CD avant de pouvoir passer en DEV

##### Base model

Si une opération nécessite une jointure dans la phase de stagging vous pouvez la réaliser si et seulement si elle vous évite de vous répéter en downstream (DRY).

Pour ce faire vous pouvez créer un subfolder `base` qui contiendra votre jointure avant d'étre appelé en DEV. La relation 1:1 est donc maintenue avec la couche **RAW**.

Merci de le matérialisé en **VUE.**

![img](https://assets-global.website-files.com/6064b31ff49a2d31e0493af1/620c0ab2dbace57dcb8025dd_OzjlBVkvjNKbMMAwkEeGL06-XTv-r_C72JzgDpY4m8H4zKWz8UT5Y8YVIdRTkm1DlSFUacaAW_fTB0KonOL3jgOocMN1dFcyUnkXEx3xomw4RWzhvlaDrkLNkiqA4itS0dfxuOAa.jpeg)

## Intermediate Layer (business view)

A partir de cette étape nous pouvons organiser les sous fichiers par concept métier (Conso, Epargne BAQ, Assurance, Web, Campagne).

Cela permettra de faciliter la lecture et la documentation par groupe métier avec des données qui leur sont propre.

#### Files names

A ce niveau il y a tellement de transformation possible qu'il est impossible de normer totalement les noms de fichiers.

Mais il faut esssayer d'être explicite au maximun et de pouvoir comprendre l'objectif du .sql sans l'ouvrir.

Merci d'utiliser un verbe pour expliciter ce que vous faites dans le .sql

✅ `[bv]_[entity]s__[verbe]s.sql`

> Exemple, bv_aggregated_products_by_users , bv_joined_products_and_customers

**Materialization à choisir ? A creuser**

#### Un modèle ou plusieurs?


Si votre modèle est simple et comporte peu de transformation vous pouvez réaliser de nombreuses jointures dans le .sql.

A l'inverse si celui-ci comporte une opération relativement complexe, il vaut mieux l'isoler dans son propre .sql


#### End user layer

A constuire...



#### YAML naming, convetion 

A construire ...
