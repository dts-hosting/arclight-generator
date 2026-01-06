# ArcLight generator

Generates an [ArcLight](https://github.com/projectblacklight/arclight) application and manages site configurations.

## Setup

Requires:

- nodejs / nvm
- ruby

```bash
nvm install # install version specified in .nvmrc
nvm use
npm install -g yarn

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
- `downloads.yml`
- `index.html.erb`
- `locales.yml`
- `styles.css`

Optional:

- `logo.png`

### Create new site configuration

The instructions below deploy the default ArcLight site for Lyrasis. To deploy a new site, edit: `[lyrasis]` -> `[yoursitename]`

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
- `downloads.yml` -> `./config/downloads.yml`
- `index.html.erb` -> `./app/views/static/index.html.erb`
- `locales.yml` -> `./config/locales/en.yml`
- `styles.css` -> `./public/styles.css`

The dev server will now be set to use this site's configuration.

Note that when creating a new site, these files will be empty and must be configured for the site to come online. Refer to the [default configuration files](https://github.com/dts-hosting/arclight-generator/tree/main/config/sites/lyrasis) for an example.

## Running ArcLight locally

```bash
bundle exec rake "arclight:dev"
```

This will start Solr and run the Rails dev server. ArcLight will be
running at: `http://localhost:3000`. If you encounter an error about
Solr not being available try again after a few seconds.

## Reset the solr index

```bash
bundle exec rake "arclight:reset"
```

## Syncing all site configuration

Transfers all `./config/sites` to ArcLight root `./sites`:

```bash
bundle exec rake "site:sync"
```

This is used for production deployments. At container runtime a
specific site configuration will be copied into place, which
enables us to use a single Docker image for multiple deployments.

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

## Pushing Solr configs

In some cases (like when **not** using Docker for Solr) you may
want to push the Solr configuration to a readily accessible
location like AWS S3:

```bash
export AWS_PROFILE=profile
export BUCKET=bucket
export SOLR_VERSION=8.11.3

cd arclight/solr/conf

aws s3 sync . s3://${BUCKET}/solr/${SOLR_VERSION}/arclight/conf \
  --exclude "*" \
  --include "*.json" \
  --include "*.txt" \
  --include "*.xml" \
  --dryrun
```

Remove `--dryrun` to actually perform the upload.

This can be used, for example, with Solr standalone on an EC2 server:

```bash
# ssh solr.lib.somewhere.edu
export BUCKET=bucket
export SOLR_VERSION=8.11.3

sudo -u solr aws s3 sync s3://${BUCKET}/solr/${SOLR_VERSION} /opt/solr/server/solr/configsets/ --dryrun
# repeat without --dryrun if all looks ok

# create a core
sudo -u solr /opt/solr/bin/solr create -c demo -d arclight
```

## Indexing

```bash
REPOSITORY_FILE=config/sites/lyrasis/repositories.yml \
bundle exec traject -u http://127.0.0.1:8983/solr/arclight \
    -i xml \
    -s repository=lyrasis-special-collections \
    -s id=123456 \
    -c traject/ead2_config.rb \
    files/eads/ead.xml
```

Where:

- REPOSITORY_FILE provides the path to a `repositories.yml` config
- `-i` indicates an xml input file
- `-s repository=$repository` must be a repository id within `repositories.yml`
- `-s id=$id` sets the id to use for this file's content
- `-c traject/ead2_config.rb` is the primary traject config file
- `files/eads/ead.xml` is the path to an EAD xml file

The included traject config differs from upstream in this regard:

- Settings, commented: `# provide "repository", ENV.fetch("REPOSITORY_ID", nil)`
- Within `to_field "id"`:
  - Commented: `# id = record.at_xpath("/ead/eadheader/eadid")&.text`
  - Added: `id = settings["id"]`

This has the consequence of losing out on traject's capacity to index
directories of files, however it fully decouples the document id from
data within records. Given consortial use cases where it's impossible
to rely on fully unique and correctly formatted ead identifiers (eadid)
this provides full control over how the document is identified making
it much easier to support global uniqueness across repositories.

When indexing EAD harvested from OAI-PMH endpoints a stable id can be
generated from a hash of the oai url and oai identifier of a record.
When the datestamp is updated simply re-index by re-running traject
with the same parameters.
