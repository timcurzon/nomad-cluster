# TodoList

## Salt

1. Create salt pillar for each node ✔
2. Test pillar data can be selected on masterless minion based on node name ✔

## System setup

DNSMasq notes:
  * Basic DNS config (no-hosts, cache-size 0, no-resolv)
  * Upstream DNS (not really required)
  * Point general *dev (service) domain at frontend IP > Consul
  * 'this' local names (this, front.this, back.this)

1. Networking ✔
  - Private frontend network (172.16.0.10x) ✔
  - Private backend internal network (172.30.0.0) ✔
  - Fan networking ✔
2. DNSMasq ✔

## Tool installation

1. Docker + Compose ✔
2. Nomad ✔
3. Consul ✔
4. System test ✔
5. General system setup (...)
  - Add vagrant user to docker group ✔
  - Build local containers? (Rename for local use)
6. Create initial test services ✔
7. Fabio ✔
8. Vault (...)
  - Setup as job ✔
  - Manual init (via README) ✔
  - Fabio config (add port 443)
9. Start jobs on node startup
  - Fabio ✔
  - Vault ✔
10. Customisable cluster domain (default: devcluster) ✔

## Setup / Customisation

- Specify Vagrantfile pillar values in external file somewhere (don't modify Vagrantfile)
  - 'cluster domain'
  - 'vault token'

* * *

## Issues

1. Nomad services (nginxtest) using wrong IP address ✔
  - Detail: any Nomad port mapping uses first host IP
  - Threads:
    - https://github.com/hashicorp/nomad/issues/646
    - https://github.com/hashicorp/nomad/issues/2469
  - Solution: update Nomad client config as follows:
      ```
      client {
        enabled = true
        network_interface = "[interface, e.g. enp0s3]"
      }
      ```
2. Vault setup ✔
  - Options:
    - Do manually (see README)
    - Run in dev mode (networking issues, will it cluster?)
  - Solution: configure manually & document in README