#!/bin/bash

# Dossier de destination
DEST_DIR="playbooks/roles/nginx/files/errors"

# Crée le dossier s’il n’existe pas
mkdir -p "$DEST_DIR"

# Liste des codes d'erreur à couvrir
ERROR_CODES=(
  400 401 403 404 405 408
  413 414 429
  500 502 503 504
)

# Génération des pages HTML
for CODE in "${ERROR_CODES[@]}"; do
  FILE="$DEST_DIR/$CODE.html"
  echo "Creating $FILE"
  cat > "$FILE" <<EOF
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Erreur $CODE</title>
  <style>
    body {
      font-family: sans-serif;
      background-color: #f9f9f9;
      color: #333;
      text-align: center;
      padding-top: 100px;
    }
    h1 {
      font-size: 48px;
      margin-bottom: 10px;
    }
    p {
      font-size: 20px;
    }
  </style>
</head>
<body>
  <h1>Erreur $CODE</h1>
  <p>Une erreur est survenue. Veuillez réessayer plus tard.</p>
</body>
</html>
EOF
done

echo "Pages d’erreur générées dans $DEST_DIR"
