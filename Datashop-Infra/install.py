import time
import shutil
import os
from fabric.context_managers import settings
from fabfile import test, sys_checks,install	

# Function that calls all the fabric functions to perform varios system checks 

def fabric_func():
	
	host="akif@localhost"
	with settings(host_string=host):
		test()
		install()

def main():

	fabric_func()

	'''user = os.getenv("SUDO_USER")
	if user is None:
		print "This program needs 'sudo': run it with sudo access"
		exit()
	else:
	'''		
	
if __name__ == '__main__': main()