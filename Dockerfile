FROM ruby:2.6.5-alpine

RUN apk add --no-cache git && \
    gem install bundler

RUN adduser -D app && \
    mkdir /app && \
    chown app: /app

COPY --chown=app ./ /app
USER app
WORKDIR /app

RUN bundle install --without development --path vendor/
CMD ["bundle", "exec", "resolvme"]
