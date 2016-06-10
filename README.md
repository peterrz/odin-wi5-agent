Odin agent
=========

Odin agents run on physical APs, and are implemented as Click elements. Agents contain the logic for the Wi-Fi split-MAC and LVAP handling. Agents also record information about clients using radiotap headers, and communicate with the Odin Master over the Odin control channel. The physical AP hosting the agent also requires a slightly modified Wi-Fi device driver to generate ACK frames for every LVAP that is hosted on the AP.


Source files for Odin agent:

src/odinagent{.cc,.hh}
-----------------

These are the Click OdinAgent element files. They've only been
tested in userspace mode so far. To build:

1. Add these files to <click>/elements/local/

2. Build Click with the --enable-local and --enable-userspace flag.


agent-click-file-gen.py
-----------------------

Click file generator for the agent. Configure and use this script
to generate the appropriate Odin agent click file.

This is an example of how to use the python command:

    $ python agent-click-file-gen.py 4 50  14:CC:20:AC:72:91 192.168.1.7 2819  /sys/kernel/debug/ieee80211/phy0/ath9k/bssid_extra odin-unizar 192.168.1.129 0 12 108

where the parameters have the next meaning:

`4`			number of the channel

`50`			size of the queue

`14:CC:20:AC:72:91`	MAC address of the AP

`192.168.1.7`		IP address of the AP

`2819`			port used to connect with the Controller

`/sys/kernel/debug/ieee80211/phy0/ath9k/bssid_extra`	directory of the debug file

`odin-unizar`		SSID

`192.168.1.129`		IP address of the Controller

`0`			No click debug info

`12`			Debug level 2, with Demo appearance (1)

`108`			54 Mbps of TX rate
