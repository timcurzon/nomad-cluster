base:
  '*':
    - common

  'node*':
    - cluster.common

{% for nodeNum in range(1, 4) %}
  node-{{ nodeNum }}:
    - cluster.node-{{ nodeNum }}
{% endfor %}