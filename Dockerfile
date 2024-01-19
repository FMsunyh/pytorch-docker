FROM nvcr.io/nvidia/pytorch:22.05-py3

# set time
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV ROOT=/workspace
WORKDIR /workspace

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && \
  # we need those
  apt-get install -y openssh-server unrar lrzsz tree net-tools htop iotop iftop sysstat dstat
#  nethogs cacti pv iperf figlet lsof smartmontools fping nmap fio   monit ntpdate

USER root

RUN echo 'root:l6y#VJWJA4LGr1eI' | chpasswd 

##config ssh
RUN echo 'Port 22' >> /etc/ssh/sshd_config 
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config
# RUN echo 'service ssh start' >>  /root/.bashrc
RUN mkdir /var/run/sshd

# 镜像中已经有conda
# RUN echo 'export PATH=$PATH:/opt/conda/bin' >>  /root/.bashrc

COPY  ./requirements.txt /opt/requirements.txt
RUN --mount=type=cache,target=/cache --mount=type=cache,target=/root/.cache/pip \
  pip install -r /opt/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple 

COPY  ./src/server_app.sh /opt/server_app.sh
COPY ./data/filebrowser  /opt/filebrowser

COPY ./data/mnist  /mnist-example

# config jupyter
RUN  jupyter notebook --generate-config
COPY  ./src/jupyter_notebook_config.json /root/.jupyter/jupyter_notebook_config.json
RUN echo "c.NotebookApp.notebook_dir ='/'" >>  /root/.jupyter/jupyter_notebook_config.py


EXPOSE 22
EXPOSE 8889
EXPOSE 8080
STOPSIGNAL SIGINT
ENTRYPOINT ["/bin/bash","/opt/server_app.sh"]
# CMD ["/usr/sbin/sshd","-D"]
