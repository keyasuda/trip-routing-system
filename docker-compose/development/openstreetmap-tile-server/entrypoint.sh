#!/bin/bash

service postgresql start

result=0
output=$(sudo -u postgres psql -d gis -c "select count(*) from geography_columns" 2>&1 > /dev/null) || result=$?
if [ ! "$result" = "0" ]; then
  echo "Generating tiles for OSM tile server..."
  /run.sh import
fi

echo "Starting OSM tile server service..."
/run.sh run &
sleep 5

render_list -a -n 16 -z 0 -Z 12 -m ajt
/bin/sh -c " while :; do sleep 10; done"
