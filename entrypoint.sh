#!/bin/sh

j2 docker-compose.yml.j2 > docker-compose.yml

exec docker-compose $@
