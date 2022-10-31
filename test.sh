#!/bin/bash
VIRTUAL_ENV_NAME=testing
export APP_ENV=${APP_ENV}
echo $APP_ENV
python3 -m venv $VIRTUAL_ENV_NAME
source $VIRTUAL_ENV_NAME/bin/activate
pip3 install -r ./requirements.txt
output=$(free -m | grep -vE '^ |Swap' | awk '{ print $4 " " }' )
total=$(free -m | grep -vE '^ |Swap' | awk '{ print $2 " " }' )
free_mem=$(( $output*100/$total ))
echo ${free_mem}%
echo "*****Free memory is ${free_mem}%*****"
if [ "$free_mem" -le "20" ]
then
echo "*****Running out of memory ($free_mem%) on $(hostname) as on $(date)*****"
fi
deactivate
