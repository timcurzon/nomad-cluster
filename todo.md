# TodoList

## Final tasks

- Move Vagrantfile pillar values to external file ✔
- Finish documentation (..)
  - SaltStack section ✔
  - Customisation section (cluster domain etc) ✔
  - SSL service setup (test service, vault binary, users, setup)
- Test 2+ nodes (Vault config?) ✔
- Vault Fabio config (add port 443)
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
2. Nomad (HTTP) UI binding to both frontend & backend addresses (172.{16/30}.0.x)
  - Desired: UI should be bound to frontend address only (172.16.0.x)