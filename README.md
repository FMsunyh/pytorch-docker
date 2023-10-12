# pytorch-docker

## Update log
- 升级JupyterLab 4.0.6

## 环境
- python 3.10 
- pytorch 2.0.1
- JupyterLab 4.0.6

## 拉取镜像
```bash
sudo docker pull registry.cn-shenzhen.aliyuncs.com/ai_base/sd-webui-1.6.0:100
```

## 启动容器
```bash
sudo docker run --gpus all -it  -p 8889:8889 9090:22  -v ./data:/data --rm registry.cn-shenzhen.aliyuncs.com/ai_base/sd-webui-1.6.0:100
```

## SSH配置
用户名： root
密码：l6y#VJWJA4LGr1eI
端口：22

## jupyterlab配置
端口：8889
密码：hdn3tTBzKZ&g4IBM


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