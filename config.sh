#!/bin/bash

URL="https://10.108.255.249/include/auth_action.php"
username=
password=
ip=`ifconfig | grep inet | head -1 | awk '{print $2}'`

curl $URL --insecure --data "action=login&username=$username&password=$password&ac_id=1&user_ip=$ip&nas_ip=&user_mac=&save_me=1&ajax=1" > /dev/null 2>&1

unset URL username password ip