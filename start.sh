#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/common.sh"

ZEEK_ETC="$ZEEK_ROOT/etc"
ZEEK_BUNDLE="$ZEEK_ETC/zkg.bundle"
CONFIG_FILE="$ZEEK_ETC/docker.config"
LOCAL_ZEEK_FILE="$ZEEK_ROOT/share/zeek/site/local.zeek"
DOCKER_ROOT="/opt/docker"

#
# Function that returns a value from the config file.
#
# $1 - The key in the config file.
# $2 - The default value.
#
function config_value(){
    if test -f "$CONFIG_FILE"; then
        if egrep -q "^$1=" "$CONFIG_FILE"; then
            value=$(awk -F= -v key="$1" '$1==key {print $2}' "$CONFIG_FILE")
            if [  -z "$value"  ]; then
                echo ""
            else
                echo $value
            fi
        else
            echo $2
        fi
    else
        echo $2
    fi
}

echo "Starting..."

# 
# Auto-configuration of Zeek Package Manager
#
res=$(config_value zkg_autoconfig true)
if [ "$res" = "true" ]; then
    echo "Auto-configuring Zeek Package Manager..."
    zkg autoconfig \
        || { fail 'Error auto-configuring zeek package manager.'; }
else
    echo "Auto-configuring of Zeek Package Manager disabled."
fi

# 
# Installation of optional Zeek bundle
#
res=$(config_value zkg_bundle "$ZEEK_BUNDLE")
echo "Checking for Zeek bundle: $res..."
if test -f "$res"; then
    echo "Zeek bundle exists, installing..."
    zkg unbundle --force "$res" \
        || { fail 'Error installing Zeek bundle.'; }
else
    echo "Zeek bundle not found, skipping."
fi

#
# Loading of site packages
#
res=$(config_value load_packages false)
if [ "$res" = "true" ]; then
    echo "Checking whether site packages are being loaded..."
    if egrep -q "^\s*@load\s+packages\s*$" "$LOCAL_ZEEK_FILE"; then
        echo "Site packages are being loaded."
    else
        echo "Site packages are not being loaded, updating site file."
        echo "@load packages" >> "$LOCAL_ZEEK_FILE" \
            || { fail 'Error attempting to update site file to load packages.'; }   
    fi
else
    echo "Checking whether site packages are being loaded is disabled."
fi

#
# Run start command
#
res=$(config_value start_cmd zeek_deploy)
if [  -z "$res"  ]; then
    echo "No start command specified, skipping."
else
    echo "Running start command: $res..."
    "$res" \
        || { fail "Error running start command: $res"; }    
fi

echo "Startup completed."

#
# Run forever
#
res=$(config_value run_forever true)
if [ "$res" = "true" ]; then
    echo "Running forever."
    tail -f /dev/null \
        || { fail 'Error while attempting to run forever.'; }
else
    echo "Run forever disabled."
fi
