FROM registry.cn-hangzhou.aliyuncs.com/huaching_prod/basejdk8
ADD apache-rocketmq/   /home/apache-rocketmq/
COPY entrypoint.sh /home/entrypoint.sh
COPY rocketmq-console-ng-1.0.0.jar /home/rocketmq-console-ng-1.0.0.jar
WORKDIR /home/
CMD [ "/home/entrypoint.sh" ] 
