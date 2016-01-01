# Dev environment

This repo contains a vagrant VM setup that represents my dev environment.

It uses [Salt](http://www.saltstack.com/) to provision the VM.

## Usage

  - Change `pillar/personal-example.sls` to `pillar/personal.sls` (`mv pillar/personal-example.sls pillar/personal.sls`).
  - Edit the items in the `pillar/personal.sls`.
  - Download Vagrant 1.7.4 [here](https://www.vagrantup.com/download-archive/v1.7.4.html).
  - Download VirtualBox [here](https://www.virtualbox.org/).
    Tested against 5.0.3.
  - Install the [vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest) plugin:
    - `vagrant plugin install vagrant-vbguest`
  - Start a new machine, running `cd path/to/this_repo && vagrant up`.
  - (Optional) Install [Vagrant Vbox Snapshot](https://github.com/dergachev/vagrant-vbox-snapshot) to allow incremental backups.
