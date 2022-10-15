FROM ruby:3.1.2 as builder

RUN apt-get update && apt-get -y install yarnpkg
RUN ln -s /usr/bin/yarnpkg /usr/bin/yarn

COPY . /app
WORKDIR /app
ENV SECRET_KEY_BASE=hogehoge
RUN bundle && bundle exec rails assets:precompile

FROM ruby:3.1.2-slim

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app
RUN apt-get update && apt-get -y install libsqlite3-dev

WORKDIR /app
ENV RAILS_SERVE_STATIC_FILES=true
CMD ./bin/entrypoint.sh
