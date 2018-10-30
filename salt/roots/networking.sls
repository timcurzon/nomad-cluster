# NOTE: Commented Jinja template markup {# #} should also be uncommented

# Uncomment to configure the frontend (public) interface if required
# Currently this is configured via Vagrant...
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
# Currently this is configured via Vagrant...
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

fan-network-refresh:
  cmd.run:
    - name: fanctl up -a
    - unless: fanctl show | grep "fan-.*{# pillar['fan overlay cidr'] #}.*enable"
