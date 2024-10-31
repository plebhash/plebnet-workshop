#!/bin/bash

# path where bitcoin repo will be cloned
BITCOIN_DIR="$PWD/bitcoin"

# path for compiled bitcoin core binaries
BITCOIND=$BITCOIN_DIR/build/src/bitcoind
BITCOIN_CLI=$BITCOIN_DIR/build/src/bitcoin-cli
BITCOIN_UTIL=$BITCOIN_DIR/build/src/bitcoin-util

# path for bitcoin datadir
BITCOIN_DATADIR=$PWD/bitcoin_datadir

# miner to grind genesis block
SIGNET_MINER=$BITCOIN_DIR/contrib/signet/miner

# difficulty target for genesis
NBITS="1d00ffff"

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
