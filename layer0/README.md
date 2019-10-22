# Layer 0

Core Infrastructure scripts for managing physical machines. This module includes terraform and related scripts.

## Commands

### Usage:

```shell
make layer0-<action>-[stack]
```

Examples:

 - initiallize default stack packet:
    ```shell
    make layer0-init # will 
    ```
- initiallize default akash testnet stack
    ```shell
    make layer0-init.akash-test 
    ```

### Available Commands

```shell
make layer0-init
make layer0-plan
make layer0-apply
make layer0-destroy
```

## Provision Resources

### 1. Setup Credentials

```
# packet
echo $PACKET_TOKEN > data/db/keys/packet.api.token
echo $PACKET_PROJECT_ID > data/db/keys/packet.project.id

## cloudflare
echo $CLOUDFLARE_API_TOKEN > data/db/keys/cloudflare.api.token
```

### 2.Provision Machines

```
make layer0-init.packet
make layer0-apply.packet
```
