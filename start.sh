#!/bin/bash
#set -x
set -eo pipefail
shopt -s nullglob

declare i=1
declare -a shdcon_ip
declare -a shdcon_id
declare -a cfgcon_ip
declare -a cfgcon_id
declare -a oscon_ip
declare -a oscon_id
declare  cfgstr=""
declare con_ips=""

# 将接收到的参数使用ANSI颜色打印到控制台
aprint(){
    echo "$(tput setaf 2)>>> $1 $(tput sgr0)"
}

aprint "Docker Compose starting..."
#docker-compose up -d
#配置configsrv
for c_id in $(docker-compose ps | sed -n '3,$p' | grep configsrv | sed -n '/Up/p' | awk '{print $1}'); do
    cfgcon_id+=( "$c_id" )
    con_ips=`docker container inspect "$c_id" | grep -o -E '\"IPAddress": ".+"' | sed "s/\"//g" | sed "s/\://g" | awk '{print $2}'`
    cfgcon_ip+=( "$con_ips" ) 
    if [[ "$c_id" =~ configsrv_.* ]]; then
        echo "configuring  $c_id ..."
        if [[ "$i" -eq 1 ]]; then
        	docker exec "${cfgcon_id[0]}" /init.sh ${cfgcon_ip[0]}
	else
		docker exec "${cfgcon_id[0]}" /init_slave.sh ${cfgcon_ip[0]} $con_ips
	fi
	let i=i+1
    fi
    sleep 2
 done


#配置 sharesrv
i=1
for c_id in $(docker-compose ps | sed -n '3,$p' | grep shdmongodb | sed -n '/Up/p' | awk '{print $1}'); do
    shdcon_id+=( "$c_id" )
    con_ips=`docker container inspect "$c_id" | grep -o -E '\"IPAddress": ".+"' | sed "s/\"//g" | sed "s/\://g" | awk '{print $2}'`
    shdcon_ip+=( "$con_ips" )
    if [[ "$c_id" =~ shdmongodb_.* ]]; then
        echo "configuring $c_id ..."
        if [[ "$i" -eq 1 ]]; then
                docker exec "${shdcon_id[0]}" /init.sh ${shdcon_ip[0]}
        else
                docker exec "${shdcon_id[0]}" /init_slave.sh ${shdcon_ip[0]} $con_ips
        fi
        let i=i+1
    fi
    sleep 2
 done

#配置mongoos
echo "configuring mongoos..."
docker-compose stop mongoos

for ip in ${cfgcon_ip[@]} ; do
	cfgstr+="$ip:27107,"
done
cfgstr=`echo $cfgstr |sed 's/.$//'`
echo $cfgstr
sed -i "/^  configDB/d" ./mongoos/conf.d/mongo.conf
echo "  configDB: config/$cfgstr" >>./mongoos/conf.d/mongo.conf
#sed -i "s#^  configDB#  configDB: config/$cfgstr#" ./mongoos/conf.d/mongo.conf
docker-compose start mongoos 
 
sleep 2

#配置分片
cfgstr=""
for ip in ${shdcon_ip[@]} ; do
        cfgstr+="$ip:27107,"
done
cfgstr=`echo $cfgstr |sed 's/.$//'`

for c_id in $(docker-compose ps | sed -n '3,$p' | grep mongoos | sed -n '/Up/p' | awk '{print $1}'); do
    oscon_id+=( "$c_id" )
    con_ips=`docker container inspect "$c_id" | grep -o -E '\"IPAddress": ".+"' | sed "s/\"//g" | sed "s/\://g" | awk '{print $2}'`
    oscon_ip+=( "$con_ips" )
    if [[ "$c_id" =~ mongoos_.* ]]; then
        echo "configuring $c_id ..."
        docker exec "${oscon_id[0]}" /init.sh $cfgstr
    fi
    sleep 2
 done

aprint "Done!"
