


a=0
b=1
#mount -o remount,rw /
rm -rf /usr/local/SSD/ssd1/*
rm -rf /usr/local/SSD/ssd2/*
cp -a /usr/local/SSD/ssd/* /usr/local/SSD/ssd1/
echo "start test" > /usr/local/SSD/ssd_log
while [ "$a" != "$b" ]
do
cp -a /usr/local/SSD/ssd1/* /usr/local/SSD/ssd2/
date >> /usr/local/SSD/ssd_log
#sudo diff -q -r /home/chronos/EMI/temp /media/DISK/temp >> log
#date >> /home/chronos/EMI/fcp_log
rm -rf /usr/local/SSD/ssd1/*
date >> /usr/local/SSD/ssd_log
cp -a /usr/local/SSD/ssd2/* /usr/local/SSD/ssd1/
date >> /usr/local/SSD/ssd_log
#sudo diff -q -r /media/DISK/temp/ /home/chronos/EMI/temp >> log
#date >> /home/chronos/EMI/fcp_log
rm -rf /usr/local/SSD/ssd2/*
date >> /usr/local/SSD/ssd_log
echo "end test" >> /usr/local/SSD/ssd_log
done
