# Rails environment

## Overview

## Description

## Demo

## Requirement

- Ruby
- [Chef](https://www.chef.io/chef/)
- [Knife-Zero](http://knife-zero.github.io/30_subcommands/)

## Usage

### Provisioning by SSH

These commands suppose that os of your ssh host machine is **Ubuntu16.14** and have **ubuntu** user.

```bash
$ berks vendor cookbooks
$ knife zero bootstrap ubuntu@{YOUR_SSH_HOST} -i {YOUR_SSH_KEY_PATH} --node-name {NODE_NAME}
$ knife node run_list add {NODE_NAME} 'role[web]'
($ knife node run_list add {NODE_NAME} 'role[db]')
$ knife node environment set {NODE_NAME} ubuntu1604
$ knife zero converge "name:{NODE_NAME}"  --ssh-user {YOUR_SSH_USER_NAME} -i {YOUR_SSH_KEY_PATH}
```



### Provisioning on Vagrant

```bash
$ berks vendor cookbooks
$ vagrant up --provision
```

### Server

Create project

```
$ rails new <application name> -d postgresql -T --skip-bundle
$ cd  <application name>
```
Note:
- -d: database
- -T: don't create Test::Unit
- -skip-bundle: don't execute \`bundle install\`

Add Unicorn gem to Gemfile
```
$ vim Gemfile
```

``` Gemfile
...
gem 'unicorn'
...
```

Install gem
```
$ bundle install( --path vendor/bundle)
```

Setting Unicorn

```
$ vim config/unicorn.rb
```

``` config/unicorn.rb
# -*- coding: utf-8 -*-
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 15
preload_app true

listen "/tmp/unicorn.sock"
pid "/tmp/unicorn.pid"

before_fork do |server, worker|
  Signal.trap 'TERM' do
  puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
  Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
  puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
  ActiveRecord::Base.establish_connection
end

stderr_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])
stdout_path File.expand_path('log/unicorn.log', ENV['RAILS_ROOT'])
```

Create database

```
$ (bundle exec )rake db:create
```

Start Unicorn

```
$ (bundle exec )unicorn_rails -c config/unicorn.rb -D (-E production)
```

(Stop Unicorn)

```
$ kill -QUIT `cat /tmp/unicorn.pid`
```

Restart Nginx

```
$ sudo service nginx restart
```



## Contribution

## Licence

## Author
