#!/bin/sh
echo "interfaces"
#put wlan0 down before creating mon0
ifconfig wlan0 down
#add the monitor device
iw phy phy0 interface add mon0 type monitor
#you should not define the channel here, so we have commented the next line
#iw dev wlan0 set channel 1
#initiate mon0
ifconfig mon0 up
#initiate wlan0. You must have it active, otherwise things do not work
ifconfig wlan0 up

# add this route in order to permit control from Unizar networks                
# traffic from these networks will not go through the default gateway
# NOTE: The next two lines are just for our Unizar setup, so you can remove them
route add -net 155.210.158.0 netmask 255.255.255.0 gw 155.210.157.254 eth0      
route add -net 155.210.156.0 netmask 255.255.255.0 gw 155.210.157.254 eth0      

# set the default gateway where masquerading is being performed
# NOTE: This may vary according to your setup. Add your default gateway as needed
route del default gw 155.210.157.254
route add default gw 192.168.101.129

# this script assumes you have:
# - in the root directory (current): start_odin.sh
# - in the USB:
#               init_ovs.sh
#               init_cli.sh
#               click        the compiled Click application
#               a_agent.cli  the .cli file to be run by Click. It must be aligned

# mount the USB
mkdir -p /mnt/usb
mount /dev/sda1 /mnt/usb/ #sda1 may have to be replaced by other device

# move to the USB
cd /mnt/usb/


# initiate openvswitch and click with the corresponding scripts:

# initiate openvswitch (ovs)
./init_ovs.sh

# initiate click (cli)
sleep 2
./init_cli.sh