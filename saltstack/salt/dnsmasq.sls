dnsmasq package:
  pkg.installed:
    - name: dnsmasq

dnsmasq config basic:
  file.managed:
    - name: /etc/dnsmasq.d/basics
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - contents:
      - no-hosts     # Don't read /etc/hosts
      - no-resolv    # Don't read /etc/resolv.conf
      - cache-size=0 # Number of domains to cache

dnsmasq config consul:
  file.managed:
    - name: /etc/dnsmasq.d/consul
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - contents: server=/{{ pillar['cluster domain'] }}/{{ pillar['frontend IP address'] }}#8600

dnsmasq upstream config:
 file.managed:
   - name: /etc/dnsmasq.d/upstream
   - user: root
   - group: root
   - mode: 644
   - makedirs: True
   - contents:
     - server=1.1.1.1

dnsmasq config this:
  file.managed:
    - name: /etc/dnsmasq.d/this
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - contents:
      - address=/this.node.{{ pillar['cluster domain'] }}/{{ pillar['frontend IP address'] }}
      - address=/front.this.node.{{ pillar['cluster domain'] }}/{{ pillar['frontend IP address'] }}
      - address=/back.this.node.{{ pillar['cluster domain'] }}/{{ (pillar['backend network cidr']|replace('.0/', '.' ~ pillar['cluster index'] ~ '/')).split('/')[0] }}

dnsmasq service:
  service.running:
    - name: dnsmasq
    - enable: True
    - watch:
      - file: dnsmasq config basic
      - file: dnsmasq config consul
      - file: dnsmasq upstream config
      - file: dnsmasq config this

dnsmasq disable systemd-resolved:
  service.dead:
    - name: systemd-resolved
    - enable: False
    - require:
      - service: dnsmasq service

dnsmasq remove resolvconf:
  file.absent:
    - name: /etc/resolv.conf
    - require:
      - service: dnsmasq service
