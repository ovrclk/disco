## Dependencies

Install the below dependencies

- Terraform
- [k2sup](https://github.com/alexellis/k3sup)
- GNU Make

## Clone the project

```
$ git clone https://github.com/ovrclk/disco
```

## TeamOps

Throught the guide, we'll be using environment variables to simplify our workflow.

DISCO is optimized for Teams. Lets set those variables. For example, ets say we're building 
a `devnet` stack at team `akashnet`, will be:

```shell
export stack=devnet
export team=akashnet
```

```shell
keybase git create $stack --team $team
```

Example output:

```
$ keybase git create devnet --team akashnet

Repo created! You can clone it with:
  git clone keybase://team/akashnet/devnet
Or add it as a remote to an existing repo with:
  git remote add origin keybase://team/akashnet/devnet
```

### Setup up db repository in your working directory

```
git clone keybase://team/akashnet/devnet data
```

### Setup the directory structure:

```shell
make db-setup
```

The db setup task will create the below folder stucture:

```text
data
└── db
    ├── config
    │   ├── nodes
    │   └── providers
    ├── index
    └── keys
```

Define the machine and stack dns zones:

```shell
echo akashnet.net > data/db/index/STACK_ZONE
echo ovrclk1.com > data/db/index/MACHINE_ZONE
```
