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

1. Networking part 1 ✔
  - 'Private' frontend network (172.16.0.0) ✔
  - 'Private' backend network (172.30.0.0) ✔
  - Fan networking ✔
2. DNSMasq setup ✔
3. Networking part 2 (...)
  - Setup VB Internal network type (backend, 1 iface per node) ✔
  - Setup VB Host only network type (frontend, 1 iface per node)
    - Clean out any existing VB host networks
    - `vb.customize ["modifyvm", :id, "--memory", "1024", "--cpus", "1", "--natnet1", "172.16.0/24"]`
  - Confirm fan network still working
  - Confirm host -> box access (Consul, Nomad, nginxtest service)

## Tool installation

1. Docker ✔
2. Docker Compose ✔
3. Nomad ✔
4. Consul ✔
5. System test ✔
6. General system setup (...)
  - Add vagrant user to docker group (sudo usermod -aG docker vagrant) ✔
  - Build local containers? (Rename for local use)
7. Create Test Services (...)
  - Nginx static page ✔
8. Fabio
  - Setup container (talks to Consul DNS)
9. Vault
  - Setup as container or local binary?
  - Re-enable in nomad server config

## Bugs

1. Nomad Docker services (nginxtest) using wrong IP address
  - Reason: any Nomad port mapping uses first host IP
  - Solution: set address_mode = "driver" & specify port number - applies to service (& check)