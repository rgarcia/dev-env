{% set s3cmd_version = '1.6.0' %}
s3cmd-deps:
  pkg.installed:
    - name: python-setuptools
s3cmd-purged:
  pkg.purged:
    - name: s3cmd
s3cmd:
  cmd.run:
    - name: >
       cd /tmp && 
       wget https://github.com/s3tools/s3cmd/releases/download/v{{ s3cmd_version }}/s3cmd-{{ s3cmd_version }}.tar.gz && 
       tar zxvf s3cmd-{{ s3cmd_version }}.tar.gz && 
       cd s3cmd-{{ s3cmd_version }} && 
       python setup.py install
    - unless: s3cmd --version | grep {{ s3cmd_version }}
    - require:
      - pkg: s3cmd-deps
      - pkg: s3cmd-purged
