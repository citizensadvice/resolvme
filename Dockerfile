FROM ruby:2.6.2-alpine

RUN apk update && \
    apk add git && \
    rm -rf /var/cache/apk/*

RUN adduser -D app && \
    mkdir /app && \
    chown app: /app

USER app
WORKDIR /app
COPY ./ /app

RUN bundle install --without development
CMD ["bundle", "exec", "resolvme"]
