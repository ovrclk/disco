# DISCO (Decentralized Infrastructure for Sovereign Computing Operations)

This repo helps setup an Akash Provider on your infrastructure so that you can lease out your compute resources in return for Akash tokens.

## Getting Started

To get started you will need to have an Akash account on the network you want to connect your Provider to. You will also need to export your Akash private key with a strong password.

_Note:_ Your account should also have a small amount of tokens.

You will need to install [Ansible](https://docs.ansible.com/ansible/2.9/installation_guide/index.html).

The Akash Provider installation steps are as follows:

1. Manually create 3 virtual machines running any Linux distro and configure SSH access
2. Update the `inventory.yml` in this repo with your variables
3. Run `ansible-playbook -i inventory.yml playbook-kubespray.yml` to setup Kubernetes
4. Run `ansible-playbook -i inventory.yml playbook-akash.yml` to setup an Akash Provider

We will cover each of these 4 steps in more detail below.

### Step 1

We're going to create a 3 node Kubernetes cluster with 1 node being the control plane and 2 kube nodes that will run workloads.

We can expand the 2 kube nodes later on if we want to add more capacity.

In term of minimum hardware requirement:

- The 1 x control plane node needs a minimum of 1.5GB ram
- The 2 x kube nodes need a minimum of 1GB each

### Step 2

This is where we configure the required variables.

You'll notice in the `inventory.yml` that we have a section of variables that need to be changed.

```
    envname: CHANGEME                # Some cool environment name e.g. myenv
    net: mainnet                     # mainnet / testnet / edgenet
    region: CHANGEME                 # Used for namespacing e.g. myenv.us-east-1.mydomain.com
    provider_domain: CHANGEME        # A domain name you own e.g. mydomain.com
    akash_account_address: CHANGEME  # Your address from: akash keys show <key name> -a
    akash_key: |                     # Your Akash private key
      -----BEGIN TENDERMINT PRIVATE KEY-----
      CHANGEME
      -----END TENDERMINT PRIVATE KEY-----
```

The `envname`, `region` and `provider_domain` are all variables that you control.

The `akash_account_address` and `akash_key` need to be set to whatever you have created on the specified `net`.

On mainnet you can follow [these instructions](https://docs.akash.network/cli/wallet) to setup an account. You'll also need to [fund your account](https://docs.akash.network/using-akash-tokens/funding) with some tokens.

Once the account has been created you will need to [export your private key](https://docs.akash.network/cli/wallet#5.-exporting-your-private-keys) with a password.

Be sure to indent your private key under the `akash_key` yaml correctly as shown in the inventory.yml.

Also, add the IP addresses of your 3 virtual machines into the `hosts` section.

_Note:_ Step 4 requires you input the password you entered when exporting your private key.

!IMPORTANT! Don't store your private key or password anywhere public.

### Step 3

Now we use Kubespray to install our cluster.

Clone the Kubespray repo into the root of this repo with `git clone https://github.com/kubernetes-sigs/kubespray.git`

Then run `ansible-playbook -i inventory.yml playbook-kubespray.yml`

This will take approximately 20 minutes to run depending on the speed of your infrastructure.

When complete you will have a running Kubernetes cluster.

### Step 4

Finally, to install the Akash provider on our Kubernetes cluster run:

`ansible-playbook -i inventory.yml playbook-akash.yml`

This command will prompt for your Akash private key password.

_Note:_ This is the password that you entered when exporting your private key as mentioned in Step 2.

When complete you will now have a running Akash Provider.
