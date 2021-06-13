#!/bin/bash
echo "Starting Fetching all JSON data"
WORKSPACE=([0]="WORKSPACE")
# 
#test.sh is use for when we want add same credential to all other branches seprately
#
for i in ${WORKSPACE[@]}; 
do 
    count=1
    increment=1
    #FETCH REPOS
    while :
    do 
        if [[ "$(curl -u ${credential} 'https://api.bitbucket.org/2.0/repositories/'$i'/?pagelen=100&page='$count'&fields=next,values.links.branches.href,values.full_name')" == '{"values": []}' ]];
        then 
            curl -u ${credential} 'https://api.bitbucket.org/2.0/repositories/'$i'/?pagelen=100&page='$count'&fields=next,values.links.branches.href,values.full_name'
            echo "Done"
            exit 0
        fi 
        curl -u ${credential} 'https://api.bitbucket.org/2.0/repositories/'$i'/?pagelen=100&page='$count'&fields=next,values.links.branches.href,values.full_name'  > data.json
        echo $j;
        full_name=( $(grep -o '"full_name": "[^"]*' data.json | grep -o '[^"]*$' ))
        for j in ${full_name[@]}; 
        do 
            echo $j;
            curl -u "${credential}" 'https://api.bitbucket.org/2.0/repositories/'$j'/refs/branches?pagelen=100&page=1&fields=next,values.name'  > branches.json
            
            branches=( $(grep -o '"name": "[^"]*' branches.json | grep -o '[^"]*$' ))
            for k in ${branches[@]}; 
            do 
                #MASTER  
                if  [ "$k" == "master" ];
                then
                    if  grep -F  "development" branches.json;
                    then
                        echo "development branch  is found"
                        bash ./master/Check-the-last-commit-for-at-least-1-successful-build-and-no-failed-builds.sh $j
                        bash ./master/Merge-via-pull-request.sh $j
                        bash ./master/Write-access-none.sh $j
                        bash ./master/Deleting-this-branch-is-not-allowed.sh $j
                    else
                        echo "development branch  is not  found"
                        bash ./master/Merge-via-pull-request-everyone.sh $j
                        bash ./master/Check-the-last-commit-for-at-least-1-successful-build-and-no-failed-builds.sh $j
                        bash ./master/Write-access-devops.sh $j
                        bash ./master/Deleting-this-branch-is-not-allowed.sh $j
                        #bash ./master/Require-task-to-be-completed.sh $j
                    fi
                fi 
                #DEVELOPMENT
                if [ "$k" == "development"  ];
                then
                    
                    bash ./development/Check-for-at-least-1-approval.sh $j
                    bash ./development/Check-for-unresolved-pull-request-tasks.sh $j
                    bash ./development/Deleting-this-branch-is-not-allowed.sh $j
                    bash ./development/Write-access.sh $j
                    bash ./development/Check-the-last-commit-for-at-least-1-successful-build-and-no-failed-builds.sh $j
                fi
  
                #OTHER
                bash ./other/Check-for-at-least-1-approval.sh "$j" "$k"
                bash ./other/Check-for-unresolved-pull-request-tasks.sh "$j" "$k"
                bash ./other/Check-the-last-commit-for-at-least-1-successfud-build-and-no-failed-builds.sh "$j" "$k"
                #bash ./other/Deleting-this-branch-is-not-allowed.sh $j
                bash ./other/Rewriting-branch-history-is-not-allowed.sh "$j" "$k"
            done
        done
        echo "$count"
        count=`expr $count + $increment`
    done
done