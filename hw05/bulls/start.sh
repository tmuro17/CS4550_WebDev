#!/bin/bash

export SECRET_KEY_BASE=wKZUd0o8TC4VyQKNfKoZT22V98er6zs4jovP/waY5JofK8hIOm89id2eyzIygX8H
export MIX_ENV=prod
export PORT=4791

echo "Stopping old copy of app, if any..."

_build/prod/rel/bulls/bin/bulls stop || true

echo "Starting app..."

_build/prod/rel/bulls/bin/bulls start
