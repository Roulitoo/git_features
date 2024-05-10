# Comment structurer son projet DBT

Cette note de développement n'a pas de garantis dans le temps et évoluera avec les oritentations projets!


## 1-Présentation des différentes couches

### Raw layer 

Cette couche reprend l'ensembles des données dont nous disposons. On y retrouve des données : 
- First(CRM) 
- Second(Filiale)
- Third party(DMP)

Leurs structures & conventions leurs son propres. On ne doit pas modifier leur structure et coller au maximun à leur structure d'origine!

> Les références à ces sources de données doivent être limitées autant que possible.


### Staging Layer   

La couche de 'staging' est la fondation de votre modèle. Vous allez ramener les fondations des futures transformations que vous allez réalier par la suite.

Cette couche sera representée par un répertoire dans ```/models``` sous le nom de stg.

#### Files and folders management

```bash
models/stg
├── partenaire
│   ├── _partenaire__docs.md
│   ├── _partenaire__models.yml
│   ├── _partenaire__sources.yml
│   ├── base
│   │   ├── base_partenaire__customers.sql
│   │   └── base_jaffle_shop__deleted_customers.sql
│   ├── stg_jaffle_shop__customers.sql
│   └── stg_jaffle_shop__orders.sql
├── Contrat
│    ├── _stripe__models.yml
│    ├── _stripe__sources.yml
│    └── stg_stripe__payments.sql
│── produit
    ├── _stripe__models.yml
    ├── _stripe__sources.yml
    └── stg_stripe__payments.sql

```

Il est déconseillé de regrouper par logique business. Le business peut avoir des définitions différentes de chaque concept et nous l'introduirons dans la phase de business view.

🔍 Regroupement par applicatif de données? 🔍


Staging 
Base models when joins are necessary to stage concepts. Sometimes, in order to maintain a clean and DRY staging layer we do need to implement some joins to create a solid concept for our building blocks. In these cases, we recommend creating a sub-directory in the staging directory for the source system in question and building base models. These have all the same properties that would normally be in the staging layer, they will directly source the raw data and do the non-joining transformations, then in the staging models we’ll join the requisite base models. The most common use cases for building a base layer under a staging folder are:

Intermediate


Marts



Limiter les raw data 
Your dbt project will depend on raw data stored in your database. Since this data is normally loaded by third parties, the structure of it can change over time – tables and columns may be added, removed, or renamed. When this happens, it is easier to update models if raw data is only referenced in one place.


2- Les règles & conventions