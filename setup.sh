#!/bin/bash
echo "Starting Fetching all JSON data"

WORKSPACE=([0]="svastikkka")
for i in ${WORKSPACE[@]}; 
do 
    #FETCH REPOS
    curl -u ${credential} 'https://api.bitbucket.org/2.0/repositories/'$i'/?pagelen=100&page=1&fields=next,values.links.branches.href,values.full_name'  > data.json
    echo $WORKSPACE; 

    full_name=( $(grep -o '"full_name": "[^"]*' data.json | grep -o '[^"]*$' ))
    for j in ${full_name[@]}; 
    do 
        echo $j;
        curl -u "${credential}" 'https://api.bitbucket.org/2.0/repositories/'$j'/refs/branches?pagelen=100&page=1&fields=next,values.name'  > branches.json
        
        branches=( $(grep -o '"name": "[^"]*' ./branches.json | grep -o '[^"]*$' ))
        for k in ${branches[@]}; 
        do 
            #MASTER  
            if  [ "$k" == "master" ];
            then
                if  grep -F  "development" branches.json;
                then
                    echo "$branch is found"
                    bash ./master/Check-the-last-commit-for-at-least-1-successful-build-and-no-failed-builds.sh $j
                    bash ./master/Merge-via-pull-request.sh $j
                    bash ./master/Write-access-none.sh $j
                    bash ./master/Deleting-this-branch-is-not-allowed.sh $j
                else
                    bash ./master/Merge-via-pull-request-everyone.sh $j
                    bash ./master/Check-the-last-commit-for-at-least-1-successful-build-and-no-failed-builds.sh $j
                    bash ./master/Write-access-devops.sh $j
                    bash ./master/Deleting-this-branch-is-not-allowed.sh $j
                    bash ./master/Require-task-to-be-completed.sh $j
                fi
            fi 

            if [ "$k" == "development"  ];
            then
                #DEVELOPMENT
                bash ./development/Check-for-at-least-1-approval.sh $j
                bash ./development/Check-for-unresolved-pull-request-tasks.sh $j
                bash ./development/Deleting-this-branch-is-not-allowed.sh $j
                bash ./development/Write-access.sh $j
                bash ./development/Check-the-last-commit-for-at-least-1-successful-build-and-no-failed-builds.sh $j

            fi
            # Please ignore this if
            if [ "$k" != "development"  ] && [ "$k" != "master"  ];
            then
                #OTHER
                bash ./other/Check-for-at-least-1-approval.sh $j
                bash ./other/Check-for-unresolved-pull-request-tasks.sh $j
                bash ./other/Check-the-last-commit-for-at-least-1-successfud-build-and-no-failed-builds.sh $j
                bash ./other/Deleting-this-branch-is-not-allowed.sh $j
                bash ./other/Rewriting-branch-history-is-not-allowed.sh $j
            fi
        done
    done
done