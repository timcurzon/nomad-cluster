download consul:
  archive.extracted:
    - name: /usr/local/sbin
    - source: https://releases.hashicorp.com/consul/1.3.0/consul_1.3.0_linux_amd64.zip
    - source_hash: a6896509b72fa229496b3adda51357c95d68a796ae3328d7d6a61195d6c68bac
    - source_hash_update: True
    - enforce_toplevel: False
    - if_missing: /usr/local/sbin/consul

post consul download:
  cmd.run:
    - name: chmod a+x /usr/local/sbin/consul
    - onchanges:
      - archive: download consul
  