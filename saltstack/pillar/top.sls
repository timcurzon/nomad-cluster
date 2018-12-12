base:
  '*':
    - common
    {% if salt['file.file_exists']('/srv/pillar/overrides.sls') %}
    - overrides
    {% endif %}

{% for nodeNum in range(1, 4) %}
  node-{{ nodeNum }}:
    - node-{{ nodeNum }}
{% endfor %}