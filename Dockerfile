# `--platform=linux/x86_64` is necessary for bitbucket to run (eg. "standard_init_linux.go:228: exec user process caused: exec format error")
FROM --platform=linux/x86_64 ruby:3.1.6-bookworm

RUN gem update --no-document --system 3.3.27  # Match heroku: https://devcenter.heroku.com/articles/ruby-support#supported-runtimes
RUN gem install bundler --version 2.5.6   # Match heroku (indicated during Heroku deploy script)

WORKDIR /resource-locker
COPY Gemfile /resource-locker
COPY Gemfile.lock /resource-locker
RUN bundle install
