# TodoList

## Final tasks

- Finish docs
  - SaltStack section
  - Customisation section (cluster domain etc)
  - SSL service setup
- Test 2+ nodes (Vault config?)
- Vault Fabio config (add port 443)
- Specify Vagrantfile pillar values in external file somewhere (don't modify Vagrantfile)
  - 'cluster domain'
  - 'vault token'
- Build local containers? (Rename for local use)

* * *

## Notes

DNSMasq:
  * Basic DNS config (no-hosts, cache-size 0, no-resolv)
  * Upstream DNS (not really required)
  * Point general *dev (service) domain at frontend IP > Consul
  * 'this' local names (this, front.this, back.this)

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