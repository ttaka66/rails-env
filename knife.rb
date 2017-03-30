local_mode true
chef_repo_path File.expand_path('../' , __FILE__)

knife[:ssh_attribute] = "knife_zero.host"
knife[:use_sudo] = true

knife[:automatic_attribute_whitelist] = %w[
  fqdn
  os
  os_version
  hostname
  ipaddress
  roles
  recipes
  ipaddress
  platform
  platform_version
  cloud
  cloud_v2
  chef_packages
]
