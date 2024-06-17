# Zpm-Flathub Edition : 

Script de gestion de Flatpak avec dialog et sudo.

## Description

Ce script permet de gérer les applications Flatpak avec une interface semi-graphique utilisant `dialog`. Il offre les fonctionnalités suivantes :
- Installation d'applications Flatpak
- Mise à jour des applications Flatpak
- Désinstallation d'applications Flatpak

## Prérequis

- `dialog` doit être installé. Le script peut installer `dialog` automatiquement si nécessaire.
- Un gestionnaire de paquets compatible (`apt`, `dnf`, `zypper`, `rpm-ostree`).

## Utilisation

1. Clonez le dépôt ou téléchargez le script.
2. Rendez le script exécutable :
   ```bash
   chmod +x zpmtree.sh
   ```
3. Exécutez le script :
   ```bash
   ./zpmtree.sh
   ```

## Fonctionnalités

### Installation d'applications Flatpak

L'utilisateur peut choisir parmi une liste d'applications populaires ou entrer manuellement le nom de l'application à installer.

### Mise à jour des applications Flatpak

Le script met à jour toutes les applications Flatpak installées.

### Désinstallation d'applications Flatpak

L'utilisateur peut entrer le nom de l'application Flatpak à désinstaller.


<a href="http://www.wtfpl.net/"><img
       src="http://www.wtfpl.net/wp-content/uploads/2012/12/wtfpl-badge-4.png"
       width="80" height="15" alt="WTFPL" /></a>
