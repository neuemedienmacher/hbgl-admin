#!/bin/bash
# You should have a clean DB before this (rake db:drop db:create)

read -p 'Reset your previous database? [Y/n]' -n 1 -r
echo ''
if [[ $REPLY =~ ^[Yy]$ ]]
then
  rake db:drop db:create
  echo 'Done!'
fi

echo 'Downloading dump of production database...'
dumpfile="$(pwd)/tmp/latest.dump"
curl -o $dumpfile `heroku pg:backups public-url --app clarat`
echo 'Done!'

echo 'PG_RESTORE on development database...'
pg_restore --verbose --clean --no-acl --no-owner -h 127.0.0.1 -d clarat_development $dumpfile
echo 'Done!'

echo 'Cleaning up...'
rm $dumpfile
echo 'Done!'
