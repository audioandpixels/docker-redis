FROM phusion/baseimage:0.9.15
MAINTAINER Jason Cox <jason@audioandpixels.com>

# Disable SSH and existing cron jobs
RUN rm -rf /etc/service/sshd /etc/my_init.d/00_regen_ssh_host_keys.sh /etc/cron.daily/dpkg /etc/cron.daily/apt \
           /etc/cron.daily/passwd /etc/cron.daily/upstart /etc/cron.weekly/fstrim

# Ensure UTF-8 locale
COPY locale /etc/default/locale
RUN  DEBIAN_FRONTEND=noninteractive locale-gen en_US.UTF-8
RUN  DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Update APT
RUN DEBIAN_FRONTEND=noninteractive apt-get update

# Install redis
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server

# Clean up APT and temporary files
RUN DEBIAN_FRONTEND=noninteractive apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Configure redis
COPY ./redis.conf /etc/redis/redis.conf

# Use wrapper scripts to start redis and cron
COPY scripts /data/scripts
RUN  chmod -R 755 /data/scripts

# Enable redis
RUN  mkdir -m 755 -p /etc/service/redis
COPY runit/redis /etc/service/redis/run
RUN  chmod 755 /etc/service/redis/run

# Configure syslog-ng for redis
RUN echo 'destination redis { file("/var/log/redis.log"); };' >> /etc/syslog-ng/syslog-ng.conf
RUN echo 'filter f_redis { facility(local0); };' >> /etc/syslog-ng/syslog-ng.conf
RUN echo 'log { source(s_src); filter(f_redis); destination(redis); };' >> /etc/syslog-ng/syslog-ng.conf

# Adjust overcommit memory for redis
RUN sysctl vm.overcommit_memory=1

# Start with cron and services
CMD ["/sbin/my_init"]

# Keep Redis log and storage outside of union filesystem
VOLUME ["/var/log/", "/var/lib/redis"]

# Expose the port and run it
EXPOSE 6379