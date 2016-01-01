git:
  pkg:
    - installed
  cmd.run:
    - user: {{ salt['pillar.get']('user') }}
    - names:
      - git config --global user.name "{{ salt['pillar.get']('name') }}"
      - git config --global user.email "{{ salt['pillar.get']('email') }}"
      - echo "setting up git config"
