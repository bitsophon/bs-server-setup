server {
	listen [::]:80;
	listen 80;

	# The host name to respond to
	server_name	 bitsophon.com www.bitsophon.com;
	
	# Enable SSL
	# include h5bp/directive-only/ssl.conf;
	
	# ssl_certificate /etc/nginx/certs/www.bitsophon.com.crt;
	# ssl_certificate_key /etc/nginx/certs/www.bitsophon.com.key;

	# Include the basic h5bp config set
	#include h5bp/basic.conf;
	include h5bp/directive-only/x-ua-compatible.conf;
	include h5bp/location/expires.conf;
	
	# Serve static files
	root /home/centos/www;
	index index.html;
	charset utf-8;
	access_log  /home/centos/wwwlogs/www.bitsophon.com.log  main buffer=32k;
}