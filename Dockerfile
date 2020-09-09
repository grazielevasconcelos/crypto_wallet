FROM ruby:2.6.6-alpine AS dev

COPY .build-deps /

RUN cat .build-deps | xargs apk add

WORKDIR /crypto_wallet

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle

ENV PATH="${BUNDLE_BIN}:${PATH}"

#CI
FROM dev AS ci

COPY Gemfile Gemfile.lock ./

RUN bundle install --jobs 20 --retry 5

COPY . ./