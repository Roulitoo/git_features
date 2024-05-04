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
