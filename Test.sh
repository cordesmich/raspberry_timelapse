pi@raspberrypi ~ $ I=1
pi@raspberrypi ~ $ echo $I
1
pi@raspberrypi ~ $ echo $( printf "%03d" $I)
001





jpeg2yuv -n 30 -I p -L 0 -f 30 -j "$( printf "%03d" $i).jpg" | mpeg2enc -a 2 -f 8 -b 5800 -o "$( printf "%03d" $i).mpg"
