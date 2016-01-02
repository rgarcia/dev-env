git:
  pkg:
    - installed
    - require:
      - ssh_known_hosts: github.com
      - file: /etc/sudoers.d/ssh-auth-sock
  # TODO: replace this with https://docs.saltstack.com/en/latest/ref/states/all/salt.states.git.html
  cmd.run:
    - user: {{ pillar.user }}
    - names:
      - git config --global user.name "{{ pillar.name }}"
      - git config --global user.email "{{ pillar.email }}"

github.com:
  ssh_known_hosts.present:
    - user: {{ pillar.user }}
    - fingerprint: 16:27:ac:a5:76:28:2d:36:63:1b:56:4d:eb:df:a6:48

# ssh-agent forwarding doesn't pass on to `sudo -i -u vagrant`
# this mostly affects `git clone` operations using ssh, so put in a workaround here
# https://github.com/mitchellh/vagrant/issues/377
# https://github.com/mitchellh/vagrant/issues/1303
/etc/sudoers.d/ssh-auth-sock:
  file.managed:
    - contents: 'Defaults	env_keep += "SSH_AUTH_SOCK"'
