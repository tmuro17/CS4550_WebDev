#!/bin/bash

export SECRET_KEY_BASE=wKZUd0o8TC4VyQKNfKoZT22V98er6zs4jovP/waY5JofK8hIOm89id2eyzIygX8H
export MIX_ENV=prod
export PORT=4791
export NODEBIN=`pwd`/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

echo "Building..."

mix deps.get
mix compile
(cd assets && npm install)
(cd assets && webpack --mode production)
mix phx.digest

echo "Generating release..."
mix release

#echo "Stopping old copy of app, if any..."
#_build/prod/rel/practice/bin/practice stop || true

echo "Starting app..."

PROD=t ./start.sh
