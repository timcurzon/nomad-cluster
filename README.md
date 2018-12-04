# Nomad Dev Cluster

## What is it?

The Nomad dev cluster is a virtualised self-contained learning environment aimed at people who are interested in the Nomad container orchestration tool as well as the greater HashiCorp ecosystem (Consul & Vault are also included).

Further information on Nomad can be found in the [official introductory](https://www.nomadproject.io/intro/index.html) documentation.

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

At this point, 3 almost identical virtualbox machines will be created, each representing a single node in the cluster.

### Machine access

Each machine is named _node-[number]_ (where _[number]_ is 1-3), and can be accessed via:

- __SSH__ simply `vagrant ssh node-{1-3}`
- __IP Address__ `172.16.0.10{1-3}` (private, accessible only to the host machine)

The following service UIs are initially available:

- Nomad: `http://172.16.0.10{1-3}:4646`
- Consul: `http://172.16.0.10{1-3}:8500`
- Vault: `http://172.16.0.10{1-3}:8600`
- Fabio (proxy / edge router): `http://172.16.0.10{1-3}:9998`

Note that as we haven't set up any DNS for the cluster, all access is via direct IP address. DNS will be covered later.

### Setting up Vault

This step is optional, but is critical if you want to play around with setting up SSL/TLS secured services.

1) Once the cluster is up, access the Vault UI at `http://172.16.0.101:8200`, enter 1 for both the "Key Shares" and "Key Threshold" values (note these values are not acceptable in production environment) & click "Initialize"

2) Note down the Initial root token & Key 1 values & click "Continue to Unseal" - unseal Vault using the Key 1 value & log in using the initial root token [LOGIN TECHNICALLY NOT REQUIRED]

3) Now you have the root token, update the Vagrantfile (in the project root) - replace the placeholder string "[[insert root token value here]]" with the root token value

4) [...TODO something about reprovisioning / rebooting...]

### Local DNS

[...TODO...]

## Notes

### Networking

[...TODO...]

### Saltstack

[...TODO...]

## Links

- [Nomad](https://www.nomadproject.io/)
- [Consul](https://www.consul.io/)
- [Vault](https://www.vaultproject.io/)
