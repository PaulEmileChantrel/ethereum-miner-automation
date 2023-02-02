
#!/bin/bash
DEFAULT_DELAY=0
if [ "x$1" = "x" -o "x$1" = "xnone" ]; then
   DELAY=$DEFAULT_DELAY
else
   DELAY=$1
fi
sleep $DELAY

cd /usr/local/claymore15.0
su crx  -c "screen -dmS ethm ./mine.sh"



