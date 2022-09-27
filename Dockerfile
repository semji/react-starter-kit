FROM node:lts-alpine3.16

RUN mkdir -p /usr/src/starter_kit

WORKDIR /usr/src/starter_kit


# Prevent the reinstallation of node modules at every changes in the source code
COPY package.json yarn.lock .pnp.cjs .yarnrc.yml ./
COPY ./.yarn  ./.yarn 

RUN yarn

COPY . ./

CMD yarn start
