#!/bin/bash

# version for bitcoin core tarball
BITCOIN_VERSION=28.0

# path for bitcoin datadir
BITCOIN_DATADIR=$PWD/bitcoin_datadir

# path for bitcoin core binaries
BITCOIN_UNPACKED=$PWD/bitcoin-$BITCOIN_VERSION
BITCOIND=$BITCOIN_UNPACKED/bin/bitcoind
BITCOIN_CLI=$BITCOIN_UNPACKED/bin/bitcoin-cli

# path for potential plebnet snapshot
PLEBNET_SNAPSHOT=$PWD/plebnet_snapshot

# IP of plebnet genesis node
PLEBNET_GENESIS_NODE_IP=185.130.45.51

# paths for stratum-server
STRATUM_SERVER_DIR=$PWD/stratum-server
STRATUM_SERVER_CONF=$STRATUM_SERVER_DIR/stratum-server.conf
STRATUM_SERVER_BIN=$STRATUM_SERVER_DIR/src/ckpool

# alias to conveniently start bitcoind
alias btcd="$BITCOIND -signet -datadir=$BITCOIN_DATADIR -fallbackfee=0.01"

# alias to conveniently call bitcoin-cli
alias btc="$BITCOIN_CLI -signet -datadir=$BITCOIN_DATADIR"

# alias to conveniently start stratum-server
alias stratum-server="$STRATUM_SERVER_BIN -c $STRATUM_SERVER_CONF"

# mujina CPU miner
MUJINA_BIN=$PWD/mujina/target/release/mujina-minerd
export MUJINA_USB_DISABLE=1
export MUJINA_CPUMINER_THREADS=4
export MUJINA_CPUMINER_DUTY=100
export MUJINA_POOL_URL="stratum+tcp://localhost:3333"
export MUJINA_POOL_USER="worker1"

# alias to conveniently start mujina
alias mujina="$MUJINA_BIN"
