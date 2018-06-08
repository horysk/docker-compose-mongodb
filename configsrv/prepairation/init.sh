#!/bin/bash
mongo --port 27107 --host $1 admin<<EOF
config = {_id: 'config', members: [{_id: 0, host: '$1:27107'}]};
rs.initiate(config);
rs.status();
exit;
EOF
