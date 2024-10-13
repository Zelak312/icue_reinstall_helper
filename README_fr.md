# Script d'Aide à la Réinstallation d'iCUE

## Language / Langue

[**English**](README.md) | [**Français**](README_fr.md)

## Aperçu

Ce script PowerShell vous aide à **réinstaller iCUE** (le logiciel de contrôle RGB de Corsair) sans nécessiter de redémarrage ou de mode sans échec. Il ferme de force l'application iCUE, arrête les services et les pilotes associés, sauvegarde le répertoire d'installation et réinstalle iCUE.

## Fonctionnalités

-   **Ferme iCUE** s'il est en cours d'exécution.
-   **Arrête les services et les pilotes** liés à iCUE.
-   **Sauvegarde le répertoire d'installation d'iCUE**.
-   **Déplace les fichiers verrouillés** (comme `CorsairLLAccess64.sys`) qui ne peuvent pas être supprimés.
-   **Supprime le répertoire iCUE**, même s'il est verrouillé ou contient des fichiers verrouillés.
-   **Télécharge et installe la dernière version d'iCUE**.
-   **Enregistre toutes les étapes** et les actions effectuées pour des fins de débogage.

## Prérequis

-   **Privilèges administratifs** : Le script demandera automatiquement des droits administratifs si vous ne les avez pas déjà.
-   **Connexion Internet** : Le script téléchargera la dernière version de l'installateur d'iCUE.

## Flux de travail du script

1. **Vérifie si le script est exécuté avec des privilèges administratifs**. Si ce n'est pas le cas, il se relancera avec des privilèges élevés.
2. **Ferme iCUE** s'il est en cours d'exécution.
3. **Arrête les services liés à iCUE**.
4. **Arrête les pilotes de noyau** utilisés par le matériel Corsair.
5. **Sauvegarde le répertoire d'installation d'iCUE** pour éviter toute perte de données.
6. **Tente de supprimer le répertoire d'installation**. Si un fichier (comme `CorsairLLAccess64.sys`) est verrouillé, il sera déplacé dans le dossier temporaire avant de tenter de nouveau la suppression.
7. **Télécharge l'installateur d'iCUE** et **lance l'installation** d'iCUE.
8. **Enregistre toutes les actions** pour un débogage et une référence future.

## Comment utiliser

1. **Téléchargez** le script (`icue_reinstall_helper.ps1`) sur votre machine locale.
2. **Cliquez-droit** sur le fichier du script et sélectionnez **Exécuter avec PowerShell**.
3. Le script demandera des **autorisations administratives**. Accordez les autorisations pour qu'il puisse continuer.
4. Le script va **fermer iCUE de force**, arrêter les services et les pilotes associés, puis tenter de supprimer l'ancien répertoire iCUE.
5. Si nécessaire, le script **déplacera les fichiers verrouillés** dans le dossier temporaire et réessaiera la suppression du répertoire.
6. Une fois le répertoire supprimé avec succès, le script **téléchargera et installera la dernière version d'iCUE**.
7. Après l'installation, le script affichera un message "Have Fun :)".

## Contact

Si vous rencontrez des problèmes ou avez des questions, vous pouvez me contacter via :

-   **Problèmes GitHub** : [GitHub Repository](https://github.com/Zelak312/icue_reinstall_helper/issues)
-   **Discord** : `zelak`
