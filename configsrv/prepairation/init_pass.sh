#!/bin/bash
mongo --port 27107 --host 127.0.0.1 admin<<EOF
db.createUser(

  {

    user: "clusterAdmin",

    pwd: "fex123",

roles: [

      { role: "root", db: "admin" },

      { role: "clusterAdmin", db: "admin" },

      { role: "userAdmin", db: "admin" }

    ]

  }

);
exit;
EOF
