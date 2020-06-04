FROM centos:latest

LABEL maintainer="sshfortress.com"

# instal dependencies
RUN yum -y install libnsl mysql
RUN mkdir -p /etc/ssh/license
COPY audit_sec.sql /root
COPY init.sh /root
RUN chmod +755 /root/init.sh
ADD sshfortress-1.7.2/ssh /usr/bin
RUN mkdir -p  /var/empty/ 
ADD sshfortress-1.7.2/sshd /usr/sbin
ADD sshfortress-1.7.2/ssh-keygen /usr/bin 
ADD sshfortress-1.7.2/sshd_config /etc/ssh 
ADD sshfortress-1.7.2/sshd.init /etc/init.d
RUN chmod 755 /etc/init.d/sshd.init 
RUN useradd sshd -s /sbin/nologin -d /var/empty/sshd
RUN /usr/bin/ssh-keygen -A 
EXPOSE 22 
CMD ["/usr/sbin/sshd", "-D"]

