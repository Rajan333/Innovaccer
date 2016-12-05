from __future__ import with_statement
from fabric.api import *
import fabric
from fabric.contrib.console import confirm
import platform
import re
import time
import getpass
import socket

#env.key_filename=["/home/ec2-user/platform_dev.pem"]

def test():
	output = run('ls')
	if output:
		print "Connection Established"


def install_rh7():
	OS_version = platform.linux_distribution()

	print "Setup for OS 7.x is initiating..."
	if 'red hat' in OS_version[0].lower() or 'centos' in OS_version[0].lower():

		with cd('/etc/yum.repos.d/'):
			# It changes with OS version
			sudo('wget http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.2.0/ambari.repo')
			sudo('yum -y install ntp')
			sudo('service ntpd start')
			sudo('yum -y install ambari-server')
			sudo('ambari-server setup')

		# with cd('/var/lib/ambari-server/resources/stacks/HDP/2.3/services'):
		# sudo('git clone http://git.innovaccer.com/akif/job-server-ambari-plugin.git')

		with cd('/opt'):
			sudo('mkdir ambari-packages')
		with cd('/opt/ambari-packages'):
			sudo('wget ftp://195.220.108.108/linux/epel/7/x86_64/j/jemalloc-3.6.0-1.el7.x86_64.rpm')
			sudo('rpm -ivh jemalloc-3.6.0-1.el7.x86_64.rpm')
			sudo('wget ftp://195.220.108.108/linux/remi/enterprise/7/remi/x86_64/redis-3.2.5-1.el7.remi.x86_64.rpm')
			sudo('rpm -ivh redis-3.2.5-1.el7.remi.x86_64.rpm')
			sudo('systemctl start redis.service')
			print('Redis as a service STARTED')
			sudo('wget http://downloads.lightbend.com/scala/2.11.7/scala-2.11.7.rpm')
			sudo('rpm -ivh scala-2.11.7.rpm')
			print('Scala Installed')
			sudo('curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo')
			sudo('yum install sbt-0.13.8')
			print('SBT installed')
			sudo('yum -y remove snappy')
			sudo('yum -y install https://dev.mysql.com/get/mysql57-community-release-el7-7.noarch.rpm')
			sudo('yum -y install mysql-community-server')
			sudo('service mysqld start')
			sudo("grep 'temporary password' /var/log/mysqld.log > mysql_password_root_account")
			print('Mysql Installed')

		with cd('/etc/yum.repos.d'):
			put('mongodb-org-3.2.repo', 'mongodb-org-3.2.repo', use_sudo=True)
			sudo('yum install -y mongodb-org')
			sudo('service mongod start')
			print('mongo started')

		sudo('ambari-server restart')
	else:
		print "Different OS version. Cant Install"
		exit()

def install_rh6():
	
	OS_version=platform.linux_distribution()
	
	print "Setup for OS 6.x is initiating..."
	if 'centos' in OS_version[0].lower() or 'red hat' in OS_version[0].lower():
		message = ""
		with cd('/etc/yum.repos.d/'):
			# It changes with OS version
			sudo('wget http://public-repo-1.hortonworks.com/ambari/centos7/2.x/updates/2.2.0.0/ambari.repo')
			sudo('yum -y install ntp')
			sudo('service ntpd start')
			sudo('yum -y install ambari-server')
			sudo('ambari-server setup')
		
		#with cd('/var/lib/ambari-server/resources/stacks/HDP/2.3/services'):
			#sudo('git clone http://git.innovaccer.com/akif/job-server-ambari-plugin.git')
			
		with cd('/opt'):
			sudo('mkdir ambari-packages')
		with cd('/opt/ambari-packages'):
			packages = sudo('yum list all | grep jemalloc')	#Checking if package is availabe in repo
			package_list = packages.split('\n')
			if len(package_list) > 0:
				sudo('yum install jemalloc')
			
			else:
				sudo('wget http://195.220.108.108/linux/epel/7/x86_64/j/jemalloc-3.6.0-1.el7.x86_64.rpm')
				sudo('rpm -ivh jemalloc-3.6.0-1.el7.x86_64.rpm')	

			packages = sudo('yum list all | grep redis')	#Checking if package is availabe in repo
			package_list = packages.split('\n')
			if len(package_list) > 0:
		
				sudo('yum install redis')
				sudo('service redis start')
				print('Redis as a service STARTED')
			else:
				
				sudo('wget http://download.redis.io/releases/redis-3.0.7.tar.gz')	
				sudo('tar xzf redis-3.0.7.tar.gz')
				sudo('cd /opt/ambari-packages/redis-3.0.7')
				try:
					sudo('make')
					sudo('src/redis-server --daemonize yes')
					print('Redis as a Service STARTED')
				except:
					message += "Redis, "
					pass
				#print('Unable to install Redis. Please install it manually')
				#pass
				#sudo('systemctl start redis.service')
				#print('Redis as a service STARTED')
				sudo('cd /opt/ambari-packages')	
		
			packages = sudo('yum list all | grep scala')	#Checking if package is availabe in repo
			package_list = packages.split('\n')
			package_list_final = []
			for pack in package_list:
				temp = pack.split(' ')
				package_list_final.append(temp)
			for package in package_list_final:
				version=re.compile(".*(2.11.7-1).*")
				vers = [m.group(0) for l in package for m in [version.search(l)] if m]
				if len(vers) > 0:
					sudo('yum install scala')
					print('Scala Installed')
					break
				else:
					try:
						sudo('wget http://downloads.lightbend.com/scala/2.11.7/scala-2.11.7.rpm')
						sudo('rpm -ivh scala-2.11.7.rpm')
						print('Scala Installed')
					except:
						message += "Scala, "
						pass					
					#print('Unable to install Scala. Please Install manually')
					break
			try:
				sudo('curl https://bintray.com/sbt/rpm/rpm | tee /etc/yum.repos.d/bintray-sbt-rpm.repo')
	  			sudo('yum install sbt-0.13.8')
				print('SBT installed')
			except:
				message += "SBT, "
			sudo('yum -y remove snappy')
			#time.sleep(10)
			try:
				sudo('yum install mysql-server')
				sudo('yum install mysql-connector-java')
				sudo('service mysqld start')
				sudo("grep 'temporary password' /var/log/mysqld.log > mysql_password_root_account")
				print('Mysql Installed')
			except:
				message += "Mysql, "
				pass			
			
		with cd('/etc/yum.repos.d'):
			try:
				put('mongodb-org-3.2.repo','mongodb-org-3.2.repo',use_sudo=True)
				sudo('yum install -y mongodb-org')
				sudo('service mongod start')
				print('mongo started')
			except:
				message += "MongoDB "
				pass	

		sudo('ambari-server restart')
		print message+"are not installed. Please install them manually."	

	else:
		print "Different OS version. Cant Install"
		exit()		

def sys_checks(hugePage = True):
	
	#On each node, make sure that SE Linux is turned off (if it is on then turn it off)

	output = run('selinuxenabled && echo enabled || echo disabled')
	
	if 'disabled' in output:
		print "SE Linux is Disabled"
	else:
		print "WARNING: SE Linux Not Disabled: "
		sudo('setenforce 0')
		sudo("sed -iq 's/^SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config")	
	
	#DIsable Transparent Huge pages, In version lower than 7 it is disabled already.
	if hugePage:
		output= sudo('echo never > /sys/kernel/mm/transparent_hugepage/enabled')
	
	#On each node, make sure that VM Swappiness is set to 0 (sysctl -n vm.swappiness should be 0)

	output=run('sysctl -n vm.swappiness')
	if output==0:
		print "VM Swappiness is set to 0"
	else:
		print "VM Swappiness not set to 0. Setting it to 0"
		sudo("echo 'vm.swappiness = 0' >> /etc/sysctl.conf")	
	
	
	#On each node, make sure that ulimit is set to 256000 (sysctl -n fs.file-max should return 256000)
	output =run('sysctl -n fs.file-max')
	if output=='256000':
		print "Ulimit is set to 256000"
	else:
		print "Ulimit not set to 256000 Setting it to 256000"
		sudo("echo 'fs.file-max=256000' >> /etc/sysctl.conf")	

	#On each node, disable ipv6 (check first and if it is enabled then disable it)
	output = sudo("echo 'net.ipv6.conf.all.disable_ipv6=1' >> /etc/sysctl.conf")

	#On each node, set the nprocs limit to 32000 (edit /etc/security/limits.d/90-nproc.conf and set to 32000) 
	output=sudo("echo '32000' >> /etc/security/limits.d/90-nproc.conf")



user = getpass.getuser()
hostname = 'localhost'
host = user + '@' + hostname
#host='ec2-user@localhost'
with settings(host_string=host):
	#os_detail = str(sudo('cat /etc/issue'))
	#os_version = re.findall("\d+", os_detail)
	#version = int(os_version[0])
	#test()
	#resp = fabric.operations.prompt("Your detected OS version is "+str(os_version[0])+"."+str(os_version[1])+" Do you want to proceed?")
	version=7
	resp = 'y'
	if resp.lower().startswith('y'):
		if version < 7:
			sys_checks(hugePage= False)
			install_rh6()
		else:
			sys_checks()
			install_rh7()
