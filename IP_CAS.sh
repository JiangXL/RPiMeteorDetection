#!/bin/bash

# check network availability
while true
do

    URL=`curl --head baidu.com 2> /dev/null | grep "Location: http://enet.10000.gd.cn" | sed 's/Location: //'`
    if echo $URL | grep -q "http"
    then

    DATE=`date "+%Y-%m-%d %H:%M:%S"`
    URL=`echo "$URL" | sed 's/\r$//g'`
    echo "[$DATE] Logging..."
    FORM=`curl -L "${URL}" 2> /dev/null`
    ACTION=`echo "$FORM" | grep "<form " | sed 's/.*action="\(.*\)" .*/\1/'`
    LT=`echo "$FORM" | grep '<input type="hidden" name="lt" ' | sed 's/.*value="\(.*\)" .*/\1/'`
    EXEC=`echo "$FORM" | grep '<input type="hidden" name="execution" ' | sed 's/.*value="\(.*\)" .*/\1/'`
    DATA="username=11510512&password=288756&lt=$LT&execution=$EXEC&_eventId=submit&submit=LOGIN"
    RESULT=`curl -L --data "$DATA" "http://weblogin.sustc.edu.cn$ACTION" 2> /dev/null`

   if echo $RESULT | grep -q "<h2>success"
   then
   echo "Success"
   else
   echo "Failed"
   fi
   fi


  TIMEOUT=15
  SITE_TO_CHECK="open.163.com"
  RET_CODE=`curl -I -s --connect-timeout $TIMEOUT $SITE_TO_CHECK -w %{http_code} | tail -n1`
  if [ "x$RET_CODE" = "x200" ];then
  echo "Network OK, wait"
  break
  else
  echo "Network not ready, wait..."
  sleep 7s
  fi
done


while true
do

# get the IP address of eth0, e.g. "192.168.16.5"
ETH0_IP_ADDR=`ifconfig eth0 | sed -n "2,2p" | awk '{print substr($2,1)}'`



# make log info
echo "Current time: `date '+%F %T'`. Enjoy it $ETH0_IP_ADDR"

bypy.py upload /home/pi/Desktop/ip.log -v

sleep  1h
done
#直接在shell中生存log文件
#http://www.cnblogs.com/smbx-ztbz/p/4607007.html


#Code in Windows will make erro!!!!!!!!!!!
#In shell if fi will be a {}


