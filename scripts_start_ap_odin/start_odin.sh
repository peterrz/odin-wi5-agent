#!/bin/sh
echo "interfaces"
ifconfig wlan0 down
iw phy phy0 interface add mon0 type monitor
#iw dev wlan0 set channel 1
ifconfig mon0 up
ifconfig wlan0 up

# add this route in order to permit control from Unizar networks                
# traffic from these networks will not go through the default gateway          
route add -net 155.210.158.0 netmask 255.255.255.0 gw 155.210.157.254 eth0      
route add -net 155.210.156.0 netmask 255.255.255.0 gw 155.210.157.254 eth0      

# set the default gateway where masquerading is being performed                 
route del default gw 155.210.157.254
route add default gw 192.168.1.129

# if you have put click and start-up scripts in a usb device
mkdir -p /mnt/usb
mount /dev/sda1 /mnt/usb/
cd /mnt/usb/

# start ovs and click
./script_start_ovs.sh
sleep 2
./script_start_click.sh
