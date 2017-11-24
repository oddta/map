FROM registry.access.redhat.com/rhel7-atomic
MAINTAINER Odd Tangen <odd.tangen@icloud.com>

COPY epel.repo /etc/yum.repos.d

RUN microdnf --enablerepo=rhel-7-server-rpms \
install openssl gperftools-libs nginx rsync git wget;\
microdnf clean all

RUN rm -rf /usr/share/nginx/html/*
#
# Clone the conf files into the docker container
 
#
COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/
COPY wg.sh /
COPY nginx.sh /

# Rights mangling for running with random uid in OCP
RUN chmod g+rwx -R /var; \
chmod g+rwx -R /run; \
chown root.root -R /var/log; \
chown root.root -R /etc/nginx; \
chmod g+rwx -R /etc; \
chown root.root -R /var/lib/nginx; \
chmod 770 /nginx.sh
chmod 770 /wg.sh

RUN userdel -f nginx;

EXPOSE 8888

ENTRYPOINT ["/nginx.sh"]
CMD ["start"]