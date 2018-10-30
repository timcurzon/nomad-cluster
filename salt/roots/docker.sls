docker package dependencies:
  pkg.installed:
    - pkgs:
      - apt-transport-https
      - iptables
      - ca-certificates
      #- python-apt
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