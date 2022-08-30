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
/run.sh run &
sleep 60

echo "prerender (0-9)"
render_list -a -n $THREADS -z 0 -Z 9

echo "prerender (10-19)"
if [ ! -e /data/tiles/render_list_geo.pl ]; then
  wget -O /data/tiles/render_list_geo.pl https://raw.githubusercontent.com/SomeoneElseOSM/render_list_geo.pl/master/render_list_geo.pl
  chmod u+x /data/tiles/render_list_geo.pl
fi
/data/tiles/render_list_geo.pl -n $THREADS -z 10 -Z 15 -x 117.817 -X 158.643 -y 19.849 -Y 51.069

echo "prerender finished"

/bin/sh -c " while :; do sleep 10; done"
