FROM ruby:2.4.2-stretch

MAINTAINER Robby Thompson <robsdudeson@gmail.com>

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs wait-for-it
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /app

EXPOSE 3000
