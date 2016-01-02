include:
  - git

{% set emacs_version = '24.5' %}
emacs:
  cmd.run:
    - name: >
       cd /tmp && 
       wget https://mirrors.kernel.org/gnu/emacs/emacs-{{ emacs_version }}.tar.gz && 
       tar zxvf emacs-{{ emacs_version }}.tar.gz && 
       cd emacs-{{ emacs_version }}/ && 
       ./configure && 
       make && 
       make install
    - unless: emacs --version | grep {{ emacs_version }}
    - require:
      - pkg: emacs
  pkg.installed:
    - names:
      - autoconf
      - xorg-dev
      - libjpeg-dev
      - libpng12-dev
      - libgif-dev
      - libtiff4-dev
      - libncurses5-dev
      - texinfo
      - libxpm-dev

prelude-git-clone:
  git.latest:
    - name: https://github.com/rgarcia/prelude.git
    - rev: master
    - target: /home/{{ pillar.user }}/.prelude
    - user: {{ pillar.user }}
    - require:
      - pkg: git
      - ssh_known_hosts: github.com

/home/{{ pillar.user }}/.emacs.d:
  file.symlink:
    - target: /home/{{ pillar.user }}/.prelude
