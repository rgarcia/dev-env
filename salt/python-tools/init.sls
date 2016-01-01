python-extras:
  pkg.installed:
    - names:
      - python-setuptools
      - python-dev

python-tools:
  cmd.script:
    - user: root
    - source: salt://python-tools/install.sh
    - unless: which mkvirtualenv
    - require:
      - pkg: python-setuptools

python-tools-bash-profile:
  file.append:
    - name: /home/{{ salt['pillar.get']('user') }}/.bash_profile
    - text:
      - source /usr/local/bin/virtualenvwrapper.sh
    - require:
      - cmd: python-tools

source-virt:
  cmd.run:
    - user: {{ salt['pillar.get']('user') }}
    - shell: /bin/bash
    - names:
      - source ~/.bash_profile
    - require:
      - cmd: python-tools
