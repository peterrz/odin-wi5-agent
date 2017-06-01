Odin Wi5 Agent
==============

We are adding interesting info in this wiki: https://github.com/Wi5/odin-wi5/wiki

Odin Wi5 agents run on physical APs, and are implemented as Click elements. Agents contain the logic for the Wi-Fi split-MAC and LVAP handling. Agents also record information about clients using Radiotap headers, and communicate with the Odin Controller over the Odin control channel. The physical AP hosting the agent also requires a modified Wi-Fi device driver to generate ACK frames for every LVAP that is hosted on the AP.


Source files for Odin agent:

src/odinagent{.cc,.hh}
----------------------

These are the Click OdinAgent element files. They have only been tested in userspace mode.

To build, follow the instructions in https://github.com/Wi5/odin-wi5/wiki/Cross-compiling-Click-Modular-Router-for-Odin

You also have a binary version of Click, cross-compiled for AR71xx architecture https://github.com/Wi5/odin-wi5-agent/tree/integrate_detection/click_binary_file

A `click-align` binary is also available, compiled for the same architecture.


agent-click-file-gen.py
-----------------------

This is the `.cli` file generator for the agent. Configure and use this script
to generate the appropriate Odin agent Click file.

If you run `$python agent-click-file-gen.py` you will see an example of how to use the python script, and the meaning of each parameter.


Scripts for starting the Odin Wi5 agent
---------------------------------------

The script for starting the Wi5 agent are here https://github.com/Wi5/odin-wi5-agent/tree/integrate_detection/scripts_start_ap_odin

A script for debugging is also available.
