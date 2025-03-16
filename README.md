# ArcLight generator

Generates an ArcLight application and site configuration.

## Setup

```bash
nvm install # version in .nvmrc
nvm use

rbenv install -s # version in .ruby-version
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

## Creating site configuration

```bash
bundle exec rake "site:init[lyrasis]"
```

## Applying site configuration

```bash
bundle exec rake "site:push[lyrasis]"
```
