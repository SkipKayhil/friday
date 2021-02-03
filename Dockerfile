FROM node:lts-alpine AS frontend
WORKDIR /usr/src

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY vite.config.js postcss.config.js tailwind.config.js ./
COPY app app/
RUN yarn build

CMD ["yarn", "dev"]

FROM ruby:3.0-alpine
WORKDIR /usr/src

RUN apk add --no-cache --update \
  build-base \
  linux-headers \
  git \
  postgresql-dev \
  tzdata

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . ./

COPY --from=frontend /usr/src/public public/

ENV RAILS_ENV=production
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
EXPOSE 3000
