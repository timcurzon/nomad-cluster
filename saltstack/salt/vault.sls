vault install:
  archive.extracted:
    - name: /usr/local/sbin
    - source: https://releases.hashicorp.com/vault/1.0.2/vault_1.0.2_linux_amd64.zip
    - source_hash: 5549714c24b61ea77a7afb30e1fbff6ec596cfd39dab7a2e6cf7e71432d616cc
    - source_hash_update: True
    - enforce_toplevel: False

vault after install:
  cmd.run:
    - name: chmod a+x /usr/local/sbin/vault
    - onchanges:
      - archive: vault install
  
vault environment variables:
 file.append:
    - name: /etc/environment
    - text: VAULT_ADDR=http://front.this.node.devcluster:8200
    - require:
      - archive: vault install
