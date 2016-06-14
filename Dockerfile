FROM centos

RUN yum -y install epel-release

RUN yum repolist

RUN yum -y install perl cpan make gcc gcc-c++ wget mysql-devel 	openssl openssl-devel  tcl tcl-devel openssh-server

RUN wget https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm  --no-check-certificate -O /usr/local/bin/cpanm && \
	chmod +x  /usr/local/bin/cpanm

ENV "PERL_CPANM_OPT" "--mirror http://mirrors.163.com/cpan/"

RUN cpanm -f Test::More Compress::Raw::Zlib Digest::MD5 \
	IO::Compress::Gzip Net::Ping Hijk inc::Module::Install Env 

RUN cpanm DBD::mysql

RUN cpanm Mojolicious
RUN cpanm IO::AIO MogileFS::Server MogileFS::Client MogileFS::Utils

# 指定版本Sys::Syscall 否则文件无法保存多个副本
RUN cpanm BRADFITZ/Sys-Syscall-0.23.tar.gz

RUN yum install -y vim net-tools

RUN useradd mogile

# 配置ssh
 RUN mkdir -p /var/run/sshd
 RUN rm -f /etc/ssh/ssh_host* \
     && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' \
     && ssh-keygen -t dsa -f /etc/ssh/ssh_host_dsa_key -N ''\
     && ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key -N '' \
     && ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ''
 RUN mkdir -p /root/.ssh/ && touch /root/.ssh/authorized_keys
 
 RUN echo '#!/bin/bash' >> /run.sh && echo '/usr/sbin/sshd -D' >> /run.sh
 RUN chmod 755 /run.sh
 
 CMD ["/run.sh"]

