Vagrant.configure("2") do |config|
  box = "debian/bookworm64"

  cpus   = 4
  memory = 2048

  config.vm.provider "virtualbox" do |vb|
    vb.cpus   = cpus
    vb.memory = memory
  end

  config.vm.provider "libvirt" do |lv|
    lv.cpus   = cpus
    lv.memory = memory
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  config.vm.define "ws" do |ws|
    ws.vm.box = box
    ws.vm.synced_folder ".", "/vagrant", disabled: true
    ws.vm.provision "file", source: "./Makefile", destination: "/tmp/workstation/Makefile"
    ws.vm.provision "file", source: "./system", destination: "/tmp/workstation/system"
    ws.vm.provision "file", source: "./dotfiles", destination: "/tmp/workstation/dotfiles"
    ws.vm.provision "shell",
      inline: <<-SCRIPT
        # Vagrant boot needs some redundant love before the main script, since
        # it's a barebones system. Note that the password-setting is also only
        # for Vagrant, as it will have been set on install by the user on a real
        # machine -- don't do this IRL lol
        useradd -G sudo -m ryan || true
        echo -e 'vagrant\nvagrant' | passwd ryan
        printf 'ryan ALL=(ALL) NOPASSWD:ALL\n' > /etc/sudoers.d/ryan

        TESTING=true bash /tmp/workstation/system/main.sh
      SCRIPT
  end

end
