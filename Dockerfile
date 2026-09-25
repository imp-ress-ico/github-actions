FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --omit=dev || true
COPY . .
EXPOSE 3000
USER node          # node:alpine ships a built-in non-root "node" user
CMD ["node", "src/index.js"]
