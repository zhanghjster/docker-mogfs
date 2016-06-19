FROM centos

RUN yum -y install epel-release

RUN yum repolist

RUN yum -y install perl cpan make gcc gcc-c++ wget mysql-devel 	openssl openssl-devel  tcl tcl-devel openssh-server \
    vim net-tools

RUN wget https://raw.githubusercontent.com/miyagawa/cpanminus/master/cpanm  --no-check-certificate -O /usr/local/bin/cpanm && \
	chmod +x  /usr/local/bin/cpanm

ENV "PERL_CPANM_OPT" "--mirror http://mirrors.163.com/cpan/"

RUN cpanm -f Test::More Compress::Raw::Zlib Digest::MD5 \
	IO::Compress::Gzip Net::Ping Hijk inc::Module::Install Env 

RUN cpanm -f DBD::mysql

RUN cpanm Mojolicious

RUN cpanm -f IO::AIO 
RUN cpanm -f MogileFS::Server 
RUN cpanm -f MogileFS::Client 
RUN cpanm -f MogileFS::Utils

# 指定版本Sys::Syscall 否则文件无法保存多个副本
RUN cpanm BRADFITZ/Sys-Syscall-0.23.tar.gz

RUN useradd mogile

COPY mogilefs-db-init.sh /home/mogile/mogilefs-db-init.sh
RUN chmod +x /home/mogile/mogilefs-db-init.sh && chown mogile /home/mogile/mogilefs-db-init.sh

RUN yum -y install mysql

RUN yum -y install nmap

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh 
ENTRYPOINT ["/entrypoint.sh"]
