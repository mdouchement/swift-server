# ruby build stage
FROM ruby:2.7-alpine
MAINTAINER mdouchement

# Set the locale
ENV LANG c.UTF-8

# App
ENV GEM_HOME /usr/src/app/vendor/gems
ENV GEM_PATH /usr/src/app/vendor/gems
ENV RUBYOPT "--jit"

RUN apk upgrade
RUN apk add --update --no-cache git build-base

# Bundler 2.x.x
RUN gem install bundler

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN bundle config set deployment 'true'
RUN bundle config set without 'development test'

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN bundle install

ENV WEB_CONCURRENCY=3
EXPOSE 10101
CMD bundle exec unicorn -p 10101 -c config/unicorn.rb
