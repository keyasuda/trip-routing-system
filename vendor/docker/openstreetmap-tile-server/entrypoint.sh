#!/bin/bash

export THREADS=$(cat /proc/cpuinfo | grep processor | wc -l)

service postgresql start

result=0
output=$(sudo -u postgres psql -d gis -c "select count(*) from geography_columns" 2>&1 > /dev/null) || result=$?
if [ ! "$result" = "0" ]; then
  echo "Generating tiles for OSM tile server..."
  /run.sh import
fi

echo "Starting OSM tile server service..."
/run.sh run
