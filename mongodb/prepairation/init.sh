#!/bin/bash
mongo --port 27107 --host $1 admin<<EOF
rs.initiate();
rs.add("$1:27107");
rs.status();
exit;
EOF
