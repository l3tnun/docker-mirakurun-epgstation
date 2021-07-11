#!/bin/sh

git clone https://github.com/l3tnun/docker-mirakurun-epgstation.git
cd docker-mirakurun-epgstation
cp docker-compose-sample.yml docker-compose.yml
cp epgstation/config/config.yml.template epgstation/config/config.yml
cp epgstation/config/operatorLogConfig.sample.yml epgstation/config/operatorLogConfig.yml
cp epgstation/config/epgUpdaterLogConfig.sample.yml epgstation/config/epgUpdaterLogConfig.yml
cp epgstation/config/serviceLogConfig.sample.yml epgstation/config/serviceLogConfig.yml
docker-compose run --rm -e SETUP=true mirakurun
