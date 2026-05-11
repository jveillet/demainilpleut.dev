FROM ruby:4.0.3

# Environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV NODE_MAJOR=22

# Install NodeJS from NodeSource (LTS)
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_MAJOR}.x | bash -

RUN apt-get update -y \
  && apt-get install -y \
  apt-transport-https \
  libffi-dev \
  libssl-dev \
  libxml2-dev \
  libcurl4-gnutls-dev \
  nodejs \
  libnotify-dev \
  && rm -rf /var/lib/apt/lists/*

# Install Yarn globally
# RUN npm install --global yarn

RUN mkdir -p /app

WORKDIR /app

COPY .ruby-version ./
COPY Gemfile* ./

RUN bundle config && \
  bundle install --jobs 4 --retry 3

# COPY package.json yarn.lock ./
COPY package.json package-lock.json ./

# Install local npm dependencies
RUN npm install

EXPOSE 4000
EXPOSE 4001
EXPOSE 4002

CMD ["bin/bridgetown", "start", "--host", "0.0.0.0"]
