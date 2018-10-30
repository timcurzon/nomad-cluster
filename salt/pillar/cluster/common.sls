# Static backend network. Used for the fan networking. Nodes are allocated an 
# ip by replacing the classD value with the nodes's cluster id. E.g. 172.16.0.3
backend network cidr: 172.16.0.0/29

# The class B network ubuntu-fan uses to create the overlay network for docker
# containers. The class D value from the backend network are mapped up to class
# C values and the server is allocated a class D value of 1.
#
# Taking the example from above, the server's overlay fan network ip will be 
# 172.17.3.1 (CIDR 172.17.3.0/24)
fan overlay cidr: 172.17.0.0/16

# The symetric encryption key used for cosul's serf gossip protocol
consul gossip encryption key: mT8hA2MZqHvY7#Njf63swc=-

