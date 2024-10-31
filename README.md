# `plebnet` workshop

a workshop about sovereign mining with the [`bitaxe`](bitaxe.org).

- we deploy a custom signet (`plebnet`)
- we deploy a [block explorer](https://github.com/janoside/btc-rpc-explorer)
- each audience participant deploys their own node
- each audience participant deploys their own `stratum-server` (e.g.: `ckpool-solo`) and configures:
  - their payout address
  - their custom coinbase tag
- each audience participant deploys their own bitaxe
- we watch the blocks being mined by different audience participants

## slides

slides are built with [`marp`](https://marp.app/):
```shell
$ cd slides
$ marp md/plebnet-workshop.md -o html/plebnet-workshop.html --theme-set css/plebnet-workshop.css
```

slides can be served via python http server:
```shell
$ python3 -m http.server 1337
```

## scripts

- `env_genesis.sh`: provides shell variables and aliases for genesis deployment
- `plebnet_genesis.sh`: automates genesis deployment
- `env.sh`: provides shell variables and aliases for audience participants
- `bootstrap_bitcoind.sh`:
  - downloads bitcoin core
  - bootstraps `bitcoin_datadir` with `bitcoin.conf`
  - bootstraps `bitcoin_datadir` with a snapshot of a live `plebnet` (if available)

**note**: all scripts assume an ubuntu environment