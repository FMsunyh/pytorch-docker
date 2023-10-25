FROM nvcr.io/nvidia/pytorch:21.07-py3

ENV ROOT=/workspace
WORKDIR /workspace

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
COPY  ./requirements_maile.txt /opt/requirements_maile.txt

RUN /opt/conda/bin/conda create -n env python=3.8 -y
RUN --mount=type=cache,target=/cache --mount=type=cache,target=/root/.cache/pip \
  # aria2c -x 5 --dir /cache --out torch-2.0.1-cp310-cp310-linux_x86_64.whl -c \
  # https://download.pytorch.org/whl/cu118/torch-2.0.1%2Bcu118-cp310-cp310-linux_x86_64.whl && \
  source activate env \


  # && pip install /cache/torch-2.0.1-cp310-cp310-linux_x86_64.whl torchvision --index-url https://download.pytorch.org/whl/cu118 \
  && pip install -r /opt/requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple \
  && pip install -r /opt/requirements_maile.txt -i https://pypi.tuna.tsinghua.edu.cn/simple
  # && pip install -U openmim mim install mmcv-full==1.7.0

RUN  /opt/conda/envs/env/bin/jupyter server --generate-config

RUN echo 'source activate env' >>  /root/.bashrc

EXPOSE 22
EXPOSE 8889

COPY  ./src/server_app.sh /opt/server_app.sh
COPY  ./src/jupyter_server_config.json /root/.jupyter/jupyter_server_config.json

STOPSIGNAL SIGINT
ENTRYPOINT ["/bin/bash","/opt/server_app.sh"]
# CMD ["/usr/sbin/sshd","-D"]
