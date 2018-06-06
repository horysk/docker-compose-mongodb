#!/bin/bash
mongo --port 27107 --host $1 admin<<EOF
rs.add("$2:27107");
rs.status();
cfg = rs.conf();
cfg.members[0].host = "$1:27107";
rs.reconfig(cfg);
rs.status();
exit;
EOF
