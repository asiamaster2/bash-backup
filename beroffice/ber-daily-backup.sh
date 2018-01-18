#!/bin/bash
processrunning=` ps aux |grep "region-daily-backup.sh" |grep -v grep |wc -l`
if [ $processrunning -gt 2 ]; then
	echo "The script is running already"
	exit
else
	echo "Backup starts"
fi

chk_vpn () {
	tmp_val=`ping -c 1 20.8.0.5 |grep packets |awk '{print $4}'|head -n 1`
	if [ $tmp_val -gt 0 ]; then
		echo "VPN is not connected."
		killall -9 openvpn
		exit
	else
		echo "VPN is connected successfully."
	fi
}

rm_backupfile () {
	if [ $storage_period -gt 0 ]; then
		let storage_period=$storage_period*7
		find /home/backup/data/$server_group/$server_name/$backupname/ -name "*.aaronbacku*" -type d -ctime +$storage_period -exec rm -rf {} \;
	else
		echo "set the storage period first"
	fi
}

cp_backupfile_rsyncport () {
        if [ $CURRENTDAY -eq 4 ]; then
                mkdir -p /home/backup/data/$server_group/$server_name/$backupname/$TODATE.aaronbackup.full
                rsync -av $server_ip::$backup_target /home/backup/data/$server_group/$server_name/$backupname/$TODATE.aaronbackup.full/ --progress > /home/backup/data/$server_group/$server_name/$backupname/$TODATE.aaronbackup.full/history.log
        else
                full_dir=` ls -t /home/backup/data/$server_group/$server_name/$backupname/ |grep ".aaronbackup.full" |grep -v grep |head -n 1`
                if [ -z $full_dir ]; then
                	mkdir -p /home/backup/data/$server_group/$server_name/$backupname/$TODATE.aaronbackup.full
                	rsync -av $server_ip::$backup_target /home/backup/data/$server_group/$server_name/$backupname/$TODATE.aaronbackup.full/ --progress > /home/backup/data/$server_group/$server_name/$backupname/$TODATE.aaronbackup.full/history.log
                else
                	mkdir -p /home/backup/data/$server_group/$server_name/$backupname/$TODATE.aaronbackup
                	rsync -av --compare-dest=/home/backup/data/$server_group/$server_name/$backupname/$full_dir/ $server_ip::$backup_target /home/backup/data/$server_group/$server_name/$backupname/$TODATE.aaronbackup/ --progress > /home/backup/data/$server_group/$server_name/$backupname/$TODATE.aaronbackup/history.log
                fi
        fi
}


clientvpnfile="PATH/regionoffice.ovpn"

TODATE=`date +%Y%m%d`
CURRENTDAY=`date +"%u"`

mysqluser="itadmin"
mysqluserpw="KEY"
mysqluserpw=`echo "$mysqluserpw" |openssl enc -aes-256-cbc -a -d -salt -pass file:/home/backup/script/aaron`
mysqldb="itbackup"

query="SELECT * FROM backup_server_list where server_status='enable' and server_region ='region';"

openvpn --config $clientvpnfile &
sleep 5
chk_vpn

while read -r uid server_name server_ip server_group server_OS server_id server_pw server_status server_region; do

	query="SELECT * FROM backup_path where server_UID = '$uid' AND status = 'enable' AND cycle = 'daily';" 
	
	while read -r uid server_UID backupname backup_drive storage_period cycle cycle_val status backup_target; do
#        output+=("$server_id" "$server_pw")
#      	server_id=${output[0]}
#        server_pw=${output[1]}
#        server_pw=`echo "$server_pw" |openssl enc -aes-256-cbc -a -d -salt -pass file:/home/backup/script/aaron`

	#echo $uid $server_UID $backupname $backup_drive $storage_period $cycle $cycle_val $status $backup_target
	
		cp_backupfile_rsyncport

		rm_backupfile

	done < <(mysql -u $mysqluser -p$mysqluserpw -s -N -D $mysqldb  -e "$query")

done < <(mysql -u $mysqluser -p$mysqluserpw -s -N -D $mysqldb  -e "$query")

killall -9 openvpn
