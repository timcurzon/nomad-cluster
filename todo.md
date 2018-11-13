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
  - Config files ✔
  - systemctl service ✔
  - Healthchecks + scripts ✔
  - Reload command failing - investigate
    ```
    Error reloading: Put http://127.0.0.1:8500/v1/agent/reload: dial tcp 127.0.0.1:8500: connect: connection refused
    ```
    - Needs IP address of http server (bound to front IP currently)
    - Add 127.0.0.1 to consul.json `client_addr` definition (???) ... OR ...
    - Add `-http-addr=` option to the service reload command (convert service def to Jinja template) & set the `CONSUL_HTTP_ADDR` environment variable
5. Further DNSMasq config (prior to DNSMasq install)
  - Remove /etc/resolv.conf: `rm /etc/resolv.conf` ✔
  - Disable systemd-resolved: `systemctl disable systemd-resolved` ✔
  - Stop systemd-resolved: `systemctl stop systemd-resolved` ✔

6. Vault
  - Check reqs
  - Re-enable in nomad server config
7. System test
  - Consul + Vault
  - Nomad