#!/bin/bash
source dump_prod_db.sh
bundle exec rake db:drop
bundle exec rake db:create
psql -U ben -d shopofme_development -f current.sql --host localhost
