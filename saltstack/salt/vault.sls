vault install:
  archive.extracted:
    - name: /usr/local/sbin
    - source: https://releases.hashicorp.com/vault/1.2.1/vault_1.2.1_linux_amd64.zip
    - source_hash: df14077600df745adf2450f9ea489cf6935352919b27b0367361379460e3b43e
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
