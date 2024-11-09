#!/bin/bash

source env.sh

if [ ! -e "$STRATUM_SERVER_BIN" ]; then
  wget https://github.com/plebhash/plebnet-workshop/releases/download/plebnet-workshop/stratum-server.tar.gz
  tar xvf stratum-server.tar.gz
  rm stratum-server.tar.gz
else
  echo "Binary $STRATUM_SERVER_BIN already exists. Skipping clone and build."
fi