#!/bin/bash

# Keep reconnecting to the EC2 instance in case of failure
# to keep the SSH reverse tunnel open

while true ; do
    ssh remote-vnc
    sleep 5
done
