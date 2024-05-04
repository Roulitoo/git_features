# Comment utiliser Git pour le développement.


Premiere étape : Créer sa issue


Créer une issue sur Gitlab dans le projet Vision client 360 décrivant ce que vous allez faire lors de votre dévellopement.

👀 Une issue représente une unité de travail logique, exemple :

> Calcul de la notion d'un client crédit agricole
>
> ⚠️ Développement table Partenaire n'est pas un bon exemple



Lors de la création de votre issue merci de remplir les éléments suivants : 

- Label { Part ou Pro}
- Label {a faire, en cours, validation }
- Assign
- Une courte description


Seconde étape :  Créer sa branche de développement

Une fois votre issue créer vous devriez normalement obtenir un ticket avec un numéro de la forme #52.

Il faut maintenant créer une branche de développement appellée **feature.**

Une branche de développement spécifique vous permettra de développer de votré coté sans bloquer les autres et vous permettra de documenter uniquement votre code.

Git Command :

```bash
git branch feature/<nom_issue 52> 

#Aller sur la branche active

git checkout feature/<nom_issue 52>
```


On suppose maintenant que vous avez réalisé un développement qui nécessite de pousser votre code.

```bash
# Ajouter les fichiers modifiés dans l'index local
git add modif_file
# Ajouter les fichiers dans votre repo local
git commit -m 'message sympa pour décrire votre travail + numéro du issue pour associer #52'
#Pousser sur sa branche feature
git push
```


Troisième étape : Pousser son travail sur la branche commune 

Quand vous considérez que votre travail répond à l'issue créée auparavant vous pouvez réeintégrer la branche de DEV.


![](https://wac-cdn.atlassian.com/dam/jcr:4e576671-1b7f-43db-afb5-cf8db8df8e4a/01%20What%20is%20git%20rebase.svg?cdnVersion=1605)


Pour ce faire vous devez fusionner votre branche de travail avec la branche principale.


1) Assurez-vous qu'il n'y a pas trop de différence entre vos branches et la principale

En effet, durant votre développement d'autre personne ont pu modifier la branche principale et cela pourrait entrer en conflit avec votre branche.

Pour cela utiliser la commande Git Fetch `<branch>` puis la commande git diff --name-only `<branch>.`

Cela aura pour effet de lister les fichiers différents.

> Différence Git Fetch & Git pull 
>
> * **La commande git fetch** va récupérer toutes les données des commits effectués sur la branche courante qui n'existent pas encore dans votre version en local. Ces données seront stockées dans le répertoire de travail local mais ne seront pas fusionnées avec votre branche locale. Si vous souhaitez fusionner ces données pour que votre branche soit à jour, vous devez utiliser ensuite la commande git merge.
> * **La commande git pull** est en fait la commande qui regroupe les commandes git fetch suivie de git merge. Cette commande télécharge les données des commits qui n'ont pas encore été récupérées dans votre branche locale puis fusionne ensuite ces données.


✅ Si vous pensez qu'il n'y aura pas de conflit vous pouvez continuer

```bash
#Après votre dernier push sur la branche feature


```
