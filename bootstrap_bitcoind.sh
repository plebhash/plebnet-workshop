#!/bin/bash

source env.sh

OS=$(uname -s)
ARCH=$(uname -m)

case "$OS-$ARCH" in
    Linux-x86_64)
        BITCOIN_TARBALL="bitcoin-${BITCOIN_VERSION}-x86_64-linux-gnu.tar.gz"
        ;;
    Linux-aarch64)
        BITCOIN_TARBALL="bitcoin-${BITCOIN_VERSION}-aarch64-linux-gnu.tar.gz"
        ;;
    Linux-riscv64)
        BITCOIN_TARBALL="bitcoin-${BITCOIN_VERSION}-riscv64-linux-gnu.tar.gz"
        ;;
    Darwin-x86_64)
        BITCOIN_TARBALL="bitcoin-${BITCOIN_VERSION}-x86_64-apple-darwin.tar.gz"
        ;;
    Darwin-arm64)
        BITCOIN_TARBALL="bitcoin-${BITCOIN_VERSION}-arm64-apple-darwin.tar.gz"
        ;;
    *)
        echo "Unsupported platform: $OS $ARCH"
        exit 1
        ;;
esac

BITCOIN_TARBALL_URL="https://bitcoincore.org/bin/bitcoin-core-${BITCOIN_VERSION}/${BITCOIN_TARBALL}"

# Check if the directory exists
if [ ! -d "$BITCOIN_UNPACKED" ]; then
    echo "Directory $BITCOIN_UNPACKED does not exist. Downloading tarball..."
    curl -fL -o "$BITCOIN_TARBALL" "$BITCOIN_TARBALL_URL"
    if [ $? -ne 0 ]; then
        echo "Download failed. Exiting."
        exit 1
    fi

    echo "Download successful. Unpacking tarball..."
    tar -xzf "$BITCOIN_TARBALL"
    if [ $? -ne 0 ]; then
        echo "Extraction failed. Exiting."
        exit 1
    fi

    echo "Removing tarball..."
    rm "$BITCOIN_TARBALL"

    echo "Bitcoin Core version $BITCOIN_VERSION has been downloaded and unpacked successfully."
else
    echo "Directory $BITCOIN_UNPACKED already exists. Skipping download and extraction."
fi

if [ -d "$BITCOIN_DATADIR" ]; then
  echo "We are about to erase the contents of $BITCOIN_DATADIR. Do you want to continue? (yes/no)"
  read -r user_input

  if [ "$user_input" != "yes" ]; then
    echo "User did not consent. Exiting."
    exit 1
  fi

  rm -rf $BITCOIN_DATADIR/*
fi

echo "Creating $BITCOIN_DATADIR"
mkdir -p $BITCOIN_DATADIR/signet

if [ -d "$PLEBNET_SNAPSHOT" ]; then
  cp -r plebnet_snapshot/{blocks,chainstate} $BITCOIN_DATADIR/signet
fi

cat << EOF > $BITCOIN_DATADIR/bitcoin.conf
[signet]
server=1
rpcuser=user
rpcpassword=pass
# OP_TRUE
signetchallenge=51
addnode=$PLEBNET_GENESIS_NODE_IP # genesis node
# addnode=fixme
# addnode=fixme
# addnode=fixme
EOF
