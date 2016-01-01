VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  # these settings help virtualbox networking be happier
  # in nested vm environments

  config.vm.box = "ubuntu/trusty64"

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--natnet1", "172.0/16"]
    vb.customize ["guestproperty", "set", :id, "/VirtualBox/GuestAdd/VBoxService/--timesync-set-threshold", "60000"]
    vb.memory = 4096
    vb.cpus = 2
  end

  config.ssh.forward_agent = true
  config.ssh.forward_x11 = true

  config.vm.network "private_network", ip: "192.168.50.5"

  # Include this repo on the VM in the place Salt expects (/srv)
  config.vm.synced_folder ".", "/srv", :type => "rsync"

  config.vm.provision :shell, :inline => "rm -f /etc/salt/minion_id"
  # workaround for https://github.com/mitchellh/vagrant/issues/5973
  config.vm.provision :shell, :inline => "mkdir -p /etc/salt && echo 'file_client: local' > /etc/salt/minion"
  config.vm.provision :salt do |salt|
    #salt.minion_config = './minion.masterless'
    salt.run_highstate = true
    salt.always_install = false
    salt.install_type = "git"
    salt.install_args = "v2014.7.0"
    salt.verbose = true
    salt.colorize = true
  end

end
