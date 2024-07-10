#!/bin/bash

# Demande les informations nécessaires pour l'API GitHub
read -p "Entrer le nom de votre utilisateur Github: " GITHUB_USER
read -sp "Entrer votre token Github: " GITHUB_TOKEN
echo
read -p "Entrer le nom de votre nouveau repo: " REPO_NAME

# Demande les informations pour le projet local
read -p "Entrer le nom de votre projet: " NOM_PROJET
read -p "Entrer le répertoire pour votre projet: " REPERTOIRE
read -p "Voulez-vous ajouter une Technologie? (y/n): " add_technologie
if [ "$add_technologie" == "y" ]; then
    read -p "Entrer la technologie (par exemple, React): " TECHNOLOGIE
    read -p "Entrer la commande pour installer le projet (par exemple, 'npx create-react-app .'): " INSTALL_CMD
fi

# Créer un nouveau dépôt Git sur GitHub via l'API
response=$(curl -H "Authorization: token $GITHUB_TOKEN" \
                 -d "{\"name\": \"$REPO_NAME\", \"private\": false}" \
                 https://api.github.com/user/repos)

# Afficher la réponse de l'API
echo "Réponse de l'API GitHub: $response"

# Vérifier si le répertoire existe déjà
if [ ! -d "$REPERTOIRE" ]; then
    echo "Le répertoire $REPERTOIRE n'existe pas. Création du répertoire."
    mkdir -p "$REPERTOIRE"
fi

# Créer le répertoire du projet et se déplacer dedans
PROJECT_PATH="$REPERTOIRE/$NOM_PROJET"
mkdir -p "$PROJECT_PATH"
cd "$PROJECT_PATH"

# Exécuter la commande d'installation du projet si nécessaire
if [ "$add_technologie" == "y" ]; then
    echo "Installation du projet avec la technologie $TECHNOLOGIE"
    eval "$INSTALL_CMD"
fi

# Initialiser un dépôt Git local
git init

# Ajouter tous les fichiers au dépôt local
git add .

# Committer les fichiers
git commit -m "Initial commit"

# Ajouter le dépôt GitHub comme remote et pousser les commits
git remote add origin https://github.com/$GITHUB_USER/$REPO_NAME.git
git branch -M main
git push -u origin main

echo "Le projet a été initialisé localement et poussé vers GitHub avec succès!"
