base:
  '*':
    - test
    - networking
    - dnsmasq
    - consul
    - docker
    - nomad

  'node-1*':
    - jobs
