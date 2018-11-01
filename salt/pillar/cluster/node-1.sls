# Used to generate various IP addresses
cluster index: 1

# [UNUSED] Frontend IP address. Rather than relying on DHCP, the address
# is static to provide a more consistent behaviour during 'apply' because
# there is less relience on grain data
#frontend IP address: 192.168.1.51
frontend IP address: 172.16.0.1

# Meta labels to set on the Nomad client
nomad meta:
#  labelname: labelvalue

# Control whether a node is a nomad server node
nomad server: True

# Control whether a node is a consul server node
consul server: True
