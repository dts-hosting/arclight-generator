#!/bin/bash

SITE=${1:-lyrasis}

bundle exec rake "site:copy[${SITE}]"
bundle exec rake "arclight:dev"
