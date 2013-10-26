# Ansible Roles

## Requirements
+ [Ansible](http://www.ansibleworks.com/) version >= 1.3
+ [Vagrant](http://www.vagrantup.com/) version >= v1.2.7
+ SSH configuration (see below)

### SSH Configuration
Due to limitations with current version of ansible it is required to add the
following to your SSH config file (~/.ssh/config): 

`host *`

`StrictHostKeyChecking no`

`UserKnownHostsFile=/dev/null`

## Usage
There are a few wasy to use these roles, however if you use them as a git submodule you can easily keep the roles up to date with.  To do this you should head to the root of your project (which needs t obe a git repo) and run:

`git submodule add ansible@llama-systems:/var/git/ansible ansible`

This will create an ansible folder in the root of the project which contains the recipe files.  In order to use these files you will need to add a Vagrant file and ansible playbook and inventory.  Sample files are shown below:

### Sample Vagrant Configuration (Vagrantfile)

```ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|

  config.vm.box_url = 'http://cloud-images.ubuntu.com/vagrant/raring/current/raring-server-cloudimg-amd64-vagrant-disk1.box'

  config.vm.box = 'raring-server-cloudimg-amd64-vagrant-disk1'
  config.vm.network :private_network, ip: '192.168.69.69'

  config.vm.synced_folder, '~', '/home/vagrant/master'
  config.vm.synced_folder '.', '/home/vagrant/source', :nfs => true

  config.vm.hostname = 'sharetobuyapi'

  config.vm.provider :virtualbox do |vb|
    vb.customize ['modifyvm', :id, '--cpus', '1', '--memory', 1024]
  end

  config.vm.provision :shell, :path => 'ansible/install.sh'

  config.vm.provision :ansible do |ansible|
    ansible.playbook = 'playbook.yml'
    ansible.inventory_file = 'vagrant_host'
    ansible.verbose = true
  end

end
```

### Sample Ansible Inventory (vagrant_host)
```yaml
[vagrant]
192.168.69.69
```

### Sample Ansible Playbook (playbook.yml)
```yaml
---
 - hosts: vagrant
   sudo: yes

   roles:
     - ansible/core
     - { role: ansible/ruby, version: ruby2.0 }

```

You should now be able to run vagrant up and vagrant ssh so access the vagrant box.

## Working on an existing project
If you need to work on a project which someone else has created or when you come back to a project after a while you should run `git submodule init ` and `git submodule update`.
