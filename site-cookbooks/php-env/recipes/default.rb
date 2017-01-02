%w{php-fpm php-pecl-zendopcache}.each do |pkg|
	package pkg do
		action :install
		notifies :restart, "service[php-fpm]"
	end
end

service "php-fpm" do
	action [:enable, :start]
end

template "php.ini" do
	source "php.ini.erb"
	path "/etc/php.ini"
	user node['php_env']['user']
	group node['php_env']['user']
	mode 0644
	notifies :restart, "service[php-fpm]"
end
