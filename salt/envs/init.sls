/home/{{ salt['pillar.get']('user') }}/.personal_bash:
  file:
    - managed
    - replace: False
    - source: salt://envs/personal_bash
    - user: {{ salt['pillar.get']('user') }}
    - template: jinja

bash_profile:
  file.append:
    - name: /home/{{ salt['pillar.get']('user') }}/.bash_profile
    - makedirs: True
    - text:
      - 'source ~/.bashrc'
      - 'source ~/.personal_bash'
