download nomad:
  archive.extracted:
    - name: /usr/local/sbin
    - source: https://releases.hashicorp.com/nomad/0.8.6/nomad_0.8.6_linux_amd64.zip
    - source_hash: 7569561e4a8fdb283f36f9ff6ed7834be6b1f4a2149246f8bd3fb719265c800c
    - source_hash_update: True
    - enforce_toplevel: False
    - if_missing: /usr/local/sbin/nomad

post nomad download:
  cmd.run:
    - name: chmod a+x /usr/local/sbin/nomad
    - onchanges:
      - archive: download nomad
  