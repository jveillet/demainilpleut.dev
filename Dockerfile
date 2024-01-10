FROM ruby:3.3.0

# Environment variables
ENV DEBIAN_FRONTEND noninteractive
ENV NODE_MAJOR=20

# Added the new NodeSource installation method for NodeJS
RUN mkdir -p /etc/apt/keyrings
RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

# Yarn installation using debian repository
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -y \
    && apt-get install -y \
    apt-transport-https \
    libffi-dev \
    libssl-dev \
    libxml2-dev \
    libcurl4-gnutls-dev \
    nodejs \
    yarn \
    libnotify-dev \
    && rm -rf /var/lib/apt/lists/*

# RUN gem install bundler --no-document

RUN mkdir -p /app

WORKDIR /app

COPY .ruby-version ./
COPY Gemfile* ./

RUN bundle config
RUN bundle install --jobs 4 --retry 3

COPY package.json yarn.lock ./

# Install local Yarn dependencies
RUN yarn install

EXPOSE 4000
EXPOSE 4001
EXPOSE 4002

CMD ["bin/bridgetown", "start", "--host", "0.0.0.0"]
