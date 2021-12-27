#!/bin/bash

current_branch=$(git symbolic-ref HEAD | sed -e 's,.*/\(.*\),\1,')

echo $current_branch

if [ $current_branch == 'dev' ]
then
exit 0 
elif [ $current_branch == 'stage' ]
then
echo "you can't push from stage"
exit 1
elif [ $current_branch == 'prod' ]
then
echo "you can't push from prod"
exit 1 # push will execute
fi
    
#the 'pre-commit' git hook prevents working from 'stage' and 'prod'
#it should prevent working on stage and prod
#working on a seperate branch other than dev and pushing to 'dev' is allowed
exit 0;