FROM node:lts-alpine AS base
RUN mkdir /opt/friday && chown node:node /opt/friday
WORKDIR /opt/friday

RUN npm -g i npm@latest

USER node

ENV PATH /opt/friday/node_modules/.bin:$PATH
COPY --chown=node:node package.json package-lock.json ./
RUN npm ci

WORKDIR /opt/friday/src

COPY --chown=node:node . ./

FROM base as builder
RUN npm run build

FROM base as dev
CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]

FROM nginx:alpine
WORKDIR /app

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /opt/friday/src/dist ./
