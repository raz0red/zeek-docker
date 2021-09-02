#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$SCRIPT_DIR/../common.sh"

HTTP_LOG="$SCRIPT_DIR/volumes/spool/zeek/http.log"

# Wait until Zeek is running 
until docker exec zeek zeekctl status | grep -q "running";
do 
  echo "Waiting for zeek to be running..."
  sleep 5; 
done

# Test to ensure that HTTP file does not exist
echo "Check to ensure HTTP log does not exist..."
if [ -f "$HTTP_LOG" ]; then
    fail 'HTTP Log file already exists.';
fi

# Make HTTP request to produce log information
echo "Making HTTP request..."
docker exec zeek wget http://www.zerostatus.com > /dev/null 2>&1
sleep 5

echo "Check to ensure HTTP log exists..."
# Test to ensure that HTTP file exists
if [ ! -f "$HTTP_LOG" ]; then
    fail 'HTTP file does not exist.';
fi

echo "Checking to ensure bzar is loaded..."
docker exec zeek zeekctl scripts | grep -q "/packages/bzar/" \
    || { fail 'bzar scripts not found.'; }
    