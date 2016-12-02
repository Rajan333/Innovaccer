#!/bin/bash
###__AUTHOR: RAJAN MIDDHA__###

install_nginx(){
	sudo mkdir -p /opt/packages
	sudo chown -R $USER /opt
	cd /opt/packages
	wget http://nginx.org/packages/centos/7/x86_64/RPMS/nginx-1.10.0-1.el7.ngx.x86_64.rpm
	sudo rpm -ivh nginx-1.10.0-1.el7.ngx.x86_64.rpm
	sudo service nginx start
}

install_nginx
