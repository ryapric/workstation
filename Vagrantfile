Vagrant.configure("2") do |config|
  box = "debian/bullseye64"

  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 4
    vb.memory = 2048
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.vm.define "ws" do |ws|
    ws.vm.box = box
    ws.vm.synced_folder ".", "/vagrant" # , disabled: true
    ws.vm.provision "shell",
      inline: <<-SCRIPT
        # Vagrant boot needs some love before the main script, since it's a
        # barebones system
        useradd -G sudo -m ryan
        printf 'ryan ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/ryan

        # sudo -u ryan bash /vagrant/system/main.sh
      SCRIPT
  end

end
