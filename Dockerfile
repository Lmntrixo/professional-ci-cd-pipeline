# ==========================================
# ÉTAPE 1 : Le Build et les Dépendances
# ==========================================
FROM node:22-alpine AS builder

WORKDIR /usr/src/app

# Copie des fichiers de configuration pour exploiter le cache des layers Docker
COPY package*.json ./

# Installation propre pour la production (ignore les devDependencies)
RUN npm install --only=production

# Copie du reste du code source
COPY server.js .

# ==========================================
# ÉTAPE 2 : L'image finale de Production (Ultra-légère et Sécurisée)
# ==========================================
FROM node:22-alpine

#updating package in final image
RUN apk update && apk upgrade --no-cache
# Marché Allemand / Sécurité : On n'exécute JAMAIS un conteneur en tant que 'root'
USER node

WORKDIR /usr/src/app

# Récupération uniquement des fichiers nécessaires depuis l'étape 'builder'
COPY --chown=node:node --from=builder /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=builder /usr/src/app/server.js ./server.js
COPY --chown=node:node --from=builder /usr/src/app/package.json ./package.json

EXPOSE 3000

ENV NODE_ENV=production

# Utilisation de CMD au format tableau pour éviter de lancer un sous-processus shell inutile
CMD ["node", "server.js"]

