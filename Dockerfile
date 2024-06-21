FROM node:20-alpine as build

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app
COPY --chown=node:node package*.json ./
USER node
RUN npm install
COPY --chown=node:node . .
RUN npm run build

FROM node:20-alpine as production
LABEL authors="triserden"

RUN mkdir -p /home/node/app/node_modules && chown -R node:node /home/node/app
WORKDIR /home/node/app
USER node
COPY --from=build --chown=node:node /home/node/app/build/ build/
COPY --chown=node:node package*.json ./

ENTRYPOINT ["/usr/local/bin/npm", "run", "start"]