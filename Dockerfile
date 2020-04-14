FROM ruby:2.6.5-alpine

RUN apk add --no-cache git

RUN adduser -D app && \
    mkdir /app && \
    chown app: /app

COPY --chown=app ./ /app
USER app
WORKDIR /app

RUN gem install bundler --no-doc && bundle install --without development test
CMD ["bundle", "exec", "resolvme"]
