/home/{{ pillar.user }}/.personal_bash:
  file:
    - managed
    - replace: False
    - source: salt://envs/personal_bash
    - user: {{ pillar.user }}
    - template: jinja

bash_profile:
  file.append:
    - name: /home/{{ pillar.user }}/.bash_profile
    - makedirs: True
    - text:
      - 'source ~/.bashrc'
      - 'source ~/.personal_bash'
