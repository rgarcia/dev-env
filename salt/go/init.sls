# on ubuntu the default go package is very old
# in practice you want the flexibility of switching between go versions as well
# thus, install godeb (https://github.com/niemeyer/godeb) and set user up with the latest version
godeb:
  cmd.run:
    - name: >
       cd /tmp && 
       wget https://godeb.s3.amazonaws.com/godeb-amd64.tar.gz && 
       tar zxvf godeb-amd64.tar.gz && 
       cp /tmp/godeb /usr/local/bin/godeb
    - unless: which godeb
go:
  cmd.run:
    - name: godeb install 1.5
    - unless: 'go version | grep 1.5'
    - require:
      - cmd: godeb
  pkg.installed:
    - name: mercurial # many 3rd party go dependencies (e.g. many on code.google.com) are mercurial repos

/home/{{ pillar.user }}/go:
  file.directory:
    - user: {{ pillar.user }}
    - makedirs: True
    - require:
      - cmd: go

go-bash-profile:
  file.append:
    - name: /home/{{ pillar.user }}/.bash_profile
    - text:
      - export GOPATH=~/go
      - export PATH=$PATH:$GOPATH/bin
    - require:
      - cmd: go

{% for util in [
  "golang.org/x/tools/cmd/goimports",
  "github.com/rogpeppe/godef",
  "github.com/nsf/gocode"
] %}
go-get-{{ util }}:
  cmd.run:
    - name: GOPATH=~/go go get -u {{ util }}
    - user: {{pillar.user}}
    - env:
      - GOPATH: /home/{{ pillar.user }}/go
    - require:
      - file: /home/{{ pillar.user }}/go
{% endfor %}
