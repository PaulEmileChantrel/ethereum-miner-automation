#!/bin/bash

cp /usr/local/minerLocalScript/dayETC.sh /usr/local/claymore15.0/mine.sh


PID=$(pgrep miner)


kill -INT $PID
/bin/bash  /usr/local/minerLocalScript/miner_launcher.sh


