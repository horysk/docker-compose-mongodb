#!/bin/bash
#set -x
set -eo pipefail
shopt -s nullglob

echo "$(tput setaf 2)" "Shutting down..." "$(tput sgr0)"
docker-compose down
#echo "$(tput setaf 2)" "Deleting libs and logs..." "$(tput sgr0)"
#for dir in ./employees_*; do
#    if [[ "$dir" =~ employees_(master|slave_.*) ]]; then
#        read -r -p "Are u sure to delete \"$dir/log\" and \"$dir/lib\" ? (y/n): " choice
#        if [[ "$choice" == "y" ]]; then
#            rm -rf "./$dir/log"
#            rm -rf "./$dir/lib"
#        fi
#    fi
#done

#mongodb
sed -i "/^security/d" ./mongodb/conf.d/mongo.conf
sed -i "/^  keyFile/d" ./mongodb/conf.d/mongo.conf
sed -i "/^  authorization/d" ./mongodb/conf.d/mongo.conf
echo "#security:" >>./mongodb/conf.d/mongo.conf
echo "#  keyFile: /usr/local/mongo/conf/mongo.key" >>./mongodb/conf.d/mongo.conf
echo "#  authorization: enabled" >>./mongodb/conf.d/mongo.conf

#confsrv
sed -i "/^security/d" ./configsrv/conf.d/mongo.conf
sed -i "/^  keyFile/d" ./configsrv/conf.d/mongo.conf
sed -i "/^  authorization/d" ./configsrv/conf.d/mongo.conf
echo "#security:" >>./configsrv/conf.d/mongo.conf
echo "#  keyFile: /usr/local/mongo/conf/mongo.key" >>./configsrv/conf.d/mongo.conf
echo "#  authorization: enabled" >>./configsrv/conf.d/mongo.conf

#mongoos
sed -i "/^security/d" ./mongoos/conf.d/mongo.conf
sed -i "/^  keyFile/d" ./mongoos/conf.d/mongo.conf
echo "#security:" >>./mongoos/conf.d/mongo.conf
echo "#  keyFile: /usr/local/mongo/conf/mongo.key" >>./mongoos/conf.d/mongo.conf

echo "$(tput setaf 2)" "Done!" "$(tput sgr0)"
