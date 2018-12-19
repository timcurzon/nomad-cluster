jobs nomad available:
  http.wait_for_successful_query:
    - name: http://front.this.node.{{ pillar['cluster domain'] }}:4646
    - status: 200
    - wait_for: 60
    - request_interval: 5

jobs initial wait:
  cmd.run:
    - name: sleep 10
    - require:
      - http: jobs nomad available

jobs run fabio:
  cmd.run:
    - cwd: /services
    - name: nomad run fabio.nomad && touch /services/fabio-firstrun
    - env:
      - NOMAD_ADDR: http://front.this.node.{{ pillar['cluster domain'] }}:4646
    - unless:
      - ls /services/fabio-firstrun
    - require:
      - cmd: jobs initial wait

jobs run vault:
  cmd.run:
    - cwd: /services
    - name: nomad run vault.nomad && touch /services/vault-firstrun
    - env:
      - NOMAD_ADDR: http://front.this.node.{{ pillar['cluster domain'] }}:4646
    - unless:
      - ls /services/vault-firstrun
    - require:
      - cmd: jobs initial wait