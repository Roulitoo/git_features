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

Cette couche sera representée par un répertoire dans ``/models`` sous le nom de stg.

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

✅ Renommer des colonnes

✅ Changer le type des données

✅ Opération sur colonnes basiques ( substr, ...)

✅ Categorisation (case when)

✅ Autoriser d'utiliser la macro `source`

❌ Jointure interdite ( join)

❌ Aggregation intedite (group by)




```markdown
:::tip Don’t Repeat Yourself.
Staging models help us keep our code <Term id='dry'>DRY</Term>. dbt's modular, reusable structure means we can, and should, push any transformations that we’ll always want to use for a given component model as far upstream as possible. This saves us from potentially wasting code, complexity, and compute doing the same transformation more than once. For instance, if we know we always want our monetary values as floats in dollars, but the source system is integers and cents, we want to do the division and type casting as early as possible so that we can reference it rather than redo it repeatedly downstream.
:::
```
