nomad install:
  archive.extracted:
    - name: /usr/local/sbin
    - source: https://releases.hashicorp.com/nomad/0.8.6/nomad_0.8.6_linux_amd64.zip
    - source_hash: 7569561e4a8fdb283f36f9ff6ed7834be6b1f4a2149246f8bd3fb719265c800c
    - source_hash_update: True
    - enforce_toplevel: False
    - if_missing: /usr/local/sbin/nomad

# Deliberate if_missing means you have to manually remove nomad from /usr/local/sbin
# before it will be updated. This prevents accidental update of all cluster servers at
# once which means all sorts of things go bang and lots of containers to try (and
# often fail) to restart. If Nomad has been updated then you need to drain the node,
# restart nomad manually via systemctl and then allow allocations back onto it.

nomad after install:
  cmd.run:
    - name: chmod a+x /usr/local/sbin/nomad
    - onchanges:
      - archive: nomad install
  
nomad directory exists:
  file.directory:
    - name: /var/nomad
    - user: root
    - group: root
    - mode: 755
    - file_mode: 644
    - force: True

nomad systemd daemon reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: nomad client startup script
{% if pillar['nomad server'] %}
      - file: nomad server startup script
{% endif %}

# Client config
nomad client config:
  file.managed:
    - name: /etc/nomad/client/client.json
    - source: /srv/salt/nomad/client.json.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

nomad client startup script:
  file.managed:
    - name: /etc/systemd/system/nomad-client.service
    - source: /srv/salt/nomad/nomad-client.service
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

nomad client service:
  service.running:
    - name: nomad-client
    - enable: True
    - require:
      - file: nomad directory exists

nomad client config reload:
  cmd.run:
    - name: systemctl reload nomad-client
    - onchanges:
      - file: nomad client config

nomad client restart:
  cmd.run:
    - name: systemctl restart nomad-client
    - onchanges:
      - cmd: nomad after install

# Server config
{% if pillar['nomad server'] %}
nomad server config:
  file.managed:
    - name: /etc/nomad/server/server.json
    - source: /srv/salt/nomad/server.json.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

nomad server startup script:
  file.managed:
    - name: /etc/systemd/system/nomad-server.service
    - source: /srv/salt/nomad/nomad-server.service
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

nomad server service:
  service.running:
    - name: nomad-server
    - enable: True
    - require:
      - file: nomad directory exists

nomad server config reload:
  cmd.run:
    - name: systemctl reload nomad-server
    - onchanges:
      - file: nomad server config

nomad server restart:
  cmd.run:
    - name: systemctl restart nomad-server
    - onchanges:
      - cmd: nomad after install
{% endif %}