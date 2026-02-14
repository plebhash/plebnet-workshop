#!/bin/bash

source env.sh

MUJINA_REPO="https://github.com/256foundation/mujina.git"
MUJINA_DIR="$PWD/mujina"

if [ ! -e "$MUJINA_BIN" ]; then
  echo "Installing build dependencies..."
  sudo apt-get update -qq
  sudo apt-get install -y build-essential libudev-dev libssl-dev pkg-config

  # Install Rust toolchain if not present
  if ! command -v cargo &> /dev/null; then
    echo "Installing Rust toolchain..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
  fi

  # Clone mujina if not already present
  if [ ! -d "$MUJINA_DIR/.git" ]; then
    echo "Cloning mujina..."
    git clone "$MUJINA_REPO" "$MUJINA_DIR"
  fi

  echo "Building mujina (this may take a few minutes)..."
  cd "$MUJINA_DIR"
  cargo build --release

  if [ ! -e "$MUJINA_BIN" ]; then
    echo "Build failed. $MUJINA_BIN not found."
    exit 1
  fi

  echo "mujina built successfully."
  cd ..
else
  echo "Binary $MUJINA_BIN already exists. Skipping build."
fi
