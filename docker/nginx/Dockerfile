# Custom Nginx package based on CentOS 7 and official repos

# Base this image on our CentOS 7
FROM bitsophon/centos7:latest

# Add the official Nginx yum repos
ADD nginx-centos7.repo /etc/yum.repos.d/

# Create another user that will run nginx
RUN groupadd -r nginx && useradd -r -g nginx nginx

# Install tar, buildtools and git
RUN yum install -y nginx

# Copy configuration
RUN rm -rf /etc/nginx
COPY config /etc/nginx/

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/var/log/nginx"]

# Define working directory.
WORKDIR /etc/nginx

# Define default command.
CMD ["nginx"]

# Expose ports.
EXPOSE 80
EXPOSE 443