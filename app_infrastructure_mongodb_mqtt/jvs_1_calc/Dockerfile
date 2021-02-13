# STAGE: Development
FROM node:erbium-alpine AS dev

# Port to listen on
EXPOSE 8849

# Copy app and install packages
WORKDIR /app
COPY . /app/

RUN yarn

# Default app commands
CMD ["yarn", "start"]

# STAGE: Builder
FROM node:erbium-alpine AS builder
WORKDIR /app
COPY --from=dev /app /app
RUN yarn build

# STAGE: Prod Dependencies Builder
FROM node:erbium-alpine AS prod-dependencies
WORKDIR /app
COPY . /app
RUN npm install

# STAGE: Prod Deploy Ready Image
FROM node:erbium-alpine AS prod
WORKDIR /app
COPY --from=builder /app/dist /app/dist
COPY --from=prod-dependencies /app/node_modules /app/node_modules

CMD ["node", "dist/index.js"]
