FROM ruby:3.2.1 as builder

RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash -
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get -y install yarn

COPY . /app
WORKDIR /app
ENV SECRET_KEY_BASE=hogehoge
RUN bundle && bundle exec rails assets:precompile

FROM ruby:3.2.1-slim

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app
RUN apt-get update && apt-get -y install libsqlite3-dev

WORKDIR /app
ENV RAILS_SERVE_STATIC_FILES=true
CMD ./bin/entrypoint.sh
