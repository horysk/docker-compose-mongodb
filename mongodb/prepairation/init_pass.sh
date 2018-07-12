#!/bin/bash
mongo --port 27107 --host 127.0.0.1 admin<<EOF
db.createUser(

  {

    user: "shdAdmin",

    pwd: "fex456",

roles: [

      { role: "clusterAdmin", db: "admin" },

      { role: "userAdmin", db: "admin" }

    ]

  }

);
exit;
EOF
