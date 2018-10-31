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
      - no-resolv    # Don't repeatedly read /etc/resolv.conf
      - cache-size=0 # Number of domains to cache

dnsmasq config consul:
  file.managed:
    - name: /etc/dnsmasq.d/consul
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - contents: server=/cluster/{{ pillar['frontend IP address'] }}#8600

dnsmasq config this:
  file.managed:
    - name: /etc/dnsmasq.d/this
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - contents:
      - address=/this.node.cluster/{{ pillar['frontend IP address'] }}
      - address=/front.this.node.cluster/{{ pillar['frontend IP address'] }}
      - address=/back.this.node.cluster/{{ (pillar['backend network cidr']|replace('.0/', '.' ~ pillar['cluster index'] ~ '/')).split('/')[0] }}

dnsmasq service:
  service.running:
    - name: dnsmasq
    - enable: True
    - watch:
      - file: dnsmasq config basic
      - file: dnsmasq config consul
      - file: dnsmasq config this
