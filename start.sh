#!/bin/bash
#set -x
set -eo pipefail
shopt -s nullglob

declare i=1
declare -a con_ip
declare con_ips=""

# 将接收到的参数使用ANSI颜色打印到控制台
aprint(){
    echo "$(tput setaf 2)>>> $1 $(tput sgr0)"
}

aprint "Docker Compose starting..."
#docker-compose up -d

#配置configsrv
for c_id in $(docker-compose ps | sed -n '3,$p' | grep configsrv | sed -n '/Up/p' | awk '{print $1}'); do
    con_ips=`docker container inspect "$c_id" | grep -o -E '\"IPAddress": ".+"' | sed "s/\"//g" | sed "s/\://g" | awk '{print $2}'`
    con_ip+=( "$con_ips" ) 
    if [[ "$c_id" =~ configsrv_.* ]]; then
        echo "configuring $c_name $c_id ..."
        if [[ "$i" -eq 1 ]]; then
        	docker exec "$c_id" /init.sh ${con_ip[0]}
	else
		docker exec "$c_id" /init_slave.sh ${con_ip[0]} ${con_ip[i]}
	fi
	let i=i+1
    fi
    sleep 1
 done

#配置 sharesrv
for c_id in ${container_id[@]}; do
 for c_name in ${service_name[*]}; do
    if [[ "$c_name" = "mongodb" ]]; then
        echo "configuring $c_name $c_id ..."
        docker exec "$c_id" /init.sh 
        break
    fi
 done
done

#配置mongoos
for c_id in ${container_id[@]}; do
 for c_name in ${service_name[*]}; do
    if [[ "$c_name" = "mongoos" ]]; then
        echo "configuring $c_name $c_id ..."
        docker exec "$c_id" /init.sh
        break
    fi
 done
done
sleep 7

#aprint "Initializing MHA configuration..."
#docker-compose exec manager /preparation/bootstrap.sh ${service_name[*]}

aprint "Done!"
