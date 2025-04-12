FROM node:slim
WORKDIR /app
COPY . .
RUN npm ci
ENV NEW_RELIC_NO_CONFIG_FILE=true
CMD ["npm", "start"]