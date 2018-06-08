#!/bin/bash
echo sharding....
mongo --host 127.0.0.1 --port 27107 admin <<EOF
db.runCommand( { addshard : "sh1/$@",name:"shd1"} )
EOF
