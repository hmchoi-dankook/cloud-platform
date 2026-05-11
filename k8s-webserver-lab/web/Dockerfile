FROM node:20-alpine

WORKDIR /app

COPY package.json ./
RUN npm install --omit=dev

COPY server.js ./
COPY db.js ./
COPY redis.js ./
COPY views ./views
COPY public ./public

EXPOSE 8080

CMD ["npm", "start"]
