Vagrant.configure("2") do |config|

  config.vm.box = "tape"
  config.vm.hostname = config.vm.box

  config.vm.box_url = "http://files.vagrantup.com/precise64.box"

  config.vm.network :private_network, ip: "192.168.56.17"

  config.vm.network :forwarded_port, guest: 9200, host: 9200
  config.vm.network :forwarded_port, guest: 8888, host: 8888

  config.vm.synced_folder ".", "/tape", :nfs => true

  config.vm.provision :puppet do |puppet|
    puppet.module_path = 'vagrant/puppet/modules'
    puppet.manifests_path = 'vagrant/puppet/manifests'
    puppet.manifest_file = 'default.pp'
    puppet.options = '--verbose --debug'
  end

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 2048]
  end

end