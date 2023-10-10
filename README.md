# pytorch-docker

## 环境
- python 3.10 
- pytorch 2.0.1

## 拉取镜像
```bash
sudo docker pull registry.cn-shenzhen.aliyuncs.com/ai_base/pytorch-21.07-py3:100
```

## 启动容器
```bash
sudo docker run --gpus all -it  -p 8889:8889 9090:22  -v ./data:/data --rm registry.cn-shenzhen.aliyuncs.com/ai_base/pytorch-21.07-py3:100
```

## SSH配置
用户名： root
密码：l6y#VJWJA4LGr1eI
端口：22

## jupyterlab配置
端口：8889
启动：
```bash
jupyter lab --no-browser --port=8889
```

## 测试
```vim
import torch
torch.cuda.is_available()
torch.__version__
```
