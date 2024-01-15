# pytorch-docker

## Update log
- 升级torch 2.1.0

## 环境
- [base image](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-23-02.html#rel-23-02)
- python 3.10.12
- pytorch 2.1.0
- JupyterLab 2.3.2


## SSH配置
用户名： root
密码：l6y#VJWJA4LGr1eI
端口：22

## jupyterlab配置
端口：8889
密码：hdn3tTBzKZ&g4IBM

## filebrowser配置
用户名：admin
密码：admin
端口：8080

## 测试
```vim
import torch
torch.cuda.is_available()
torch.__version__
```


## 设置jupyterlab密码
```bash
jupyter server password
```
生成 jupyter_server_config.json 文件，用copy的方式，复制到镜像中