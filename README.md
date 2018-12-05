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

```bash
git clone [repoUrl]
```

Then move into the repo directory and start the cluster...

```bash
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

Note that as we haven't set up any DNS for the cluster, all access is direct via IP address. DNS will be covered later.

### Setting up Vault

This step is optional, but is critical if you want to play around with setting up SSL/TLS services.

1) Once the cluster is up, access the Vault UI at http://172.16.0.101:8200, enter 1 for both the "Key Shares" and "Key Threshold" values & click "Initialize" (note these values are *not* acceptable in production environment). Note down the "Initial root token" & "Key 1" values

2) Now you have the root token, update the Vagrantfile (located in the project root) - replace the placeholder string "[[insert root token value here]]" with the root token value & trigger a Vagrant re-provision with
    ```
    vagrant provision
    ```
    Once re-provisioning is complete, restart the cluster with
    ```
    vagrant reload
    ```

3) Finally, you need to unseal Vault - this is required every time the service is started up. Head back to the Vault UI at http://172.16.0.101:8200 and enter the Key 1 value. You can log in with the initial root token at this point if required.

### Initial cluster snapshot

Now you have a fully initialised cluster you may want to take a snapshot of each node for when you need to revert to a fresh state (see [Virtual box user manual](https://www.virtualbox.org/manual/UserManual.html), & the [snapshot section](https://www.virtualbox.org/manual/ch01.html#snapshots)).

### Local DNS

[...TODO...]

## Notes

### Networking

[...TODO...]

### Saltstack

[...TODO...]

## Links

- [Consul](https://www.consul.io/) ([docs](https://www.consul.io/docs/))
- [Fabio](https://fabiolb.net/)
- [Nomad](https://www.nomadproject.io/) ([docs](https://www.nomadproject.io/docs/))
- [SaltStack](https://www.saltstack.com/) ([docs](https://docs.saltstack.com/en/latest/))
- [Vagrant](https://www.vagrantup.com/) ([docs](https://www.vagrantup.com/docs/))
- [Vault](https://www.vaultproject.io/) ([docs](https://www.vaultproject.io/docs/install/))
- [Virtualbox](https://www.virtualbox.org/) ([docs](https://www.virtualbox.org/manual/UserManual.html))
