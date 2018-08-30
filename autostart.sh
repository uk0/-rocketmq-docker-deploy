#Function: rocketmq for docker deploy auto 
#Author: zhangjianxin
#Time: 2018-08-30
#!/bin/bash
# y 安全 n 不安全
safety="n"
bashpath=$(cd `dirname $0`; pwd)
brokerName=dev_rocketmq_4.3.0
brokerClusterName=${brokerName}_cls
tag=$(cat /dev/urandom | head -n 10 | md5sum | head -c 10)
listenPort=10911
namesvcPort=9876
consolePort=$(($namesvcPort + 1))
haPort=$(($listenPort + 1))
vipPort=$(($listenPort - 2))
#########################setting#######################
URL="http://ip.cn/"
Result=`curl -o /dev/null -s -m 10 --connect-timeout 10 -w %{http_code} $URL`
Test=`echo $Result`
if [ "$Test" == "200" ]
then
	curl -s -o $bashpath/ip.html ${URL}
	echo "search inter ip "
           ip=$(cat ${bashpath}/ip.html  | sed  's/：/ /g' | awk '{print$3}')
	if [ "$safety" = "y" ]
	then
	   ip=`ifconfig eth0|grep inet|grep -v 127.0.0.1|grep -v inet6|awk '{print $2}'|tr -d "addr:"`
	fi

	echo $ip

        sed  "s/HOSTIP/${ip}/g" $bashpath/apache-rocketmq/broker.p > $bashpath/apache-rocketmq/broker.p1

	sed  "s/HOSTIP/${ip}/g"  $bashpath/entrypoint.sh.template >  $bashpath/entrypoint.sh
	sed -i "s/NAMESVCPORT/${namesvcPort}/g" $bashpath/entrypoint.sh
	sed -i "s/CONSOLEPORT/${consolePort}/g" $bashpath/entrypoint.sh

	#BKNAME
	sed -i "s/BKNAME/${brokerName}/g" $bashpath/apache-rocketmq/broker.p1
        sed -i "s/LPORT/${listenPort}/g" $bashpath/apache-rocketmq/broker.p1
 	sed -i "s/HAPORT/${haPort}/g" $bashpath/apache-rocketmq/broker.p1
	sed -i "s/CLASTNAME/${brokerClusterName}/g" $bashpath/apache-rocketmq/broker.p1
	#NAMESVCPORTS
	sed -i "s/NAMESVCPORTS/${namesvcPort}/g" $bashpath/apache-rocketmq/broker.p1

	rm $bashpath/ip.html
	chmod +x $bashpath/entrypoint.sh

	docker build -t registry.cn-hangzhou.aliyuncs.com/huaching_prod/rocketmq:4.3.0.${tag} .
	# rocketmq namesvc   console  broker port
	docker run -d -p ${namesvcPort}:9876 -p ${consolePort}:${consolePort} -p ${listenPort}:${listenPort}  -p ${haPort}:${haPort} -p ${vipPort}:${vipPort}  registry.cn-hangzhou.aliyuncs.com/huaching_prod/rocketmq:4.3.0.${tag}
fi
