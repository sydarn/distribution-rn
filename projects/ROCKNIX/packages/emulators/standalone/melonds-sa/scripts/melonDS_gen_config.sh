#!/bin/bash
# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2023 JELOS (https://github.com/JustEnoughLinuxOS)

. /etc/profile

# Generate controller config from 098-controller, we only care about the
# digital buttons

export INST="Instance0"
# Replace modifiers with actual buttons
# This should be done export HOTKEY to change the behavior of gptokeyb
for MOD in DEVICE_FUNC_KEYA_MODIFIER DEVICE_FUNC_KEYB_MODIFIER
do
    sed -i -e "s/${MOD}/DEVICE_${!MOD}/g" $MEDNAFEN_HOME/mednafen.cfg
done

yq -i ".$INST.Joystick.B = ${DEVICE_BTN_SOUTH}" 
DEVICE_BTN_EAST
DEVICE_BTN_NORTH
               DEVICE_BTN_WEST DEVICE_BTN_TL DEVICE_BTN_TR               \
               DEVICE_BTN_TL2 DEVICE_BTN_TR2 DEVICE_BTN_SELECT           \
               DEVICE_BTN_START DEVICE_BTN_MODE DEVICE_BTN_THUMBL        \
               DEVICE_BTN_THUMBR DEVICE_BTN_DPAD_UP DEVICE_BTN_DPAD_DOWN \
               DEVICE_BTN_DPAD_LEFT DEVICE_BTN_DPAD_RIGHT

do
    # Detect axes, and treat appropriately. Default is button
    if [[ ${!CONTROL} =~ [+|-]$ ]]; then
        sed -i -e "s/@${CONTROL}@/abs_${!CONTROL}/g" $MELONDS_CONFIG
    elif [[ ${!CONTROL} =~ ^[0-9]+$ ]]; then
        # if it's just a number its a button
        sed -i -e "s/@${CONTROL}@/button_${!CONTROL}/g" 
    else
        # unidentifiable buttons or non-existent on this pad
        # Set a non-consequential value so that we don't get a syntax error in mednafen config
        # I randomly picked button_99 here.
        sed -i -e "s/@${CONTROL}@/button_99/g" $MEDNAFEN_HOME/mednafen.cfg
    fi
done
