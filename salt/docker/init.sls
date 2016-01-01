{% set uname_r = salt['cmd.run']('uname -r') %}

linux-image-extra-{{ uname_r }}:
  pkg:
    - installed

docker-ppa-keys:
  cmd.run:
    - name: "apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D"
    - unless: 'apt-key list | grep 2C52609D'

/etc/apt/sources.list.d/docker.list:
  file.managed:
    - source: salt://docker/docker.list
    - require:
      - cmd: docker-ppa-keys
  cmd.run:
    - name: "apt-get update && apt-get purge lxc-docker"
    - onchanges:
      - file: /etc/apt/sources.list.d/docker.list

docker-engine:
  pkg.installed:
    - require:
      - cmd: docker-ppa-keys
      - cmd: /etc/apt/sources.list.d/docker.list
      - pkg: linux-image-extra-{{ uname_r }}

/etc/default/docker:
  file.managed:
    - source: salt://docker/default
    - require:
      - pkg: docker-engine
  cmd.run:
    - name: "service docker restart"
    - onchanges:
      - file: /etc/default/docker
