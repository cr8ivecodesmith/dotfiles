#!/bin/bash
# Sometimes the Wireless driver gets messed up after resuming from a sleep.
#

sudo modprobe -r iwlwifi && sudo modprobe iwlwifi
