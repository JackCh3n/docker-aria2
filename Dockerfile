FROM centos:centos8

WORKDIR /root/

# 复制文件
COPY aria2 /etc/aria2

# 环境准备
RUN cd /etc/yum.repos.d/ \
    && sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-* \
    && yum clean all \
    && yum makecache \
    && yum update -y

# 安装python3.9
RUN yum -y install python39 wget unzip curl \
    && ln -s /usr/bin/python3.9 /usr/bin/python \
    && ln -s /usr/lib/python3.9/site-packages/pip /usr/bin/pip \
    && python -V \
    && python -m pip install --upgrade pip \
    && pip -V

# aria2
RUN touch /etc/aria2/aria2.session \
    && touch /etc/aria2/aria2.log \
    && cd /etc/aria2/ \
    && bash install.sh \
    && echo "aria2c --conf-path=/etc/aria2/aria2.conf" >> /etc/rc.local \
    && aria2c --conf-path=/etc/aria2/aria2.conf -D
# 挂载
VOLUME /tmp /mnt/downloads