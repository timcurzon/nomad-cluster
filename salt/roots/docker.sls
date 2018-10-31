docker package dependencies:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - iptables
      - ca-certificates
      - software-properties-common

docker package repository:
  pkgrepo.managed:
    - name: deb [arch={{ grains["osarch"] }}] https://download.docker.com/linux/{{ grains["os"]|lower }} {{ grains["oscodename"] }} stable
    - humanname: {{ grains["os"] }} {{ grains["oscodename"]|capitalize }} Docker Package Repository
    - key_url: https://download.docker.com/linux/ubuntu/gpg
    - file: /etc/apt/sources.list.d/docker.list
    - refresh: True

docker package:
  pkg.installed:
    - name: docker-ce

docker config:
  file.managed:
    - name: /etc/docker/daemon.json
    - source: /srv/salt/docker/daemon.json.jinja
    - template: jinja
    - mode: 644
    - user: root

docker service:
  service.running:
    - name: docker
    - enable: True
    - watch:
      - file: docker config

docker compose install:
  file.managed:
    - name: /usr/local/bin/docker-compose
    - source: https://github.com/docker/compose/releases/download/1.23.0/docker-compose-Linux-x86_64
    - source_hash: 5b6f948a264a2c018a124b3cae0ce788f14b94a37ab05ca3ba3bb8622f5b7d0b
    - user: root
    - group: root
    - mode: 755