#!/bin/bash
base_url="https://api.binance.com"

account_info="/api/v1/klines"

url="${base_url}${account_info}"
dat=$(date +"%s")
dat=$(echo "$dat * 1000" | bc)



while read line; do

        queryString="symbol=$line&interval=1h&limit=24&endTime=$dat"
        req=$(curl "$url?$queryString")
        echo $req
        echo $req>"/usr/local/minerLocalScript/ETH_ETC_switch/marketData/$line_temp.txt"
        a=0
        while [ $a -lt 24 ]
        do 
                hour=$(jq ".[$a]" "/usr/local/minerLocalScript/ETH_ETC_switch/marketData/$line_temp.txt$
                hour=$(echo $hour | sed 's/[^0-9.,]*//g')
                echo $hour>>"/usr/local/minerLocalScript/ETH_ETC_switch/marketData/$line.txt"
                a=`expr $a + 1`
        done
done < /usr/local/minerLocalScript/ETH_ETC_switch/market.txt
