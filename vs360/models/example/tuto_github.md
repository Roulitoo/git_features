# Comment utiliser Git pour le développement.

## 00- Vocabulaire

Local : Votre PC

Remote : Serveur à distance

Repo local : Stockage des opérations de git dans un .git

Repo remote : Serveur Gitlab

CI =  Chaine d'intégration continue

CD : Chaine de développement continue

Test unitaire : Test d'une partie précise d'une fonction

## 1- Créer sa issues(problématique)

Créer une issue sur Gitlab dans le projet Vision client 360 décrivant ce que vous allez faire lors de votre dévellopement.

👀 Une issue représente une unité de travail logique, exemple :

> Calcul de la notion d'un client crédit agricole
>
> ⚠️ ~~Développement table Partenaire~~

Lors de la création de votre issue merci de remplir les éléments suivants :

- Label { Part ou Pro}
- Label {a faire, en cours, validation }
- Assigner  à une personne
- Une courte description

<img src="https://lab.las3.de/gitlab/help/user/project/issues/img/issues_main_view_numbered.jpg" alt="Original Image" width="700" height="600">

L'issue de se décompose en

## 2- Créer sa branche de développement

Il faut maintenant créer une branche de développement appellée **feature.**

> La bonne pratique sera de le nommer **feature/<nom_issue>

![](https://buddy.works/blog/images/feature-branch.png)

Une branche de développement spécifique vous permettra de développer de votré coté sans bloquer les autres et vous permettra de documenter uniquement votre code.

Git Command :

```bash
#Créer une nouvelle branche
git branch feature/<nom_issue 52> 

#Aller sur votre nouvelle branche
git checkout feature/<nom_issue 52>
```

⚠️Pensez à vous placer sur la branche de dev et à télécharger les dernières maj avant de créer votre branche. Autrement votre prendre  branche ne repartira pas de la dernière version mise à jour.

Alimenter successivement sa nouvelle branche.

```bash
# Ajouter les fichiers modifiés dans l'index local
git add modif_file
# Ajouter les fichiers dans votre repo local
git commit -m 'message sympa pour décrire votre travail + numéro du issue pour associer #52'
#Pousser sur sa branche feature
git push
```

## 3- Pousser son travail sur la branche commune

Quand vous considérez que votre travail répond à l'issue créée auparavant vous pouvez réeintégrer la branche de DEV.

![](https://wac-cdn.atlassian.com/dam/jcr:4e576671-1b7f-43db-afb5-cf8db8df8e4a/01%20What%20is%20git%20rebase.svg?cdnVersion=1605)

📖 Quand vous passerez en dev la pipeline CI/CD se déclenchera et si vous la validez votre code passera en Review.

⛔ Review en cours de formalisation

Pour ce faire vous devez fusionner votre branche de travail avec la branche principale.

1) Assurez-vous qu'il n'y a pas trop de différence entre vos branches et la principale

En effet, durant votre développement d'autre personne ont pu modifier la branche principale et cela pourrait entrer en conflit avec votre branche.

Pour cela utiliser la commande Git Fetch `<branch>` puis la commande git diff --name-only `<branch>.`

Cela aura pour effet de lister les fichiers différents.

> Différencegi Git Fetch & Git pull
>
> * **La commande git fetch** va récupérer toutes les données des commits effectués sur la branche courante qui n'existent pas encore dans votre version en local. Ces données seront stockées dans le répertoire de travail local mais ne seront pas fusionnées avec votre branche locale. Si vous souhaitez fusionner ces données pour que votre branche soit à jour, vous devez utiliser ensuite la commande git merge.
> * **La commande git pull** est en fait la commande qui regroupe les commandes git fetch suivie de git merge. Cette commande télécharge les données des commits qui n'ont pas encore été récupérées dans votre branche locale puis fusionne ensuite ces données.

✅ Si vous pensez qu'il n'y aura pas de conflit vous pouvez continuer

```bash
#Après votre dernier push sur la branche feature


```

## 4- Mise en pratique

2 Branches

* Feature/exemple
* Feature/merge_exemple

1- Faire des modifications sur la branche merge

2- Ajouter ses modifications sur le remote (add commit push) Merci de le rattacher à une issue

3- Joindre 2 branches 3.1- Vérifier si pas trop de changement sur la branche princiaple ( fetch )

4- Si tout est ok on rebase (rejoindre la branche principale) Ca ajoute vos fichiers Puis on reprend le push pull legs (add commit push)

drop un git push origin --delete <branch_name>
