#!/bin/bash

# Easily run a salt state without familiarity with salt syntax
#   - 'highstate' is a special keyword, that runs all states
#   - otherwise, use the name of any state, like 'clever-repos'
if [[ -z $1  ]]; then
  echo "usage: run_salt_state.sh <state (subdir in salt dir) or 'highstate' (all states)>"
  exit
fi

echo "About to run state: '$1'"
if [[ $1 == 'highstate' ]]; then
  sudo salt-call --local -m ./salt/_modules state.highstate
else
  sudo salt-call --local -m ./salt/_modules state.sls $1
fi

# To run a specific module's function with custom arugments from the command line:
#
#   sudo salt-call --local <module>.<function> <args...>
#
# For example:
# (http://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.archive.html)
#
#   sudo salt-call --local archive.tar xf foo.tar dest=/target/directory
#
# Or to run a state using local salt modules  (`-m ./salt/_modules`):
#
#   sudo salt-call --local -m ./salt/_modules gh_repos.list_org <token> <org> <type>
