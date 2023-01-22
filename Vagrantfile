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
        # Vagrant boot needs some redundant love before the main script, since
        # it's a barebones system. Note that the password-setting is only for
        # Vagrant, as it will have been set on install by the user on a real
        # machine -- don't do this IRL lol
        useradd -G sudo -m ryan
        echo -e 'vagrant\nvagrant' | passwd ryan
        printf 'ryan ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/ryan

        sudo -u ryan bash /vagrant/system/main.sh
      SCRIPT
  end

end
