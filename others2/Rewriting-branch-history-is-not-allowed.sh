full_name=$1
branch=$2
if  [ "$branch" != "master" ] && [ "$branch" != "development"  ];
   then
      echo $branch
      curl -XPOST --user "${credential}" -H "Content-Type: application/json" -d '      {
               "kind":"force",
               "users":[
                  
               ],
               "links":{
                  "self":{
                     "href":"https://api.bitbucket.org/2.0/repositories/'$full_name'/branch-restrictions"
                  }
               },
               "pattern":"'$branch'",
               "value":null,
               "branch_match_kind":"glob",
               "groups":[
                  
               ]
            }' https://api.bitbucket.org/2.0/repositories/$full_name/branch-restrictions
   fi