#!/bin/bash

echo "##################################"
echo " "
echo "Zeitraffer 1.0"
echo " "
echo "Michael Cordes"
echo " "
echo "##################################"

sleep 20

#Varialben
BILDER_VAR=0
MAX_BILDER=40				# Durchlaeufe der Bilder (Zyklus)
MY_TIME=5000				# Zeitabschand zwischen den Bilder
GES_TIME=$(($MY_TIME * 360 + 100))	# Gesamte Zeit eines Zyklus


#Random fuer Zufallsordner
MY_RAN=$(($RANDOM))


echo "Zeit zw. den Bildern: (ms) "  $MY_TIME
echo "Aufnahmezyklus: (min)      " $(($GES_TIME / 60000))
echo "Durchgaenge:               " $MAX_BILDER
echo "Aufnahmezeit: (min)        " $(($GES_TIME / 60000 * $MAX_BILDER)) 
echo " "
echo "USB einbinden"
echo "Ornder:           	 " $MY_RAN

	#USB Stick einbiden
#	sudo rm -r /media/usbstick/*   # Bei USB Sick mit einbinden !!!!!!!!
	sudo mount /dev/sda1 /media/usbstick
	cd /media/usbstick/
	sudo mkdir $MY_RAN

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

	cd /media/usbstick/$MY_RAN/
	sudo mkdir $BILDER_VAR
	cd

	sudo raspistill -n -t $GES_TIME -tl $MY_TIME  -o /media/usbstick/$MY_RAN/$BILDER_VAR/PIC_$(($BILDER_VAR))_%04d.jpg -w 1280 -h 960

	sleep 2

	BILDER_VAR=$((BILDER_VAR+1))

done

echo " "
echo " CPU-Temp:        "  `cat /sys/class/thermal/thermal_zone0/temp| awk '{print $1/1000}'`
echo " Speichernutzung: "  `cat /proc/meminfo|grep 'MemF'| awk '{print $2}'` "kB von" `cat /proc/meminfo|grep 'MemT'| awk '{print $2}'` "kB frei"


echo "Bilder gemacht."

cd 

sleep 3

echo "USB auswerfen"
sleep 5
	sudo umount /media/usbstick

echo "Fertig"
