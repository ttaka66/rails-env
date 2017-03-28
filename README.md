# Rails environment

## Overview

## Description

## Demo

## Requirement

- Ruby
- Chef

## Usage

### Provisioning on EC2 instance

You must select ubuntu AMI.

```bash
$ berks vendor cookbooks
$ knife zero bootstrap ubuntu@<YOUR_EC2_INSTANCE_HOST> -i <YOUR_AWS_KEY_PATH> --sudo --environment ec2_ubuntu --run-list "role[web]"( --node-name <NODE_NAME>)( --json-attributes {"ruby": {"ruby_version": "2.3.1", "rails_version": "~> 4.2"}})
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
-d: database
-T: don't create Test::Unit
-skip-bundle: don't execute \`bundle install\`

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
$ (bundle exec )unicorn_rails -c config/unicorn.rb -D
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
