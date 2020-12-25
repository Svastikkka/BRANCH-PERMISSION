#!/bin/bash
full_name=$1
curl -XPOST --user "${credential}" -H "Content-Type: application/json" -d '      {
         "kind":"restrict_merges",
         "users":[
            
         ],
         "links":{
            "self":{
               "href":"https://api.bitbucket.org/2.0/repositories/'$full_name'/branch-restrictions"
            }
         },
         "pattern":"master",
         "value":null,
         "branch_match_kind":"glob",
         "groups":[
            
         ]
      }' https://api.bitbucket.org/2.0/repositories/$full_name/branch-restrictions