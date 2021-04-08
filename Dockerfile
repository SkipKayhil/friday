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

ENV RAILS_ENV=production
CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0"]
EXPOSE 3000
