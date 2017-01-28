git "home/#{node['python']['user']}/.pyenv" do
  repository node['python']['pyenv_url']
  action :sync
  user node['python']['user']
  group node['python']['group']
end

%w{.bash_profile}.each do |filename|
  template filename do
    source "#{filename}.erb"
    path "/home/#{node['python']['user']}/#{filename}"
    owner node['python']['user']
    group node['python']['group']
    mode 0644
    not_if "grep pyenv ~/.bash_profile", :environment => {:'HOME' => "/home/#{node['python']['user']}" }
  end
end

execute "pyenv install #{node['python']['anaconda_version']}" do
  command "/home/#{node['python']['user']}/.pyenv/bin/pyenv install #{node['python']['anaconda_version']}"
  action :run
  user node['python']['user']
  group node['python']['group']
  environment 'HOME' => "/home/#{node['python']['user']}"
  not_if { File.exist?("/home/#{node['python']['user']}/.pyenv/versions/#{node['python']['anaconda_version']}") }
end

execute "pyenv global #{node['python']['anaconda_version']}" do
  command "/home/#{node['python']['user']}/.pyenv/bin/pyenv global #{node['python']['anaconda_version']}"
  action :run
  user node['python']['user']
  group node['python']['group']
  environment 'HOME' => "/home/#{node['python']['user']}"
end

git "home/#{node['python']['user']}/.pyenv/plugins/pyenv-pip-rehash" do
  repository node['python']['pyenv-pip-rehash_url']
  action :sync
  user node['python']['user']
  group node['python']['group']
end

%w{build-essential python3-dev libpq-dev}.each do |pkg|
	package pkg do
		action :install
	end
end

%w{uwsgi psycopg2 Flask-SQLAlchemy Flask-Migrate beautifulsoup4}.each do |pkg|
  execute "pip install #{pkg}" do
    command "/home/#{node['python']['user']}/.pyenv/shims/pip install #{pkg}"
    action :run
    user node['python']['user']
    group node['python']['group']
    environment 'HOME' => "/home/#{node['python']['user']}"
    not_if { File.exist?("/home/#{node['python']['user']}/.pyenv/shims/#{pkg}") }
  end
end
