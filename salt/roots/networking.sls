# NOTE: Commented Jinja template markup {# #} should be changed to {{ }}

# Uncomment to configure the frontend (public) interface if required
#frontend-network:
#  network.managed:
#    - name: [dev-logical-name]
#    - enabled: True
#    - type: eth
#    - proto: none
#    - ipaddr: {# pillar['frontend IP address'] #}/21
#    - gateway: [gateway-ip]
#    # Uncomment if DNS resolution is failing via consul/dnsmasq
#    #- dns:
#    #    - [dns-ip-1]
#    #    - [dns-ip-n]

# Uncomment to configure the backend (private) interface if required
#backend-network:
#  network.managed:
#    - name: [dev-logical-name]
#    - enabled: True
#    - type: eth
#    - proto: none
#    - ipaddr: {# pillar['backend network cidr']|replace(".0/", '.' ~ pillar['cluster index'] ~ '/') #}

fan-networking:
  pkg.installed:
    - name: ubuntu-fan
  file.managed:
    - name: /etc/network/fan
    - source: /srv/salt/network/fan.jinja
    - template: jinja
    - user: root
    - group: root
    - mode: 644

# Uncomment once fan networking installed
#fan-network-refresh:
#  cmd.run:
#    - name: fanctl up -a
#    - unless: fanctl show | grep "fan-.*{# pillar['fan overlay cidr'] #}.*enable"
