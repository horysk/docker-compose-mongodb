# docker-compose-mongodb
1)启动所有shdmongodb,configsrv,mongoos服务，这样可以获取主机名和IP地址；
docker-compose up --build
docker-compose scale configsrv=3
docker-compose scale shdmongodb=3
docker-compose scale mongoos=3
==>
docker-compose up --scale configsrv=3
2）通过start.sh获取容器的ip，并配置mongodb,configsrv副本集；
./start.sh
3）通过start.sh配置分片；
4）通过start.sh配置mongos路由;
5）可通过docker-compose scale configsrv=3,弹性config,mongos伸缩；
6）弹性伸缩shard，后续会完善....
可先手动处理或修改docker-compose.yml文件，增加一个分片副本集。
