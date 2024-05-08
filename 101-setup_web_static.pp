# Redoing the task #0 but by using Puppet

$nginx_conf = "server {
	listen 80 default_server;
	location /hbnb_static/ {
		alias /data/web_static/current/;
		index index.html;
	}
}"

package { 'nginx':
  ensure   => 'present',
  provider => 'apt'
}

-> file { '/data':
  ensure => 'directory'
}

-> file { '/data/web_static':
  ensure => 'directory'
}

-> file { '/data/web_static/releases':
  ensure => 'directory'
}

-> file { '/data/web_static/releases/test':
  ensure => 'directory'
}

-> file { '/data/web_static/shared':
  ensure => 'directory'
}

-> file { '/data/web_static/releases/test/index.html':
  ensure  => 'present',
  content => 'Hello World!!'
}

-> file { '/data/web_static/current':
  ensure => link,
  target => '/data/web_static/releases/test/',
}

-> exec { 'chown -R ubuntu:ubuntu /data/':
  path => '/usr/bin/:/usr/local/bin/:/bin/'
}

file { '/etc/nginx/sites-available/default':
  ensure  => 'present',
  content => $nginx_conf,
}

exec { 'nginx restart':
  path => '/etc/init.d/'
}
