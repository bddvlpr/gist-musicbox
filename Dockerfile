FROM node:16 AS build-env
WORKDIR /worker

COPY package.json .
COPY yarn.lock ./
COPY tsconfig.json ./
RUN yarn install

COPY . .
RUN yarn build

FROM node:16 AS runtime-env
WORKDIR /worker

COPY --from=build-env /worker/dist/ .
COPY --from=build-env /worker/node_modules ./node_modules

LABEL org.opencontainers.image.source https://github.com/bddvlpr/gist-musicbox
CMD ["node", "index.js"]