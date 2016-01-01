include:
  - git

{% set gopathme = '/home/' + pillar['user'] + '/go/src/github.com/rgarcia' %}

{{ gopathme }}:
  file.directory:
    - user: {{ pillar.user }}
    - makedirs: True

# Download most recent version of reposync, and store path to downloaded .tar.gz file
# (This happens during Jinja compilation, before anything else in this state runs.)
{% set download = salt["gh_releases.download"](None, "rgarcia", "reposync", None) %}

/usr/local/bin/reposync:
  cmd.run:
    - name: tar -xvf {{download.filename}}
    - cwd: /tmp

  file.copy:
    - source: /tmp/{{download.dirname}}/reposync
    - force: True
    - require:
      - cmd: /usr/local/bin/reposync

# Cleanup temp files
{{download.filename}}:
  file.absent:
    - require:
      - file: /usr/local/bin/reposync

/tmp/{{download.dirname}}:
  file.absent:
    - require:
      - file: /usr/local/bin/reposync

# todo: run reposync
