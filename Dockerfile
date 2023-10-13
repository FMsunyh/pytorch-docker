FROM fmsunyh/sd-auto:75

ENV ROOT=/stable-diffusion-webui
WORKDIR ${ROOT}

ENV DEBIAN_FRONTEND=noninteractive PIP_PREFER_BINARY=1

# RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && \
  # we need those
  apt-get install -y openssh-server vim  aria2

USER root

RUN echo 'root:l6y#VJWJA4LGr1eI' | chpasswd 

##config ssh
RUN echo 'Port 22' >> /etc/ssh/sshd_config 
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config
# RUN echo 'service ssh start' >>  /root/.bashrc


RUN echo 'export PATH=$PATH:/opt/conda/bin' >>  /root/.bashrc

RUN mkdir /var/run/sshd

COPY  ./requirements.txt /opt/requirements.txt

RUN --mount=type=cache,target=/cache --mount=type=cache,target=/root/.cache/pip \
  pip install -r /opt/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple 

RUN  jupyter server --generate-config

EXPOSE 22
EXPOSE 7860
EXPOSE 8889

COPY  ./src/entrypoint.sh /opt/entrypoint.sh
COPY  ./src/server_app.sh /opt/server_app.sh
COPY  ./src/jupyter_server_config.json /root/.jupyter/jupyter_server_config.json

WORKDIR ${ROOT}
STOPSIGNAL SIGINT
ENTRYPOINT ["/bin/bash","/opt/entrypoint.sh", "/opt/server_app.sh"]
# CMD ["/usr/sbin/sshd","-D"]
