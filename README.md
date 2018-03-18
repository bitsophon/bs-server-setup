# Launch instance
* Operating system:
	- Community AMIs: CoreOS Stable, HVM, 64-bit
	- To get the AMI, visit [https://coreos.com/os/docs/latest/booting-on-ec2.html] and get the AMI for the specific region ("us-east-1" in this case) and for HVM.
	- Current AMI (2015-11-25): `ami-00ebfc61` (CoreOS stable 766.5.0)
* Instance Details - Advanced:
	- Enable termination protection: YES (optional)
	- Network: choose the id of the `vpc-d299a7b7` VPC.
	- User data (As text): copy the contents of the `config/cloud-config/api-without-etcd` file
* Storage:
	- Root partition (on EBS):
		- Size: 15GB
		- Volume Type: "General Purpose (SSD)"
		- Delete on Termination: YES
* Tag:
	- Key: "Name" - Value: "bitsophon dev #" (# = number) (or "bitsophon staging #")
	- Key: "type" - Value: "bs-dev" (or "bs-staging")
* Security group:
	- Select the existing `zsg-bf2c76db` 
* Key pair:
	- Select `universal-dev-1` 

#generating key
 
    $ mkdir ~/.ssh
    $ chmod 700 ~/.ssh
    $ ssh-keygen -t rsa
    $ chmod 600 ~/.ssh/id_rsa
    $ ssh-add ~/.ssh/id_rsa
    $ ssh-keygen -R 104.236.144.163

#remote copy to local

	$ scp -r core@188.166.2.198:~/.ssh/id_rsa ~/.ssh/
	$ scp -r core@188.166.2.198:~/.ssh/id_rsa.pub ~/.ssh/
	$ scp -i ~/.ssh/universal-dev-1.pem -r universal-dev-1@35.197.57.202:~/service ~/service
	$ scp -i ~/.ssh/universal-dev-1.pem universal-dev-1@35.197.57.202:/home/core.tar.gz ~/core.tar.gz

#Copy the local Public Key to add it to remote

	$ cat ~/.ssh/id_rsa.pub | ssh core@35.197.57.202  "mkdir -p ~/.ssh && cat >>  ~/.ssh/authorized_keys"
	$ scp -i ~/.ssh/universal-dev-1.pem -r ./initials.json universal-dev-1@35.197.57.202:/home/core/security/datasets/initials.json

# Copy provisioning file to remote

    $ tar -czvpf core.tar.gz folderToCompress
    # tar -xzvf core.tar.gz folderToExtract
    $ scp -i ~/.ssh/universal-dev-1.pem core.tar.gz universal-dev-1@35.197.57.202:/home/universal-dev-1/core.tar.gz
    $ sudo tar xpf core.tar.gz
    
# SSH

	# www.bitsophon.com
	# universal-dev-1.pem
	$ ssh universal-dev-1@35.197.57.202 

# Setup server

Connect via SSH with user `core`.

# Production database only can be accessed via ssh tunnel

Execute:

	# login api production server for instance:
	$ ssh universal-dev-1@35.197.57.202

	# connect database server
	$ ssh -i ~/.ssh/universal-dev-1.pem universal-dev-1@52.25.250.132
	$ ssh -i ~/.ssh/universal-dev-1.pem universal-dev-1@35.163.220.252
	$ ssh -i ~/.ssh/universal-dev-1.pem universal-dev-1@35.197.57.202
	
# Dockerize
	
Create a user group for docker to run without sudo

	$ sudo usermod -aG docker bitsophon

First of all, build dependencies (third-party packages and the proxy server):

	# centos
	$ sh build-centos.sh
	
	# io.js
	$ sh build-iojs.sh
	
	# nginx
	$ sh build-nginx.sh
	
	# build-proxy
	$ sh build-proxy.sh
	
	# build bitsophon-www,xxx

Then build the application server with:

	# sh build-app.sh [branch]
	$ sh build-app.sh master

Once completed, you should be able to see all generated images with `docker images`:

	REPOSITORY             TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
    bitsophon/whalesay   latest              43ecac2ffeac        15 seconds ago      274.1 MB
    hello-world            latest              0a6ba66e537a        6 weeks ago         960 B
    docker/whalesay        latest              ded5e192a685        6 months ago        247 MB

	# Use the docker rmi to remove the bitsophon/whalesay and docker/whalesay images
	$ docker rmi -f docker/whalesay
	
	# run a docker container to test it
	$ docker run -it --name=whalesay bitsophon/whalesay:latest
	
	# run jenkins docker in docker build env
	$ docker run --privileged --dns 8.8.8.8 -d --name bs-ci-8080 -v /home/core/jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 -u root bitsophon/bitsophon-ci
	$ docker run --privileged --dns 8.8.8.8 -d --name jenkins -v /home/bitsophon/service:/var/jenkins_home -p 8081:8080 -u root johanhaleby/jenkins
	
	# examples
	$ docker run -a stdin -a stdout -i -t -v /home/bitsophon/mp1:/home/mp1 python:2 /bin/bash
	$ docker run -a stdin -a stdout -i -t bitsophon/xxx /bin/bash
To push the images to the docker repository use `sh push-image.sh imagename`, but before ensure you've logged in:

	# Log in (username & password, empty email)
	$ docker login --username=bitsophon
	
	# mkdir
	$ sudo mkdir -p /home/core/data/db /home/core/wwwlogs /home/core/security/auth /home/core/security/certs /home/core/security/credentials
	
	# Push all images
	$ sh push-image.sh bitsophon/centos7
	$ sh push-image.sh bitsophon/nginx
    $ sh push-image.sh bitsophon/iojs
    $ sh push-image.sh bitsophon/bs-base
    $ sh push-image.sh bitsophon/bs-proxy
    $ sh push-image.sh bitsophon/bs-app
 
run a docker image:

    $ docker run bitsophon/whalesay

delete all docker containers
    
    $ docker rm $(docker ps -a -q)
    
Check the status with:

	$ docker ps -a

Check the log in docker container with:

	$ docker logs -t CONTAINER_ID

Check the log using docker IMAGE_NAME:

	$ docker exec -i -t bs-proxy bash
	
Ensure the container `bs-proxy` is running. Enter into it with:

	$ docker exec -i -t bs-proxy bash
		
run with system service

To see the status of service launching, pull the images first (not required):

	$ docker pull bitsophon/bitsophon-proxy:latest
    $ docker run -v /home/core/data/db --name=bs-mongo-data busybox true
    $ docker run --name=bs-www bitsophon/bitsophon-www:latest

	# Move files and enable services
	$ sudo cp -v /home/core/services/bitsophon-*.service /etc/systemd/system
	$ sudo systemctl enable /etc/systemd/system/bitsophon-*.service
	$ sudo systemctl daemon-reload
	
	# disable services
	$ sudo systemctl disable bitsophon-*.service

Execute:

	# NOTE: Ensure bs-app and bs-proxy are configured correctly for optimal performances!
	$ sudo systemctl start bitsophon-proxy
	
	# To restart all
	$ sudo systemctl restart bitsophon-proxy
	$ sudo systemctl stop bitsophon-proxy
    $ sudo systemctl disable bitsophon-proxy

	# if any service fails please see for details:A dependency job for docker.service failed. See 'journalctl -xe' for details.
	$ systemctl status XXX.service
	$ journalctl -xn
	$ journalctl -f -u bitsophon-proxy.service
	# iptables -L -n
	# iptables -A INPUT -p tcp --dport 8388 -j ACCEPT
	# netstat -nlp | grep 1080