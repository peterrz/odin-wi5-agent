#!/bin/sh

# In order to adapt this script to your setup, you must:
# - modify the IP address of the controller (CTLIP)
# - adapt the names of your wireless devices: wlan0-phy0-mon0; wlan1-phy1-mon1
# - add some routes if you need them (route add)
# - mount the USB (or not) if you need (or not) to use some files from it
# - modify the name and the route of the .cli script to be used
# - modify the port used by OpenFlow (6633 by default)

# The order is:
# 1.- Launch this script in all the APs. You will see a message "Now you can launch the controller and press Enter"
# 2.- Launch the Wi-5 odin controller
# 3.- Press ENTER on each of the APs

## Variables
echo "Setting variables"
CTLIP=192.168.1.129 # Controller IP address
SW=br0              # Name of the bridge
DPPORTS="eth1.2"    # Port for data plane
VSCTL="ovs-vsctl"   # Command to be used to invoke openvswitch

## Setting interfaces
echo "Setting interfaces"
ifconfig wlan0 down
ifconfig wlan1 down
iw phy phy0 interface add mon0 type monitor
iw phy phy1 interface add mon1 type monitor
#iw phy phy0 set retry short 4
#iw dev wlan0 set channel 1
ifconfig mon0 up
ifconfig mon1 up
ifconfig mon0 mtu 1532
ifconfig mon1 mtu 1532
ifconfig wlan0 up
ifconfig wlan1 up
# add this route in order to permit control from Unizar networks
# traffic from these networks will not go through the default gateway
route add -net 155.210.158.0 netmask 255.255.255.0 gw 155.210.157.254 eth0
route add -net 155.210.156.0 netmask 255.255.255.0 gw 155.210.157.254 eth0
# set the default gateway where masquerading is being performed
#route del default gw 155.210.157.254
#route add default gw 192.168.1.131

## Mount USB if you need it (e.g. for putting the Click binary there)
echo "Mounting USB"
if [ ! -d "/mnt/usb" ]; then
  mkdir -p /mnt/usb
fi
mount /dev/sda1 /mnt/usb/

## OVS
echo "Restarting OpenvSwitch"
/etc/init.d/openvswitch stop
sleep 1
# The next line is added in order to start the controller after stopping openvswitch
read -p "Now you can launch the Wi-5 odin controller and press Enter" pause

echo "Cleaning DB"
if [ -d "/etc/openvswitch" ]; then
  rm -r /etc/openvswitch
fi
if [ -f "/var/run/db.sock" ]; then
  rm /var/run/db.sock
fi
if [ -f "/var/run/ovsdb-server.pid" ]; then
  rm /var/run/ovsdb-server.pid
fi
if [ -f "/var/run/ovs-vswitchd.pid" ]; then
  rm /var/run/ovs-vswitchd.pid
fi
echo "Launching OVS"
/etc/init.d/openvswitch start
$VSCTL add-br $SW # Create the bridge
ifconfig $SW up # In OpenWrt 15.05 the bridge is created down
$VSCTL set-controller $SW tcp:$CTLIP:6633 # Configure the OpenFlow Controller.
for i in $DPPORTS ; do # Including ports to OVS
    PORT=$i
    ifconfig $PORT up
    $VSCTL add-port $SW $PORT
done

## Launch click
echo "Launching Click"
cd /mnt/usb
sleep 1
./click aagent9.cli &
sleep 1
# From this moment, a new tap interface called 'ap' will be created by Click

# Add 'ap' to OVS
echo "Adding Click interface 'ap' to OVS"
ifconfig ap up # Adding 'ap' interface (click Interface) to OVS
$VSCTL add-port $SW ap
sleep 1

## OpenVSwitch Rules
# OpenFlow rules needed to make it possible for DHCP traffic to arrive to the Wi-5 odin controller
ovs-ofctl add-flow br0 in_port=2,dl_type=0x0800,nw_proto=17,tp_dst=67,actions=output:1,CONTROLLER
ovs-ofctl add-flow br0 in_port=1,dl_type=0x0800,nw_proto=17,tp_dst=68,actions=output:CONTROLLER,2
