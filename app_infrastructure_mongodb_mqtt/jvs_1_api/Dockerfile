# STAGE: Development
FROM node:erbium-alpine AS dev

# Port to listen on
EXPOSE 8848

# Copy app and install packages
WORKDIR /app
COPY . /app/

RUN yarn

# Add docker-compose-wait tool -------------------
ENV WAIT_VERSION 2.7.2
ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.7.2/wait /wait
RUN chmod +x /wait

# Default app commands
CMD ["yarn", "start:dev"]

# STAGE: Builder
FROM node:erbium-alpine AS builder
WORKDIR /app
COPY --from=dev /app /app
RUN yarn build

# STAGE: Prod Dependencies Builder
FROM node:erbium-alpine AS prod-dependencies
WORKDIR /app
COPY ["package.json", "yarn.lock", "./"]
RUN yarn install --prod

# STAGE: Prod Deploy Ready Image
FROM node:erbium-alpine AS prod
EXPOSE 8848
WORKDIR /app
COPY public /app/public
COPY --from=builder /app/dist /app/dist
COPY --from=prod-dependencies /app/node_modules /app/node_modules
CMD ["node", "dist/index.js"]
