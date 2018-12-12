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

2) Now you have the root token, make a copy of the SaltStack overrides example file & name it `overrides.sls` (located at `saltstack/pillar/overrides.sls.example`). Replace the placeholder string "[[insert vault root token value here]]" with the root token value & trigger a Vagrant re-provision with
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

To resolve services residing on the cluster, some form of DNS will have to be setup. The simplest approach (at least on Linux) is to use DNSMasq. It is [simple to setup (Ubuntu 18.04)](https://askubuntu.com/questions/1032450/how-to-add-dnsmasq-and-keep-systemd-resolved-18-04). The following config should work well enough:

```
port=53
interface=lo
listen-address=127.0.0.1
bind-interfaces
server=[your upstream DNS server]
address=/devcluster/172.16.0.101
```

Remember to update the address setting if you change the cluster domain.

## Customisation

The SaltStack pillar file `saltstack/pillar/overrides.sls.example` contains explanations & examples of common configuration values you might want to override.

## Notes

### Networking

Networking is setup to approximately resemble a production environment, where a cluster node has 2 adapters - one public, and one private dedicated to inter-cluster communication.

Due to the virtualised environment requirements, networking implementation is slightly more involved. Each node has 3 network interfaces, with 1 is available outside the VM.

*Note that __{1-3}__ represents the cluster node number*

- __10.0.2.*x*__ Auto-provisioned by Vagrant, used for outbound network access via NAT
- __172.16.0.10{1-3}__ External & internal interface, used for accessing cluster services
- __172.16.30.{1-3}__ Internal node to node interface (dedicated to Nomad server & cluster service traffic - fan network bridge routes over this interface)

There are also two bridges:

- __172.31.{1-3}.*n*__ Fan networking - Docker assign on this range to containers. *n* is the per service IP (up to 254 services per cluster node)
- __172.17.0.1__ Default docker0 bridge (unused)

Service to service (container to container) addressing as achieved through fan networking - see [Fan Networking on Ubuntu](https://wiki.ubuntu.com/FanNetworking) for technical details. In summary though, it allows up to 254 uniquely addressable services per node, each routeable from any node in the cluster.

### SaltStack

SaltStack is a configuration management tool, a bit like Puppet or Ansible. It is triggered by Vagrant upon provisioning to configure each node (it has a built in SaltStack provisioner). To perform any degree of node customisation, the state & pillar files (configuration actions & key value data respectively) are where you'll likely begin.

SaltStack file overview:
- `saltstack/pillar` - configuration data
- `saltstack/salt` - configuration actions (services with a more complicated setup may have a directory of support files)

To give a very brief overview of operations - SaltStack starts with processing the `top.sls` state file which in turn references other state files that are run on the specified nodes, e.g. '*' means run on all nodes (note the node name is specified by Vagrant - see node.vm.hostname definition). State files are specified per service / common actions.

Please refer to the [docs](https://docs.saltstack.com/en/latest/) for further information.

## Links & References

- [Consul](https://www.consul.io/) ([docs](https://www.consul.io/docs/))
- [Fabio](https://fabiolb.net/)
- [Fan Networking (Ubuntu)](https://wiki.ubuntu.com/FanNetworking)
- [Nomad](https://www.nomadproject.io/) ([docs](https://www.nomadproject.io/docs/))
- [SaltStack](https://www.saltstack.com/) ([docs](https://docs.saltstack.com/en/latest/))
- [Vagrant](https://www.vagrantup.com/) ([docs](https://www.vagrantup.com/docs/))
- [Vault](https://www.vaultproject.io/) ([docs](https://www.vaultproject.io/docs/install/))
- [Virtualbox](https://www.virtualbox.org/) ([docs](https://www.virtualbox.org/manual/UserManual.html))

### Local DNS

- [DNSMasq setup in Ubuntu 18.04](https://askubuntu.com/questions/1032450/how-to-add-dnsmasq-and-keep-systemd-resolved-18-04)