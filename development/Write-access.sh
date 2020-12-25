#!/bin/bash
full_name=$1
curl -XPOST --user "svastikkkka:quwmaw-8beNni-tizxet" -H "Content-Type: application/json" -d '       {
         "kind":"push",
         "users":[
            {
               "display_name":"Dev Ops",
               "uuid":"{4ea6ff86-c6a9-48db-8e8f-e8da9d76411d}",
               "links":{
                  "self":{
                     "href":"https://api.bitbucket.org/2.0/users/%7B4ea6ff86-c6a9-48db-8e8f-e8da9d76411d%7D"
                  },
                  "html":{
                     "href":"https://bitbucket.org/%7B4ea6ff86-c6a9-48db-8e8f-e8da9d76411d%7D/"
                  },
                  "avatar":{
                     "href":"https://secure.gravatar.com/avatar/12108f67a1e10dd889ec5ba0ad9ad2fb?d=https%3A%2F%2Favatar-management--avatars.us-west-2.prod.public.atl-paas.net%2Finitials%2FDO-3.png"
                  }
               },
               "nickname":"Devops",
               "type":"user",
               "account_id":"5e25841fee264b0e74584805"
            }
         ],
         "links":{
            "self":{
               "href":"https://api.bitbucket.org/2.0/'$full_name'/testing/branch-restrictions"
            }
         },
         "pattern":"development",
         "value":null,
         "branch_match_kind":"glob",
         "groups":[
            
         ]
      }' https://api.bitbucket.org/2.0/repositories/$full_name/branch-restrictions