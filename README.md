# Nomad Dev Cluster

## What is it?

The Nomad dev cluster is a virtualised self-contained learning environment aimed at people who are interested in the Nomad container orchestration tool as well as the greater HashiCorp ecosystem (Consul & Vault are also included).

Further information on Nomad can be found in the [official introductory](https://www.nomadproject.io/intro/index.html) documentation.

* * *

## Getting started

### Requirements

Requirements are pretty basic. You'll need the following locally installed:

1) [Virtualbox](https://www.virtualbox.org/)
2) [Vagrant](https://www.vagrantup.com/)

Both are available for common OS's (Linux, macOS, Windows).

### First time startup

Once you have the requirements installed, check out this repo:

```
git clone [repoUrl]
```

Then move into the repo directory and start the cluster...

```
cd [repoDir]
vagrant up
```

At this point, 3 virtualbox machines will be created. Each is configured in an identical manner, representing a single node in the cluster. 

### Machine access

Each machine is named _node-[number]_ (where _[number]_ is 1-3), and can be accessed via:

- __SSH__ simply `vagrant ssh node-{1-3}`
- __IP Address__ `192.168.1.10{1-3}` (private, scoped to the local machine)

The following services are initially available:

- Nomad: `192.168.1.10{1-3}:4646`
- Consul: `192.168.1.10{1-3}:8500`
- Vault: `192.168.1.10{1-3}:8600`
- Fabio (proxy / edge router): `192.168.1.10{1-3}:80`

Note that as we haven't set up any DNS for the cluster, all access is via direct IP address. DNS will be covered later.

### Setting up Vault

[...TODO...]

### Local DNS

[...TODO...]

* * *

## Notes

### Networking

[...TODO...]

### Saltstack

[...TODO...]

* * *

## Links

- [Nomad](https://www.nomadproject.io/)
- [Consul](https://www.consul.io/)
- [Vault](https://www.vaultproject.io/)