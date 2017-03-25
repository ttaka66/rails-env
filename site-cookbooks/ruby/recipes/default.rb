%w{curl g++ make zlib1g-dev libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt-dev libffi-dev sqlite3 libsqlite3-dev nodejs}.each do |pkg|
  package pkg do
    action :install
  end
end

git "/home/#{node['ruby']['user']}/.rbenv" do
  repository node['ruby']['rbenv_url']
  action :sync
  user node['ruby']['user']
  group node['ruby']['group']
end

%w{.bash_profile}.each do |filename|
  template filename do
    source "#{filename}.erb"
    path "/home/#{node['ruby']['user']}/#{filename}"
    owner node['ruby']['user']
    group node['ruby']['group']
    mode 0644
    not_if "grep rbenv ~/.bash_profile", :environment => {:'HOME' => "/home/#{node['ruby']['user']}" }
  end
end

directory "/home/#{node['ruby']['user']}/.rbenv/plugins" do
  mode "0755"
  action :create
  user node['ruby']['user']
  group node['ruby']['group']
end

git "/home/#{node['ruby']['user']}/.rbenv/plugins/ruby-build" do
  repository node['ruby']['ruby-build_url']
  action :sync
  user node['ruby']['user']
  group node['ruby']['group']
end

execute "rbenv install #{node['ruby']['ruby_version']}" do
  command "CONFIGURE_OPTS=\"--disable-install-doc\" /home/#{node['ruby']['user']}/.rbenv/bin/rbenv install #{node['ruby']['ruby_version']}"
  action :run
  user node['ruby']['user']
  group node['ruby']['group']
  environment 'HOME' => "/home/#{node['ruby']['user']}"
  not_if { File.exist?("/home/#{node['ruby']['user']}/.rbenv/versions/#{node['ruby']['ruby_version']}") }
end

execute "rbenv global #{node['ruby']['ruby_version']}" do
  command "/home/#{node['ruby']['user']}/.rbenv/bin/rbenv global #{node['ruby']['ruby_version']}"
  action :run
  user node['ruby']['user']
  group node['ruby']['group']
  environment 'HOME' => "/home/#{node['ruby']['user']}"
end

execute "gem install rails --version=\"#{node['ruby']['rails_version']}\"" do
  command "/home/#{node['ruby']['user']}/.rbenv/shims/gem install rails --version=\"#{node['ruby']['rails_version']}\""
  action :run
  user node['ruby']['user']
  group node['ruby']['group']
  environment 'HOME' => "/home/#{node['ruby']['user']}"
  not_if { File.exist?("/home/#{node['ruby']['user']}/.rbenv/shims/rails") }
end

execute "rbenv rehash" do
  command "/home/#{node['ruby']['user']}/.rbenv/bin/rbenv rehash"
  action :run
  user node['ruby']['user']
  group node['ruby']['group']
  environment 'HOME' => "/home/#{node['ruby']['user']}"
end
