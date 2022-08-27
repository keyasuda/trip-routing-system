FROM ruby:3.1.2

RUN apt-get update \
  && apt-get -y install yarnpkg \
  && ln -s /usr/bin/yarnpkg /usr/bin/yarn

COPY . /app

WORKDIR /app
ENV SECRET_KEY_BASE=hogehoge
RUN bundle && bundle exec rails assets:precompile

ENV RAILS_SERVE_STATIC_FILES=true
CMD RAILS_ENV=production rails db:migrate && rm /app/tmp/pids/*; rails s -e production
