jobs nomad availability:
  http.wait_for_successful_query:
    - name: http://front.this.node.cluster:4646
    - status: 200
    - wait_for: 60
    - request_interval: 5

jobs run fabio:
  cmd.run:
    - cwd: /services
    - name: sleep 5 && nomad run fabio.nomad && touch /tmp/nomad-fabio-running
    - env:
      - NOMAD_ADDR: http://front.this.node.cluster:4646
    - unless:
      - ls /tmp/nomad-fabio-running
    - require:
      - http: jobs nomad availability