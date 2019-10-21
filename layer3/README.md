## Akash Node Deploy

1. First, create a key for your node.

```sh
$ akash key create node
```

Since we'll be using our newly generated Key multiple times throughout the guide, lets export the public key address to an environment variable. Akash CLI provides shell friendly mode `-m, --mode` to do this easily.

```sh
$ eval $(akash key show node -m shell)
```

You can type `echo akash (tab)` do display all the akash variables in your session

2. Generate genesis file

```sh
$ akashd init $akash_display_key_0_public_key_address
```



Providers

1) Create Key
2) Register

```sh
$ akash provider create /config/provider.yml -k master -m shell
```

3) Run
```sh
$ akash provider create /config/provider.yml -k master -m shell
```
