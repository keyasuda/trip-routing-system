FROM ruby:3.1.0

RUN apt-get update \
  && apt-get -y install yarnpkg \
  && ln -s /usr/bin/yarnpkg /usr/bin/yarn

COPY . /app

WORKDIR /app
RUN bundle \
  && bundle exec rails assets:precompile \
  && RAILS_ENV=production rails db:migrate

ENV RAILS_SERVE_STATIC_FILES=true
CMD rails s -e production
