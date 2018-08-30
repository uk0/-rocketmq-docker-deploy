##  RocketMQ deploy ... Docker

*  1.运行autostart.sh 前请检查脚本内的安全阀,主要功能是为了开通外网和内网访问。
*  2.该脚本在阿里云服务器通过运行,运行成功后，会提示暴露哪些端口[仅对外网有效果,内网开放相应的安全组即可]。
*  3.默认启动RocketMQ 4.3.0 以及 低版本的 RocketMQ Console 
*  4.本脚本是业余时间做的验证，如果有人使用请在`issues` 告诉我我可以继续更新，以便支持集群部署。

## 注意事项

```bash
#Dockerfile内的 From 可以替换
        openjdk8
        jdk1.8
```

## 个人博客 firsh.me


### update time 2018年08月30日21:05:01
