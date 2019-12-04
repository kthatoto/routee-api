FROM ruby:2.6.5-slim
ENV LANG C.UTF-8

RUN apt-get update -qq \
    && apt-get install -y \
      build-essential \
      wget \
      default-libmysqlclient-dev \
      default-mysql-client \
      graphviz \
      git

WORKDIR /tmp
COPY Gemfile* /tmp/
RUN bundle install --jobs=8 --without production

ENV APP_HOME /app
WORKDIR $APP_HOME
COPY . $APP_HOME
