# Proxy server for the site domains based on our custom nginx
FROM bitsophon/nginx:latest

# Copy sites-enabled and the wrapper script
# COPY sites-available/* /etc/nginx/sites-available/
COPY wrapper.sh /home/centos/
RUN mkdir -p /etc/nginx/sites-enabled/

RUN chmod +x /home/centos/wrapper.sh

# Define mountable directories.
VOLUME ["/etc/nginx/certs", "/etc/nginx/auth", "/etc/nginx/sites-available", "/var/log/nginx", "/home/centos/wwwlogs", "/home/centos/www"]

# Define working directory.
WORKDIR /etc/nginx

# Expose ports.
EXPOSE 80
EXPOSE 443

# Define default command.
    CMD ["/home/centos/wrapper.sh"]
