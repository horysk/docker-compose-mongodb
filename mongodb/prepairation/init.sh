#!/bin/bash
mongo --port 27001 --host $1 admin<<EOF
rs.initiate();
rs.add("$2:27017");
rs.status();
Fix hostname of primary.
cfg = rs.conf();
cfg.members[0].host = "$1:27017";
rs.reconfig(cfg);
rs.status();
exit;
EOF
