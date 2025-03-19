# ArcLight generator

Generates an ArcLight application and manages site configurations.

## Setup

Requires:

- nodejs / nvm
- ruby

```bash
nvm install # install version specified in .nvmrc
nvm use

rbenv install -s # install version specified in .ruby-version
bundle install
```

## Overview

There are two components to this repository:

1. A generic ArcLight application generator
2. Site configuration

## Generator configuration

The job of the application generator is to create a vanilla ArcLight
application without site specific configuration or customizations.
That's it. It's essentially a new Rails project with minimal gem
dependencies that provides the stable foundation for layering in
deployment specific files.

Configuration for generating the ArcLight application is in
`config/arclight.yml`:

```yml
repository: projectblacklight/arclight # github repository
version_type: ref # branch, tag etc.
version: 086061a3e6713d27207d18d929311c3e2e695abd # v1.4.0 etc

operations: [] # file processing
```

To create the application at `./arclight`:

```bash
./generate-arclight
```

### ArcLight database

The ArcLight application is generated using `sqlite` as the database.
However we aren't using any the user specific features (no `--devise`)
and therefore the database does **not** need to be persisted. We
don't go so far as to `--skip-active-record` because Blacklight
provides models that inherit from `ApplicationRecord`, so rather than
remove the database we're just going to ignore it.

## Site configuration

Per site files are required for:

- `repositories.yml`
- `locales.yml`
- `styles.css`

### Create new site configuration

To create an initial set of files:

```bash
bundle exec rake "site:init[lyrasis]"
```

This generates the required files under `./config/$site`.

## Copying individual site configuration

This copies site configuration files into the ArcLight application
for review and testing:

```bash
bundle exec rake "site:copy[lyrasis]"
```

- `repositories.yml` -> `./config/repositories.yml`
- `locales.yml` -> `./config/locales/en.yml`
- `styles.css` -> `./public/styles.css`

The dev server will now be set to use this site's configuration.

### Syncing all site configuration

Transfers all `./config/sites` to ArcLight root `./sites`:

```bash
bundle exec rake "site:sync"
```

This is used for production deployments. At container runtime a
specific site configuration will be copied into place, which
enables us to use a single Docker image for multiple deployments.

## Running ArcLight locally

```bash
bundle exec rake "arclight:dev"
```

This will start Solr and run the Rails dev server. ArcLight will be
running at: `http://localhost:3000`. If you encounter an error about
Solr not being available try again after a few seconds.

## Build and run the ArcLight Docker image

```bash
bundle exec rake "arclight:build"
bundle exec rake "arclight:qa"
```

## Deploy the ArcLight demo site

```bash
cd arclight

# verify connections to the server
bundle exec kamal server bootstrap

# verify access to docker registry
bundle exec kamal registry login

# run the deploy process
bundle exec kamal deploy

# run a command on the container
bundle exec kamal app exec "bin/rails about"

# connect to the container
bundle exec kamal app exec -i "bin/rails console"
```
