#!/bin/bash
bundle exec rake db:drop
bundle exec rake db:create
psql -U ben -d shopofme_development -f current.sql --host localhost
