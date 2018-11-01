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

## Tool installation

1. Docker ✔
2. Docker Compose ✔
3. Nomad
  - Binary install ✔
  - Config files ✔
  - systemctl client service ✔
  - systemctl server service ✔
4. Consul
  - Binary install ✔
  - Config files
  - systemctl service
  - Healthchecks
  - Scripts
5. Vault
  - Check reqs
  - Re-enable in nomad server config
6. System test
  - Consul + Vault
  - Nomad