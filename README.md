# ArcLight generator

Generates ArcLight application and site configuration.

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
application. Configuration for generating the ArcLight application is
in `config/arclight.yml`:

```yml
repository: projectblacklight/arclight # github repository
version_type: ref # branch, tag etc.
version: 086061a3e6713d27207d18d929311c3e2e695abd # v1.4.0 etc
```

To create the application at `./arclight`:

```bash
./generate-arclight
```

## Creating site configuration

```bash
bundle exec rake "site:init[lyrasis]"
```

## Applying site configuration

```bash
bundle exec rake "site:push[lyrasis]"
```
