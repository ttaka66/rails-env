Vagrant.configure(2) do |config|
  # config.omnibus.chef_version = :latest
  # config.berkshelf.enabled = false
  config.vm.define :webdb do |webdb|
    webdb.vm.hostname = 'webdb'
    webdb.vm.box = 'ubuntu/xenial64'
    webdb.vm.network 'forwarded_port', guest: 80, host: 80
    webdb.vm.network 'forwarded_port', guest: 3000, host: 3000
    webdb.vm.network 'private_network', ip: '10.0.1.10'
    webdb.vm.provision :chef_zero do |chef|
      chef.cookbooks_path = 'cookbooks'
      chef.nodes_path = 'nodes'
      # chef.roles_path = 'roles'
      chef.run_list = %w[
        recipe[apt]
        recipe[rsync]
        recipe[git]
        recipe[nginx]
        recipe[ruby]
        recipe[postgresql]
        recipe[postgresql::server]
        recipe[rsync]
      ]

      chef.json = {
        ruby: {
          user: "ubuntu",
          group: "ubuntu"
        },
        postgresql: {
          user: "ubuntu"
        }
      }
    end
    # config.vm.synced_folder "/Users/#{ENV['USER']}/project/python-uwsgi/my_app/",  "/home/vagrant/my_app/", type: "rsync", create: true, owner: "vagrant", group: "vagrant", rsync__exclude: [".git/", "vendor/"]
  end

end
