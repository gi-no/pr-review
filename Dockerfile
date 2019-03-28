FROM ruby:2.6.2

MAINTAINER barom1991

ENV LANG="C.UTF-8" \
    HOME="/pr_police" \
    DEBIAN_FRONTEND="noninteractive" \
    TZ="Asia/Tokyo"

WORKDIR $HOME

RUN set -x && \
    apt-get update && \
    apt-get install -y ruby-clockwork &&\
    gem install bundler -v 2.0.1

ADD Gemfile      $HOME/Gemfile
ADD Gemfile.lock $HOME/Gemfile.lock

RUN bundle install

ADD . $HOME

CMD ["bundle", "exec", "clockwork", "clock.rb"]
