git:
  pkg:
    - installed
  # TODO: replace this with https://docs.saltstack.com/en/latest/ref/states/all/salt.states.git.html
  cmd.run:
    - user: {{ pillar.user }}
    - names:
      - git config --global user.name "{{ salt['pillar.get']('name') }}"
      - git config --global user.email "{{ salt['pillar.get']('email') }}"
      - echo "setting up git config"

github.com:
  ssh_known_hosts.present:
    - user: {{ pillar.user }}
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48
