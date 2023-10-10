FROM nvcr.io/nvidia/pytorch:21.07-py3

WORKDIR /workspace
ENV ROOT=/workspace

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

RUN --mount=type=cache,target=/var/cache/apt \
  apt-get update && \
  # we need those
  apt-get install -y openssh-server vim 

USER root

RUN echo 'root:l6y#VJWJA4LGr1eI' | chpasswd 

##config ssh
RUN echo 'Port 22' >> /etc/ssh/sshd_config 
RUN echo 'PermitRootLogin yes' >>  /etc/ssh/sshd_config
# RUN echo 'service ssh start' >>  /root/.bashrc


RUN echo 'export PATH=$PATH:/opt/conda/bin' >>  /root/.bashrc

RUN  /opt/conda/bin/jupyter notebook --generate-config
# RUN  echo 'hdn3tTBzKZ&g4IBM' | /opt/conda/bin/jupyter notebook password

RUN mkdir /var/run/sshd

EXPOSE 22
EXPOSE 8889

COPY  ./server_app.sh /opt/server_app.sh
COPY  ./jupyter_notebook_config.json /root/.jupyter/jupyter_notebook_config.json

STOPSIGNAL SIGINT
ENTRYPOINT ["/bin/bash","/opt/server_app.sh"]
# CMD ["/usr/sbin/sshd","-D"]
