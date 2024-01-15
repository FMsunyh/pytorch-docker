# pytorch 1.14.0

## 环境
- [base image](https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/rel-23-02.html#rel-23-02)
- python 3.8
- pytorch 1.14.0
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

## 镜像 pytorch:1.14.0

### Update log
- 升级torch 1.14.0

### 拉取镜像
```bash
sudo docker pull registry.cn-shenzhen.aliyuncs.com/ai_base/pytorch:1.14.0
```

### 启动容器
```bash
sudo docker run --gpus all -it  -p 8889:8889 9090:22  -v ./data:/data --rm registry.cn-shenzhen.aliyuncs.com/ai_base/pytorch:pytorch:1.14.0
```

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