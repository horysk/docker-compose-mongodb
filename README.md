# docker-compose-mongodb
1)启动所有mongodb,configsrv,mongoos实例，这样可以获取主机名和IP地址；
2）通过start.sh获取容器的ip，并配置副本集；
3）通过start.sh配置分片；
4）通过start.sh配置mongos路由;
5）可通过docker-compose scale configsrv=3,弹性config,mongos伸缩；
6）弹性伸缩shd，后续会完善....
