**Note: This project is a work in progress**

# disco

Decentralized Infrastructure for Serverless Computing Operations (DISCO) is a secure, scalable, standardized software stack for developing, delivering, and debugging decentralized networks.

Check out this [announcement](https://techcrunch.com/2017/11/21/overclock-labs-bets-on-kubernetes-to-help-companies-automate-their-cloud-infrastructure) post about DISCO.

## Motivation

A notable majority of blockchain nodes are deployed on three providers (Amazon, Google, and Microsoft) -- contrary to their values of decentralization. Over [60% of the Ethereum nodes run on Amazon](https://thenextweb-com.cdn.ampproject.org/c/s/thenextweb.com/hardfork/2019/09/23/ethereum-nodes-cloud-services-amazon-web-services-blockchain-hosted-decentralization/amp) alone.

Our priority at [Akash](https://akash.network) is to help the broader community retain core values without compromising convenience by offering them a platform that's far richer than the cloud providers.

## Layers and Components

- [Layer 0](layer0): Bare metal servers on Packet, provisioned using Terraform.
- [Layer 1](layer1): Kubernetes Cluster with Helm, and Container Storage Interfaces (CSI).
- [Layer 2](layer2): Observabilty (Prometheus and Graphana) and Key Management (Vault).
- [Layer 3](layer3): Akash Suite.
- [Layer 4](layer4): Applications.

- [Sanity Check](sanity): Cluster readiness checks for Akash.

## About the Author

In the past ten years, my focus has been designing, building and managing distributed systems that scale to millions of individuals across the globe. From designing Kaiser’s first cloud platform in 2010 (long before the term “cloud” was coined) to deploying planetary-scale infrastructure at various hyper-growth technology companies in silicon valley. 

I created the [Akash Network](https://akash.network) to help bring that expertise to the masses. Prior to Akash, I co-founded [AngelHack](http://angelhack.com), the world’s largest hackathon organization with over 100,000 developers across 50 cities worldwide and helped launch several developer companies including [Firebase](http://firebase.com) (acquired by Google).

I've been deeply involved with the cloud-native revolution from its nascency as an active open source contributor and have authored libraries adopted by widely adopted organizations such as Ubuntu, HashiCorp, and Kubernetes.


## Required Setup

### Keybase

Keybase offers an end-to-end and cloud storage system that lets us to share sensitive information (such as private keys) between your workstation and the network. Check out this guide (https://keybase.io/download) to set up keybase on your workstation. To confirm keybase is setup properly, run the below:

```shell
keybase id
```

The above should return a response similar to:

```
▶ INFO Identifying kn0tch
✔ public key fingerprint: F731 6454 2118 DB51 44A1 655C 3CF6 8C6B 14A1 03D5
🚀  Stellar GAIYPV7OIZST7WXCYVLYO3FBJPCHAXI3Y4S6FQ64KC7CWN4R2OQO6B5L (kn0tch*keybase.io)
✔ "gregosuri" on twitter: https://twitter.com/gregosuri/status/1179220421465518082 [cached ...
✔ "gosuri" on github: https://gist.github.com/9818622 [cached ...
✔ "gosuri" on hackernews: https://news.ycombinator.com/user?id=gosuri [cached ...
✔ admin of DNS zone gregosuri.com: found TXT entry keybase-site-verification=AAP3mKWHM8sATAPK....
```
