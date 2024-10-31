#!/bin/bash

source env.sh

#!/bin/bash

# List of required packages for building stratum-server
packages=(
  build-essential
  yasm
  autoconf
  automake
  libtool
  libzmq3-dev
  pkgconf
)

# Initialize an array to hold missing packages for building stratum-server
missing_packages=()

# Check each package
for pkg in "${packages[@]}"; do
  if ! dpkg -s "$pkg" &> /dev/null; then
    missing_packages+=("$pkg")
  fi
done

# Install missing packages for building stratum-server
if [ ${#missing_packages[@]} -ne 0 ]; then
  echo "The following packages are missing and will be installed: ${missing_packages[@]}"
  sudo apt-get update
  sudo apt-get install -y "${missing_packages[@]}"
else
  echo "All dependencies for building stratum-server are already installed."
fi

# clone and build stratum-server
if [ ! -e "$STRAUM_SERVER_BIN" ]; then
  git clone https://github.com/plebhash/stratum-server
  pushd $STRATUM_SERVER_DIR
  ./autogen.sh
  ./configure
  make
  popd
else
  echo "Binary $STRAUM_SERVER_BIN already exists. Skipping clone and build."
fi
