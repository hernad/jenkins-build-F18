Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu-12.04-i386"

  config.persistent_storage.enabled = true
  config.persistent_storage.location = "./data.vdi"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"

     vb.customize ["modifyvm", :id, "--vrde", "on" ]
     vb.customize ["modifyvm", :id, "--vrdeport", "33891" ]
     vb.customize ["modifyvm", :id, "--clipboard", "bidirectional" ]

  end

  config.vm.provision "shell", path: "build.sh"

end
