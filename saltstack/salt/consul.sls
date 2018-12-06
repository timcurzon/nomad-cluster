consul install:
  archive.extracted:
    - name: /usr/local/sbin
    - source: https://releases.hashicorp.com/consul/1.3.0/consul_1.3.0_linux_amd64.zip
    - source_hash: a6896509b72fa229496b3adda51357c95d68a796ae3328d7d6a61195d6c68bac
    - source_hash_update: True
    - enforce_toplevel: False
    - if_missing: /usr/local/sbin/consul

# Deliberate if_missing means you have to manually remove consul from /usr/local/sbin
# before it will be updated. This prevents accidental update of all cluster servers at
# once which has a catastrophic effect on the consul journal.

consul after install:
  cmd.run:
    - name: chmod a+x /usr/local/sbin/consul
    - onchanges:
      - archive: consul install

consul environment variables:
 file.append:
    - name: /etc/environment
    - text: CONSUL_HTTP_ADDR=front.this.node.{{ pillar['cluster domain'] }}:8500
    - require:
      - archive: consul install

consul config:
  file.managed:
    - name: /etc/consul/consul.json
    - source: /srv/salt/consul/consul.json.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

consul node healthcheck scripts:
  file.copy:
   - name: /etc/consul/scripts
   - source: /srv/salt/consul/scripts
   - user: root
   - group: root
   - mode: 755
   - makedirs: True
   - subdir: True

consul node healthcheck:
  file.managed:
    - name: /etc/consul/node-healthchecks.json
    - source: /srv/salt/consul/node-healthchecks.json
    - user: root
    - group: root
    - mode: 644

consul startup script:
  file.managed:
    - name: /etc/systemd/system/consul.service
    - source: /srv/salt/consul/consul.service.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

consul group:
  group.present:
    - name: consul
    - system: True

consul user:
  user.present:
    - name: consul
    - groups:
      - consul
    - remove_groups: True
    - system: True
    - home: /var/consul
    - require:
      - group: consul group

consul home directory exists:
  file.directory:
    - name: /var/consul
    - user: consul
    - group: consul
    - dir_mode: 755
    - file_mode: 644
    - force: True
    - require:
      - user: consul user

consul service:
  service.running:
    - name: consul
    - enable: True
    - require:
      - file: consul home directory exists

consul systemd daemon reload:
  cmd.run:
    - name: systemctl daemon-reload
    - onchanges:
      - file: consul startup script

consul config reload:
  cmd.run:
    - name: systemctl reload consul
    - onchanges:
      - file: consul config
      - file: consul node healthcheck
      - file: consul node healthcheck scripts

consul restart:
  cmd.run:
    - name: systemctl restart consul
    - onchanges:
      - cmd: consul after install