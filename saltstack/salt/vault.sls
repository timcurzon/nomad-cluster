vault install:
  archive.extracted:
    - name: /usr/local/sbin
    - source: https://releases.hashicorp.com/vault/0.11.5/vault_0.11.5_linux_amd64.zip
    - source_hash: 5230377dd8c214b274261a1474ee484a43622cdfa162458311ef11bb8c31b5b8
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
