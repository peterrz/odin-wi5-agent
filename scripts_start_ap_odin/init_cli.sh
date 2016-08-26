#!/bin/sh

#Setup variables
# My local IP address, i.e. the one I am using to connect with the Odin Controller
MYIP=192.168.101.9
 
# This is the IP of the Odin Controller
CTLIP=192.168.101.129

# This is the TCP port number for the openvswitch database
TCP_PORT_OVS_DBASE=6632

# This is the TCP port number for the Click control socket (controlskt)
TCP_PORT_CLICK_CTRL_SOCKET=6777

# This is the name of the bridge that we are going to create
SW=br0


# Start Click, using the correct name of the ALIGNED .cli file
./click a_agent.cli &

# Wait some time
sleep 3

# Start the 'ap' interface created by Click
ifconfig ap up

# Add the 'ap' interface to the openvswitch
ovs-vsctl --db=tcp:$MYIP:$TCP_PORT_OVS_DBASE add-port $SW ap

# Wait some time
sleep 3

# Add an Openflow rule in the Controller, to manage the new flows of the Click control socket
ovs-ofctl add-flow $SW in_port=1,dl_type=0x0800,nw_src=$CTLIP,nw_dst=$MYIP,nw_proto=6,tp_dst=$TCP_PORT_CLICK_CTRL_SOCKET,actions=output:LOCAL