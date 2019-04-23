FROM ruby:2.6.2-alpine

RUN apk update && \
    apk add git && \
    gem install bundler && \
    rm -rf /var/cache/apk/*

RUN adduser -D app && \
    mkdir /app && \
    chown app: /app

USER app
WORKDIR /app
COPY ./ /app

RUN bundle install --without development --path vendor/
CMD ["bundle", "exec", "resolvme"]
