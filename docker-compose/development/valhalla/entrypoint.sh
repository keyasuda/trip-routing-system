#!/bin/bash

cd /data

if [[ ! -e config.json ]]; then
  echo "Generating tiles for Valhalla..."

  mkdir tiles
  valhalla_build_config --mjolnir-tile-dir ${PWD}/tiles --mjolnir-tile-extract ${PWD}/tiles.tar --mjolnir-timezone ${PWD}/tiles/timezones.sqlite --mjolnir-admin ${PWD}/tiles/admins.sqlite > config.json
  valhalla_build_tiles -c config.json /data.osm.pbf
  find tiles | sort -n | tar cf tiles.tar --no-recursion -T -
fi

echo "Starting Valhalla service..."
valhalla_service config.json 1
