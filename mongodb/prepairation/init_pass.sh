#!/bin/bash
mongo --port 27107 --host 127.0.0.1 admin<<EOF
db.createUser(
  {
    user: "mongoAdmin",
    pwd: "abc123",
    roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
  }
);
exit;
EOF
