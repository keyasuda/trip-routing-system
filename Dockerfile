FROM golang:1.17 as go-builder
RUN git clone https://github.com/benbjohnson/litestream.git
WORKDIR  /go/litestream
RUN git checkout e6f7c6052d84b7265fd54d3a3ab33208948e126b
RUN go build -ldflags "-s -w -X 'main.Version=latest' -extldflags '-static'" -tags osusergo,netgo,sqlite_omit_load_extension -o /usr/local/bin/litestream ./cmd/litestream

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
COPY --from=go-builder /usr/local/bin/litestream /usr/local/bin/litestream
COPY --from=go-builder /go/litestream/LICENSE /LICENSE.litestream

RUN apt-get update && apt-get -y install libsqlite3-dev

WORKDIR /app
ENV RAILS_SERVE_STATIC_FILES=true
CMD ./bin/entrypoint.sh
