#!/bin/bash

echo "##################################"
echo " "
echo "Zeitraffer 1.0"
echo " "
echo "Michael Cordes"
echo " "
echo "##################################"

sleep 2

#Varialben
BILDER_VAR=0
MAX_BILDER=100				# Durchlaeufe der Bilder (Zyklus)
TIME_PIC=$((60 * 1))

HOST='host'
USER='user'
PASSWD='pass'


echo "Durchgaenge:               " $MAX_BILDER
echo "Aufnahmezeit: (min)        " $(($TIME_PIC / 60 * $MAX_BILDER)) 
echo " "
echo "USB einbinden"


	#USB Stick einbiden
	cd /media/
	mkdir usbstick
        sudo umount /media/usbstick
	sleep 2
	sudo rm -r /media/usbstick/*   # Bei USB Sick mit einbinden !!!!!!!!
	sleep 2
	sudo mount /dev/sda1 /media/usbstick
	cd /media/usbstick/

#Neuer Ornder nach Neustart
TAG_NUMB=1
SCHLEIFE=0
while [ $SCHLEIFE -lt 1 ] 
do
	if [ -d TAG_$((TAG_NUMB)) ]
	 then 
		TAG_NUMB=$((TAG_NUMB+1))
	else 
		SCHLEIFE=$((SCHLEIFE+1))
	fi
done

echo "Ordner : 		   TAG_"$TAG_NUMB
mkdir TAG_$TAG_NUMB

echo " "
echo "Bilder machen"
cd --


while [ $BILDER_VAR -lt $MAX_BILDER ]
do


	echo " "
	echo "Info:" $BILDER_VAR
	echo " Datum: "  $(date -u "+%Y.%m.%d") "Zeit:"  $(date -u "+%H:%M:%S")
	echo " CPU-Temp:        "  `cat /sys/class/thermal/thermal_zone0/temp| awk '{print $1/1000}'` 
	echo " Speichernutzung: "  `cat /proc/meminfo|grep 'MemF'| awk '{print $2}'` "kB von" `cat /proc/meminfo|grep 'MemT'| awk '{print $2}'` "kB frei"

	cd /media/usbstick/TAG_$(($TAG_NUMB))/

	FILE=/media/usbstick/TAG_$TAG_NUMB/PIC_TAG_$( printf "%03d" $TAG_NUMB)__$( printf "%05d" $BILDER_VAR).jpg
	FILE_NAME=PIC_TAG_$( printf "%03d" $TAG_NUMB)__$( printf "%05d" $BILDER_VAR).jpg

	sudo raspistill -n -o $FILE -w 1280 -h 960

	sleep 5
	echo "FTP upload"
	ftp -n $HOST << END_SCRIPT
	quote USER $USER
	quote PASS $PASSWD
	binary
	put $FILE_NAME
	quit
END_SCRIPT

	echo "Warte Sec:" $(($TIME_PIC - 5))
	sleep $(($TIME_PIC - 5))

	BILDER_VAR=$((BILDER_VAR+1))

done

echo " "
echo " CPU-Temp:        "  `cat /sys/class/thermal/thermal_zone0/temp| awk '{print $1/1000}'`
echo " Speichernutzung: "  `cat /proc/meminfo|grep 'MemF'| awk '{print $2}'` "kB von" `cat /proc/meminfo|grep 'MemT'| awk '{print $2}'` "kB frei"


echo "Bilder gemacht."

cd ~

sleep 1

echo "USB auswerfen"
sleep 5
	sudo umount /media/usbstick

echo "Fertig"

exit 0
