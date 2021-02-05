FROM centos:centos7

RUN yum -y install epel-release &&\
	yum -y install yum-utils git ansible wget nc nmap rsync tcpdump telnet traceroute nmon htop bind-utils nginx &&\
	yum clean all -y

RUN mkdir -p /opt/minio-client &&\
	cd /opt/minio-client &&\
	wget https://dl.minio.io/client/mc/release/linux-amd64/mc &&\
	ln -s /opt/minio-client/mc /usr/bin/mc

RUN mkdir -p /opt/oc-cli &&\
	cd /opt/oc-cli &&\
	wget https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz &&\
	tar xvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz &&\
	ln -s /opt/oc-cli/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/kubectl /usr/bin/kubectl &&\
	ln -s /opt/oc-cli/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/bin/oc

RUN mkdir -p /opt/workdir

RUN rm -rf /etc/nginx/nginx.conf

COPY nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/cache/nginx

# support running as arbitrary user which belogs to the root group
RUN chmod g+rwx /var/cache/nginx /var/run /var/log/nginx /opt/minio-client/mc /opt/oc-cli /opt/workdir &&\
	chmod -R g+w /etc/nginx

COPY entrypoint.sh /opt/workdir/entrypoint.sh

RUN chmod +x /opt/workdir/entrypoint.sh

WORKDIR /opt/workdir

CMD ["/bin/bash","-c","/opt/workdir/entrypoint.sh"]