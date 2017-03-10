echo "Zeitraffer 1.0"
echo " "
echo "Michael Cordes"
echo " "
echo " "

#Varialben
BILDER_VAR=0
MAX_BILDER=1000
MY_TIME=1


echo "USB einbinden"

	#USB Stick einbiden
	sudo mount /dev/sda1 /media/usbstick


echo " "
echo "Infos:"
echo -e "\033[1;33m CPU-Temp:        \033[0m"  `cat /sys/class/thermal/thermal_zone0/temp| awk '{print $1/1000}'` "°"
echo -e "\033[1;33m Speichernutzung: \033[0m"  `cat /proc/meminfo|grep 'MemF'| awk '{print $2}'` "kB von" `cat /proc/meminfo|grep 'MemT'| awk '{print $2}'` "kB frei"
echo -e "\033[1;33m CPU-Freq:        \033[0m"  `cat /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_cur_freq| awk '{print $1/1000}'` "Mhz"

echo " "
echo "Bilder machen"
cd --
while [ $BILDER_VAR -lt $MAX_BILDER ]{
do
	DATUM=$(date -u "+%Y%m%d_%H%M%S")

	sudo raspistill -n -t 800 -o /media/usbstick/$DATUM.jpg

	sleep $MY_TIME

	BILDER_VAR=$((BILDER_VAR+1))
	#echo $BILDER_VAR

done

echo " "
echo -e "\033[1;33m CPU-Temp:        \033[0m"  `cat /sys/class/thermal/thermal_zone0/temp| awk '{print $1/1000}'` "ï¿½"     




echo "USB auswerfen"
	sudo umount /media/usbstick



echo "Fertig"




#raspistill -n -q 80 -t 100000 -tl 5000  -o /media/usbstick/PIC%04d.jpg

