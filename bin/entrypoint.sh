#!/bin/bash

rails db:migrate
rm /app/tmp/pids/*
rails s &
tail -f log/production.log
