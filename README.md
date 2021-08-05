# demainilpleut.dev

[![Build Status](https://github.com/jveillet/demainilpleut.dev/workflows/CI/badge.svg)](https://github.com/jveillet/demainilpleut.dev/actions)
[![Netlify Status](https://api.netlify.com/api/v1/badges/40732b0e-05bc-4aa8-ba99-6bf58f198219/deploy-status)](https://app.netlify.com/sites/demainilpleut/deploys)

Static HTML version of demainilpleut.dev using the static website generator
[Bridgetown](https://www.bridgetownrb.com).

## Table of Contents

- [Prerequisites](#prerequisites)
- [Install](#install)
- [Development](#development)
- [Commands](#commands)
- [Tests](#tests)
- [Contributing](#contributing)

## Prerequisites

- [Ruby](https://www.ruby-lang.org/en/downloads/)
  - `>= 2.5`
- [Bridgetown Gem](https://rubygems.org/gems/bridgetown)
  - `gem install bundler bridgetown -N`
- [Node](https://nodejs.org)
  - `>= 10.13`
- [Yarn](https://yarnpkg.com)

## Install

### Classic

```sh
cd demainilpleut.dev/
bundle install && yarn install
```

### Docker

```sh
cd demainilpleut.dev/
docker-compose build && docker-compose up
```

## Development

To start your site in development mode, run `yarn start` and navigate to [localhost:4000](https://localhost:4000/)!

The same applies to the Docker installation, run `docker-compose up` and the website is available at the same address.

### Commands

```sh
# running locally
yarn start

# build & deploy to production
yarn deploy

# load the site up within a Ruby console (IRB)
bundle exec bridgetown console
```

> Learn more: [Bridgetown CLI Documentation](https://www.bridgetownrb.com/docs/command-line-usage)

## Tests

Basic tests are performed on the structure of the site (broken links, alt attributes on images,..), by using the
[html-proofer](https://github.com/gjtorikian/html-proofer) Ruby Gem.

They are launched automatically with every Pull Requests, via [GitHub Actions](https://help.github.com/en/github/automating-your-workflow-with-github-actions) (see [cibuild.yml](https://github.com/jveillet/demainilpleut.dev/blob/latest/.github/workflows/cibuild.yml) file).

You can run them manually via command line:

```bash
./bin/cibuild.sh
```

Or with Docker:

```bash
docker-compose run --rm web bin/cibuild.sh
```

## Contributing

### To the code

This project only accepts Pull Requests that references an issue.

1. Fork it [http://github.com/jveillet/demainilpleut.dev/fork](http://github.com/jveillet/demainilpleut.dev/fork)
2. Clone the fork using `git clone` to your local development machine.
3. Create your feature branch `git checkout -b feature/issue-number`.
4. Run the specs and our linter `bin/cibuild`.
5. Commit your changes `git commit -am 'Add some feature'`.
6. Push to the branch `git push origin feature/issue-number`.
7. Create new Pull Request.

### To the articles

1. Fork it [http://github.com/jveillet/demainilpleut.dev/fork](http://github.com/jveillet/demainilpleut.dev/fork)
2. Clone the fork using `git clone` to your local development machine.
3. Create your feature branch for the new page `git checkout -b page/my-post-title`
4. Create a post in the `src/_posts`starting with the date it should be published (ex: '2021-01-01_my-post-title').
5. When you are ready, commit the page `git commit -am 'My post title'`.
6. Push to the branch `git push origin page/my-post-title`.
7. Create new Pull Request.
