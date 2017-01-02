Vagrant.configure(2) do |config|
  # config.omnibus.chef_version = :latest
  # config.berkshelf.enabled = false
  config.vm.define :webdb do |webdb|
    webdb.vm.hostname = 'webdb'
    webdb.vm.box = 'ubuntu1404'
    webdb.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box'
    webdb.vm.network 'forwarded_port', guest: 80, host: 8080
    webdb.vm.network 'forwarded_port', guest: 5000, host: 5000
    webdb.vm.network 'private_network', ip: '10.0.1.10'
    webdb.vm.provision :chef_zero do |chef|
      chef.cookbooks_path = 'cookbooks'
      chef.nodes_path = 'nodes'
      # chef.roles_path = 'roles'
      chef.run_list = %w[
        recipe[rsync]
        recipe[git]
        recipe[nginx]
        recipe[python]
        recipe[postgresql]
        recipe[postgresql::server]
        recipe[rsync]
      ]
    end
    config.vm.synced_folder "/Users/#{ENV['USER']}/project/python-uwsgi/my_app/",  "/home/vagrant/my_app/", type: "rsync", create: true, owner: "vagrant", group: "vagrant", rsync__exclude: [".git/", "vendor/"]
  end

end
