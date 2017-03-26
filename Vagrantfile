Vagrant.configure("2") do |config|
  config.vm.box = "W7-msys2"

  config.persistent_storage.enabled = true
  config.persistent_storage.location = "./data.vmdk"

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "2048"
  end

end
