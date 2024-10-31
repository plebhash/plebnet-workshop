#!/bin/bash

source env_genesis.sh

# List of required packages for building Bitcoin Core
packages=(
  build-essential
  cmake
  pkg-config
  python3
  libsqlite3-dev
  libboost-dev
  libevent-dev
)

# Initialize an array to hold missing packages for building Bitcoin Core
missing_packages=()

# Check each package
for pkg in "${packages[@]}"; do
  if ! dpkg -s "$pkg" &> /dev/null; then
    missing_packages+=("$pkg")
  fi
done

# Install missing packages for building Bitcoin Core
if [ ${#missing_packages[@]} -ne 0 ]; then
  echo "The following packages are missing and will be installed: ${missing_packages[@]}"
  sudo apt-get update
  sudo apt-get install -y "${missing_packages[@]}"
else
  echo "All dependencies for building Bitcoin Core are already installed."
fi

if [ ! -e "$BITCOIND" ]; then
    echo "Binary $BITCOIND does not exist. Cloning and building..."

#    git clone https://github.com/plebhash/bitcoin -b plebnet $BITCOIN_DIR
    git clone https://github.com/bitcoin/bitcoin $BITCOIN_DIR
    pushd $BITCOIN_DIR
    cmake -B build -DCMAKE_CXX_FLAGS="-Os" -DENABLE_WALLET=ON

    CORES=$(nproc)
    cmake --build build -j"$CORES"

    popd

    echo "Bitcoin Core has been cloned and built successfully."
else
    echo "Binary $BITCOIND already exists. Skipping download and extraction."
fi

if lsof -i :38332 | grep -q LISTEN; then
  echo "Port 38332 is already being used, which means there's probably a bitcoind already running in signet mode."
  echo "We are about to kill ALL bitcoind processes in the system. Do you want to continue? (yes/no)"
  read -r user_input

  if [ "$user_input" != "yes" ]; then
    echo "User did not consent. Exiting."
    exit 1
  fi

  echo "Killing ALL bitcoind processes in the system."
  sudo pkill bitcoind
fi

if [ -d "$BITCOIN_DATADIR" ]; then
  echo "We are about to erase the contents of $BITCOIN_DATADIR. Do you want to continue? (yes/no)"
  read -r user_input

  if [ "$user_input" != "yes" ]; then
    echo "User did not consent. Exiting."
    exit 1
  fi

  rm -rf $BITCOIN_DATADIR/*
else
  echo "Creating $BITCOIN_DATADIR"
  mkdir $BITCOIN_DATADIR
fi

cat << EOF > $BITCOIN_DATADIR/bitcoin.conf
[signet]
prune=0
txindex=1
server=1
rpcallowip=0.0.0.0/0
rpcbind=0.0.0.0
rpcuser=user
rpcpassword=pass
# OP_TRUE
signetchallenge=51
EOF

echo "starting bitcoind in daemon mode..."
$BITCOIND -signet -datadir=$BITCOIN_DATADIR -fallbackfee=0.01 -daemon

sleep 1

# we need a wallet to grind the initial blocks
echo "creating a genesis wallet"
$BITCOIN_CLI -signet -datadir=$BITCOIN_DATADIR createwallet genesis

sleep 1

echo "mining some initial blocks"
for ((i=1; i<=16; i++))
do
  # we just use a random address to grind initial blocks
  # coins are not going to genesis wallet
  $SIGNET_MINER --cli="$BITCOIN_CLI -signet -datadir=$BITCOIN_DATADIR" generate --grind-cmd="$BITCOIN_UTIL grind" --address="tb1qmrv47upgrdd0f8rw62rwdtpd8r6qrn8kh7tj5f" --nbits=$NBITS
done

echo "signet genesis crated... running getblockchaininfo as the last step"
$BITCOIN_CLI -signet -datadir=$BITCOIN_DATADIR getblockchaininfo