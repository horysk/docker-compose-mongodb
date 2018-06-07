#!/bin/bash
mongo $1 --port 27107 admin <<EOF
db.runCommand( { addshard : "sh1/$2",name:"shard1"} )
EOF
