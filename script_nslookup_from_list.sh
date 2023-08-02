#!/bin/bash

# Vérifie si un argument (nom de fichier) est fourni
if [ $# -ne 1 ]; then
  echo "Usage: $0 <fichier_ip>"
  exit 1
fi

# Nom du fichier d'entrée contenant les adresses IP
fichier_ip=$1

# Nom du fichier de sortie pour enregistrer les résultats du nslookup
fichier_resultat="result.txt"

# Vérifie si le fichier d'entrée existe
if [ ! -f "$fichier_ip" ]; then
  echo "Erreur: Le fichier $fichier_ip n'existe pas."
  exit 1
fi

# Vérifie si le fichier de sortie existe, si oui, le supprime pour le recréer
if [ -f "$fichier_resultat" ]; then
  rm "$fichier_resultat"
fi

# Boucle pour parcourir chaque ligne du fichier d'entrée
while IFS= read -r ip; do
  # Effectue le nslookup pour l'adresse IP
  result=$(nslookup "$ip" 2>&1 | awk '/^Address: / {print $2}')

  # Vérifie si le nslookup a échoué
  if [ $? -eq 0 ]; then
    # Vérifie si l'adresse retournée commence par "213.166."
    # Changer l'ip  
    if [[ "$result" == 213.166.* ]]; then
      # Enregistre la réponse dans le fichier de sortie
      echo "IP: $ip - Adresse: $result" >> "$fichier_resultat"
    fi
  else
    # Enregistre l'erreur dans le fichier de sortie
    echo "Erreur pour l'adresse IP: $ip - Message d'erreur: $result" >> "$fichier_resultat"
  fi
done < "$fichier_ip"

echo "Le script a terminé avec succès. Les résultats ont été enregistrés dans $fichier_resultat."
