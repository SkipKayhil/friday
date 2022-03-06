FROM node:lts-alpine AS base
WORKDIR /usr/src/friday

ENV PATH /usr/src/friday/node_modules/.bin:$PATH
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

WORKDIR /usr/src/friday/src

COPY . ./

FROM base as builder
RUN yarn build

FROM base as dev
CMD ["yarn", "dev", "--host", "0.0.0.0"]

FROM nginx:alpine
WORKDIR /app

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/src/friday/src/dist ./
