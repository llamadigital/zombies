# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  config.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box'

  config.vm.box = 'raring-server-cloudimg-amd64-vagrant-disk1'
  config.vm.network :private_network, ip: '192.168.69.69'
  
  config.vm.network "forwarded_port", guest: 3000, host: 27015

  config.vm.synced_folder '~', '/home/master'
  config.vm.synced_folder '.', '/home/vagrant/source', :nfs => true

  config.vm.hostname = 'zombiegame'

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--cpus', '1', '--memory', 1024]
  end

  config.vm.provision :shell, :path => 'ansible/install.sh'

  config.vm.provision :ansible do |ansible|
    ansible.playbook = 'playbook.yml'
    ansible.inventory_path = 'vagrant_host'
    ansible.verbose = true
    ansible.verbose = "v"
  end

end
