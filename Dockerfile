FROM ubuntu:16.04

RUN apt-get update && apt-get -y install \
  build-essential \
  git \
  libcurl4-openssl-dev \
  liblzma-dev \
  libmysqld-dev \
  libpq-dev \
  libsqlite3-dev \
  nodejs \
  postgresql-client-9.5 \
  rbenv \
  ruby-build \
  ruby-dev \
  tzdata \
  wget \
  zlib1g-dev

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \ 
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list \
  && apt-get update && apt-get install -y postgresql-client-9.6

ARG RUBY_VERSION=2.3.1
ENV PATH /root/.rbenv/shims:${PATH}
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build \
  && rbenv install ${RUBY_VERSION} \
  && rbenv global ${RUBY_VERSION}

ARG BUNDLER_VERSION=1.14.6
RUN gem install bundler -v ${BUNDLER_VERSION} && rbenv rehash

ARG NODE_VERSION=7.7.1
ENV NVM_DIR=/root/.nvm
ENV PATH /root/.nvm/versions/node/v${NODE_VERSION}/bin:${PATH}
RUN curl -s https://raw.githubusercontent.com/creationix/nvm/v0.32.1/install.sh | bash \
  && . /root/.nvm/nvm.sh \
  && nvm install ${NODE_VERSION} \
  && nvm alias default ${NODE_VERSION} \
  && nvm use default

WORKDIR /app
COPY conf/convox.rb /app/config/initializers/convox.rb
