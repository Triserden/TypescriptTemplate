FROM debian:bookworm as deps

RUN mkdir -p /home/node/app
WORKDIR /home/node/app
RUN apt-get update
RUN apt install -y nodejs npm
RUN useradd -ms /bin/bash node

FROM deps as nodedeps
RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
COPY --chown=node:node package*.json ./
RUN chown -R 1000:1000 "/home/node/"
USER node
RUN npm install

FROM nodedeps as build
COPY --chown=node:node . .
RUN npm run build

FROM deps as dev
LABEL authors="triserden"

WORKDIR /home/node/app
USER node

ENTRYPOINT ["npm", "run", "dev"]

FROM deps as prod
LABEL authors="triserden"

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app
COPY --chown=node:node package*.json ./
RUN npm ci
USER node
COPY --from=build --chown=node:node /home/node/app/build/ build/

ENTRYPOINT ["npm", "run", "start"]