# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
end
Vagrant.configure('2') do |config|

  if ARGV[1] == 'test'
    ARGV.delete_at(1)
    test = true
  else
    test = false
  end

  config.vm.box = "generic/debian10"
  config.vm.provider :libvirt do |libvirt|
    libvirt.memory = 3072
  end
  if test == false
    config.vm.define :check do |check|
      check.vm.hostname = 'check'
    end
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
    end
    config.vm.synced_folder ".", "/restic_ynh"
  else
    config.vm.define :test do |test|
      test.vm.hostname = 'test'
    end
    config.vm.provision "ansible" do |ansible|
      ansible.playbook = "integration-tests-playbook.yml"
    end
    config.vm.synced_folder ".", "/restic_ynh"
  end

end
