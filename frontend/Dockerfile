FROM node:lts-alpine AS builder
WORKDIR /usr/src

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . ./
RUN yarn build

CMD ["yarn", "dev"]

FROM nginx:alpine
WORKDIR /app

COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=frontend /usr/src/dist /
