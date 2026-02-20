#!/bin/bash
# Need to run this as root
# Reference:
# https://askubuntu.com/questions/608386/using-ipega-bluetooth-gamepad-with-steam-linux#608438

# 1. Install the xboxdrv package
#
#    $ sudo apt install xboxdrv
#
# 2. Connect your Ipega controller to the PC via BT
#
#    HINT:
#    press X + Home on the controller to activate Gamepad mode and broadcast
#    the BT signal
#    Next time around, you only need to press the Home button
#
# 3. Get the event number of the contoller via: 
#
#    $ cat /proc/bus/input/devices
#
# 4. Update the IPEGA_EVENT variable here with the correct eventXX ID.
#
IPEGA_EVENT=event14

sudo xboxdrv \
    --evdev /dev/input/$IPEGA_EVENT \
    --evdev-absmap \
        ABS_X=x1,ABS_Y=y1,ABS_Z=x2,ABS_RZ=y2,ABS_HAT0X=dpad_x,ABS_HAT0Y=dpad_y \
    --axismap -Y1=Y1,-Y2=Y2 \
    --evdev-keymap \
        BTN_A=a,BTN_B=b,BTN_X=x,BTN_Y=y,BTN_TL=lb,BTN_TR=rb,BTN_TL2=lt,BTN_TR2=rt,BTN_THUMBL=tl,BTN_THUMBR=tr,BTN_SELECT=back,BTN_START=start \
    --mimic-xpad-wireless \
    --silent
