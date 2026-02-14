---
marp: true
theme: plebnet-workshop
---

![center w:500](../img/banner.png)

---

# goals

- intro to CPU mining with `mujina`
- become a sovereign node runner
- become a sovereign miner

---

![center w:500](../img/setup.png)

---

# prerequisites

- laptop with WiFi
- linux or macOS (x86-64 / arm64)
- familiarity with command line
- basic english
- wish to become a sovereign miner

---

# wifi

- SSID: `FIXME`
- password: `FIXME`

---

# slides

## `185.130.45.51:1337/html/plebnet-workshop.html`

---

# `plebnet`

this workshop uses a custom `signet` (`plebnet`) for the following reasons:

- we want a confined hashrate environment.
- `mainnet`, `testnet3`, `testnet4` and the public `signet` don't fill our needs.
- `regtest` is too isolated and requires manual block generation, which is not practical for a mining workshop.

`plebnet` is a custom signet that does not require coinbase signatures.

the genesis node can be found at `185.130.45.51`.

---

# multipass setup

we use [multipass](https://multipass.run/) to run an Ubuntu VM for a consistent environment.

**install multipass:**

- macOS: `brew install multipass`
- Ubuntu / Debian / Fedora: `sudo snap install multipass`
- Anything else: good luck 👍

---

# launch multipass VM

```shell
$ multipass launch --name plebnet --cpus 8 --memory 2G --disk 10G --bridged
$ multipass exec plebnet -- bash -c 'echo "nameserver 8.8.8.8" | sudo tee /etc/resolv.conf'
$ multipass shell plebnet
```

all subsequent steps should be run **inside this VM**.

---

# clone workshop repo

```shell
$ git clone https://github.com/plebhash/plebnet-workshop
$ cd plebnet-workshop
```

---

# bootstrap `bitcoind`

```shell
$ ./bootstrap_bitcoind.sh 
```

this script will:
- fetch and unpack a tarball from the official bitcoin core distribution pipeline
- create a `bitcoin_datadir` for `plebnet` (with a snapshot to accelerate IBD)

---

# add peers to `bitcoin.conf`

find your VM's **bridged** LAN IP (the one on the same subnet as the workshop WiFi):

```shell
$ ip -4 addr show enp0s2 | grep inet
```

- share this IP with other workshop participants
- add their IPs to the `addnode` fields of `bitcoin_datadir/bitcoin.conf`

```text
[signet]
server=1
rpcuser=user
rpcpassword=pass
# OP_TRUE
signetchallenge=51
addnode=185.130.45.51 # genesis node
# addnode=fixme
# addnode=fixme
# addnode=fixme
```

---

# connect to `plebnet`

**terminal 1:**

```shell
$ source env.sh
$ btcd
```

these commands will:
- load shell aliases
- start `bitcoind` and connect to `plebnet`

this terminal will stay busy running `bitcoind`.

---

# bootstrap `stratum-server` and `mujina`

**terminal 2** (open a new terminal — `multipass shell plebnet`):

```shell
$ cd plebnet-workshop
$ source env.sh
$ ./bootstrap_stratum_server.sh
$ ./bootstrap_mujina.sh
```

these scripts will clone and build from source:
- [`stratum-server`](https://github.com/plebhash/signet-stratum-server) (C)
- [`mujina`](https://github.com/256foundation/mujina) (Rust)

this may take a few minutes ☕

---

# create a wallet

```shell
$ btc createwallet mywallet
$ btc getnewaddress
```

these commands will:
- create a new wallet on your `bitcoin_datadir`
- get a new address — **copy it now, you'll need it next!**

---

# configure `stratum-server`

```shell
$ nano stratum-server/stratum-server.conf 
```

edit the following fields:
- `btcaddress`: paste the address you just copied (replace `your bitcoin address`)
- `btcsig`: write a custom coinbase tag for blocks you mine

---

# start `stratum-server`

**terminal 2** (same terminal used for wallet):

```shell
$ source env.sh
$ stratum-server
```

this will start the stratum server on port `3333`.

this terminal will stay busy running `stratum-server`.

---

# start mining

**terminal 3** (open yet another terminal — `multipass shell plebnet`):

```shell
$ cd plebnet-workshop
$ source env.sh
$ mujina
```

this will:
- connect to your local `stratum-server` via Stratum v1
- mine using the CPU (USB hardware discovery is disabled)
- use **4 threads** by default (configured in `env.sh`)

---

# tuning `mujina`

`mujina` is configured via environment variables (set in `env.sh`):

- `MUJINA_CPUMINER_THREADS` — CPU hashing threads (default: `4`)
- `MUJINA_CPUMINER_DUTY` — duty cycle %, 1-100 (default: `100`)

to change settings, stop `mujina`, then:
```shell
$ export MUJINA_CPUMINER_THREADS=8
$ mujina
```

more threads and more duty = more hashrate = faster shares. be mindful of your VM's core count.

---

# watch block explorer

# http://185.130.45.51:8080

# ☐☐☐ 👀

---

# industrial mining

# 👷
# 🏭🏭
# 📟📟📟
# ⚡⚡⚡⚡

---

# Q&A 

---

# thank you
