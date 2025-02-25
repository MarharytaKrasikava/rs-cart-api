FROM node:16-alpine AS base
WORKDIR /app

# Dependencies
COPY package*.json ./
RUN npm install
# && npm cache clean --force

# Build
WORKDIR /app
COPY . .
RUN npm run build

# Application
FROM base AS application
COPY --from=base /app/package*.json ./
RUN npm install --only=production
RUN npm install pm2 -g
COPY --from=base /app/dist ./dist

USER node
ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["node", "dist/main.js"]