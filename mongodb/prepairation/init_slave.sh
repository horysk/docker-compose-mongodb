#!/bin/bash
mongo --port 27107 --host $1 admin<<EOF
rs.add("$2:27107");
rs.status();
exit;
EOF
