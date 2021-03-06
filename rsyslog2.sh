#!/bin/bash

rsys_file="/etc/rsyslog.conf"
sys_file="/etc/syslog.conf"
rline="*.info @be-siem-01.clear2pay.com:514"
line="*.info @be-siem-01.clear2pay.com"
suse_line='destination loghost {udp("10.58.231.83" port(514));};'
suse_line2='log {source(src);destination(loghost);};'


rhel_centos (){
   if [ -e "$rsys_file" ];
      then 
      if grep -qF "$rline" "$rsys_file";
      then
         echo "Line $rline is alredy present in $rsys_file"
      else
         echo "$rline" >> "$rsys_file"
         echo "line has been added to $rsys_file"
         echo "restarting rsyslog service..."
         systemctl restart rsyslog
         echo "OK"
      fi
   elif [ -e "$sys_file" ];
      then
      if grep -qF "$line" "$sys_file";
      then
         echo "Line $line is alredy present in $sys_file"
      else
         echo "$line" >> "$sys_file"
         echo "Line $line has been added to $sys_file"
         echo "restarting syslog servie..."
         service syslog restart
         echo "OK"
      fi
   else
      echo "File Doesn't exist" 
   fi       
}

debian_ubuntu (){
   if [ -e "/etc/rsyslog.conf" ];
   then
      if grep -qF "*.=info @be-siem-01.clear2pay.com" "/etc/rsyslog.conf";
      then
         echo "Line is alredy present in /etc/rsyslog.conf"
      else
         echo "*.=info @be-siem-01.clear2pay.com" >> "/etc/rsyslog.conf"
         echo "line has been added to /etc/rsyslog.conf"
         echo "restarting rsyslog service..."
         service syslog restart
         echo "OK"
      fi
   else
      echo "File Doesn't exist"
   fi
}

suse(){
   if [ -e "/etc/syslog-ng/syslog-ng.conf" ];
   then
      if grep -qFx "$suse_line" "/etc/syslog-ng/syslog-ng.conf" && grep -qFx "$suse_line2" "/etc/syslog-ng/syslog-ng.conf";
      then
         echo "Line is alredy present in /etc/syslog-ng/syslog-ng.conf"
      else
         echo "$suse_line" >> "/etc/syslog-ng/syslog-ng.conf"
         echo "$suse_line2" >> "/etc/syslog-ng/syslog-ng.conf"
         echo "line has been added to /etc/syslog-ng/syslog-ng.conf"
         echo "restarting rsyslog service..."
         service syslog restart
         echo "OK"
      fi
   else
      echo "File Doesn't exist"
   fi
}


DISTRO=$( cat /etc/*release | tr [:upper:] [:lower:] | grep -Poi -m 1 '(debian|ubuntu|red hat|centos|suse|oracle)' | uniq )

case $DISTRO in
     centos|'red hat'|oracle)  rhel_centos;;
     debian|ubuntu)            debian_ubuntu;;
     suse)                     suse;;
     *)                        echo "Unknow Distro";;
esac

