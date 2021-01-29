# STAGE: Development
FROM node:erbium-alpine AS dev

# Port to listen on
EXPOSE 8849

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