# Nomad Dev Cluster

## What is it?

The Nomad dev cluster is a virtualised self-contained learning environment aimed at people who are interested in the Nomad container orchestration tool as well as the greater HashiCorp ecosystem (Consul & Vault are also included).

Further information on Nomad can be found in the [official introductory](https://www.nomadproject.io/intro/index.html) documentation.

## Index

- [Getting started](#getting-started)
  - [Requirements](#requirements)
  - [First time startup](#first-time-startup)
  - [Machine access](#machine-access)
  - [Basic services](#basic-services)
  - [Starting up Vault](#starting-up-vault)
  - [Initial cluster snapshot](#initial-cluster-snapshot)
  - [Local DNS](#local-dns)
- [Customisation](#customisation)
  - [Cluster name](#cluster-name)
- [Notes](#notes)
  - [Networking](#networking)
  - [Saltstack](#saltstack)
- [Further Exercises](#further-exercises)
- [Links & References](#links)

<a id="getting-started"></a>

## Getting started

<a id="requirements"></a>

### Requirements

Requirements are pretty basic. You'll need the following locally installed:

1) [Virtualbox](https://www.virtualbox.org/)
2) [Vagrant](https://www.vagrantup.com/)

Both are available for common OS's (Linux, macOS, Windows).

<a id="first-time-startup"></a>

### First time startup

Once you have the requirements installed, enure you've checke out the repo:

```bash
git clone https://github.com/timcurzon/nomad-cluster.git
```

Move into the repo directory and start up the cluster...

```bash
cd [repoDir]
vagrant up
```

At this point, 3 almost identical virtualbox machines will be created, each representing a single node in the cluster.

<a id="machine-access"></a>

### Machine access

Each machine is named _node-[number]_ (where _[number]_ is 1-3), and can be accessed via:

- __SSH__ simply `vagrant ssh node-{1-3}`
- __IP Address__ `172.16.0.10{1-3}` (private, accessible only on the host machine)

The following service UIs are initially available:

- Nomad: `http://172.16.0.10{1-3}:4646`
- Consul: `http://172.16.0.10{1-3}:8500`

Note that as we haven't set up any DNS for the cluster, all access is direct via IP address. DNS options are covered in the [local DNS](#local-dns) section.

<a id="basic-services"></a>

### Basic services

Now you have a running cluster, it's time to start up some services.

Firstly, __Fabio__, the cluster edge router. SSH into node-1, then...

```bash
nomad run /services/fabio.nomad
```

Check out the Fabio job status in the Nomad UI (3 instances should be running), then check the Fabio UI:

- Nomad job UI: `http://172.16.0.101:4646/ui/jobs/fabio`
- Fabio UI: `http://172.16.0.101:9998`

<a id="starting-up-vault"></a>

### Starting up Vault

This step is optional, but is critical if you want to play around with setting up SSL/TLS services.

*Note that the 3 Vault instances are provisioned by Nomad (in Docker containers). In addition the Vault binary is available on each cluster node (along with appropriate environement variables) to allow CLI interaction.*

To start up __Vault__, SSH into node-1, then...

```bash
nomad run /services/vault.nomad
```

Check the Vault job allocation status in the Nomad UI: `http://172.16.0.101:4646/ui/jobs/vault`. Once the job is running (all allocations successful)...

1) Initialise vault:
    - UI: Access the first Vault UI at http://172.16.0.101:8200, enter 1 for both the "Key Shares" and "Key Threshold" values & click "Initialize"
    - CLI: SSH into node-1 then `vault operator init -key-shares=1 -key-threshold=1`
    - Download or note down the "Initial root token" & "Key 1" values.

2) Now you have a root token, make a copy of the SaltStack overrides example file & name it `overrides.sls` (located at `saltstack/pillar/overrides.sls.example`). Replace the placeholder string "[[insert vault root token value here]]" with the root token value. On the host machine then trigger a Vagrant reload with provision (this allows Nomad to use Vault)...

    ```bash
    vagrant reload --provision
    ```

3) Finally, you need to unseal the Vault instance on each node. This is required every time the service is started up.
    - UI: Head back to the Vault UI on each node at:
      - http://172.16.0.101:8200
      - http://172.16.0.102:8200
      - http://172.16.0.103:8200
      - ..enter the Key 1 (base64) value. Log in with the initial root token on the master Vault node to access the full Vault UI (the one not displaying the standyby node message on the sign in page).
    - CLI: SSH into each cluster node in turn and run `vault operator unseal`, enter the unseal Key 1 as prompted

__DISCLAIMER: these values are *not* acceptable for a production environment, you should also refer to the [Vault production hardening docs](https://learn.hashicorp.com/vault/operations/production-hardening.html) to learn how to harden Vault appropriately.__

<a id="initial-cluster-snapshot"></a>

### Initial cluster snapshot

Now you have a fully initialised cluster you may want to take a snapshot of each node for when you need to revert to a fresh state (see [Virtual box user manual](https://www.virtualbox.org/manual/UserManual.html), & the [snapshot section](https://www.virtualbox.org/manual/ch01.html#snapshots)).

<a id="local-dns"></a>

### Local DNS

To resolve any services you create on the cluster, some form of (local) DNS will be needed. The simplest approach (at least on Linux) is to use DNSMasq. It is [simple to setup (Ubuntu 18.04)](https://askubuntu.com/questions/1032450/how-to-add-dnsmasq-and-keep-systemd-resolved-18-04). The following config should work well enough:

```
port=53
interface=lo
listen-address=127.0.0.1
bind-interfaces
server=[your upstream DNS server, e.g 8.8.8.8 for Google]

# Cluster domain
address=/.devcluster/172.16.0.101 # No wildcard round-robin DNS, route via node-1
#address=/.devcluster/172.16.0.102
#address=/.devcluster/172.16.0.103

# Per node cluster access
address=/.node-1.devcluster/172.16.0.101
address=/.node-2.devcluster/172.16.0.102
address=/.node-3.devcluster/172.16.0.103
```

Remember to update the address setting if you change the cluster domain.

<a id="customisation"></a>

## Customisation

The SaltStack pillar file `saltstack/pillar/overrides.sls.example` contains explanations & examples of common configuration values you might want to override. Make a copy of the example file, name it `overrides.sls` & edit accordingly to override default pillar values.

<a id="cluster-name"></a>

### Cluster name

This guide uses the default cluster name (which is "devcluster").

<a id="notes"></a>

## Notes

<a id="networking"></a>

### Networking

Networking is setup to approximately resemble a production environment, where a cluster node has 2 adapters - one public, and one private dedicated to intra-cluster communication.

Due to the virtualised environment requirements, the actual networking implementation is a little more complicated. Each node has 3 network interfaces, with 1 available outside the VM.

*Note that __{1-3}__ represents the cluster node number*

- __10.0.2.*x*__ Auto-provisioned by Vagrant, used for outbound network access via NAT
- __172.16.0.10{1-3}__ External (& internal) interface, for accessing cluster services from the outside
- __172.16.30.{1-3}__ Internal node to node interface, dedicated to Nomad server & cluster service traffic (the fan network bridge routes over this interface)

There are also two bridges:

- __172.31.{1-3}.*n*__ Fan networking - Docker assigns IPs on this range to containers 
  - Where __{1-3}__ is the cluster node number
  - __*n*__ is the per service IP (up to 254 services per cluster node)
- __172.17.0.1__ Default docker0 bridge (unused)

Service to service (container to container) addressing as achieved through fan networking - see [Fan Networking on Ubuntu](https://wiki.ubuntu.com/FanNetworking) for technical details. In summary, it allows up to 254 uniquely addressable services per node, each routeable from any node in the cluster.

<a id="saltstack"></a>

### SaltStack

SaltStack is a configuration management tool, a bit like Puppet or Ansible. It is triggered by Vagrant upon provisioning to configure each node (Vagrant has a built in SaltStack provisioner). To perform any non-trivial node customisation, the state & pillar files (configuration actions & key value data respectively) are where you'll likely begin (note the [customisation](#customisation) section above though).

SaltStack file overview:

- `saltstack/pillar` - configuration data
- `saltstack/salt` - configuration actions (services with a more complicated setup may have a directory of support files)

To give a very brief overview of operations - SaltStack starts with processing the `top.sls` state file which in turn references other state files that are run on the specified nodes, e.g. '*' means run on all nodes (note the node name is specified by Vagrant - see node.vm.hostname definition). The state files for the cluster are specified per service / common action.

Please refer to the [docs](https://docs.saltstack.com/en/latest/) for further information.

<a id="further-exercises"></a>

## Further Exercises

- [Setting up an HTTPS service with Vault & Fabio](docs/https-service.md)

<a id="links"></a>

## Links & References

- [Consul](https://www.consul.io/) ([docs](https://www.consul.io/docs/))
- [Fabio](https://fabiolb.net/)
- [Fan Networking (Ubuntu)](https://wiki.ubuntu.com/FanNetworking)
- [Nomad](https://www.nomadproject.io/) ([docs](https://www.nomadproject.io/docs/))
- [SaltStack](https://www.saltstack.com/) ([docs](https://docs.saltstack.com/en/latest/))
- [Vagrant](https://www.vagrantup.com/) ([docs](https://www.vagrantup.com/docs/))
- [Vault](https://www.vaultproject.io/) ([docs](https://www.vaultproject.io/docs/install/))
- [Virtualbox](https://www.virtualbox.org/) ([docs](https://www.virtualbox.org/manual/UserManual.html))

### Local DNS setup

- [DNSMasq setup in Ubuntu 18.04](https://askubuntu.com/questions/1032450/how-to-add-dnsmasq-and-keep-systemd-resolved-18-04)