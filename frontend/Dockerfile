FROM node:lts-alpine AS base
RUN mkdir /opt/friday && chown node:node /opt/friday
WORKDIR /opt/friday

USER node

ENV PATH /opt/friday/node_modules/.bin:$PATH
COPY --chown=node:node package.json yarn.lock ./
RUN yarn install --frozen-lockfile

WORKDIR /opt/friday/src

COPY --chown=node:node . ./

FROM base as builder
RUN yarn build

FROM base as dev
CMD ["yarn", "dev", "--host", "0.0.0.0"]

FROM nginx:alpine
WORKDIR /app

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /opt/friday/src/dist ./
