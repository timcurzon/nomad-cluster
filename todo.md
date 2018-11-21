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

1. Networking
  - Public frontend network ✘
  - 'Private' frontend network (172.16.0.0) ✔
  - 'Private' backend network (172.30.0.0) ✔
  - Test inter node connectivity over private network ✔
  - Fan networking setup ✔
2. DNSMasq setup
  - Basic config ✔
  - Service domain ✔
  - 'this' local names ✔
  - Remove /etc/resolv.conf ✔
  - Disable systemd-resolved ✔
  - Stop systemd-resolved ✔

## Tool installation

1. Docker ✔
2. Docker Compose ✔
3. Nomad
  - Binary install ✔
  - Config files ✔
  - systemctl client service ✔
  - systemctl server service ✔
  - Environment variables ✔
4. Consul
  - Binary install ✔
  - Config files ✔
  - systemctl service ✔
  - Healthchecks + scripts ✔
  - Environment variables ✔
  - Reload command fix ✔
5. System test
  - Consul ✔
  - Nomad ✔
6. General system setup
  - Add vagrant user to docker group (sudo usermod -aG docker vagrant) ✔
  - Build local containers? (At least rename for local use)
7. Create Test Service (Nginx static page) ✔
8. Fabio
  - Setup container (talks to Consul DNS)
9. Vault
  - Setup as container or local binary?
  - Re-enable in nomad server config

## Bugs

1. Nomad Docker services (nginxtest) using wrong IP address
  - Reason: any Nomad port mapping uses first host IP
  - Solution: set address_mode = "driver" & specify port number - applies to service (& check)