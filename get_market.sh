#!/bin/bash
base_url="https://api.binance.com"

account_info="/api/v1/exchangeInfo"

url="${base_url}${account_info}"

req=$(curl "$url")
echo $req>"/usr/local/minerLocalScript/ETH_ETC_switch/markets.txt"

markets=$(jq ".symbols" /usr/local/minerLocalScript/ETH_ETC_switch/markets.txt)
echo $markets>/usr/local/minerLocalScript/ETH_ETC_switch/markets.txt

rm /usr/local/minerLocalScript/ETH_ETC_switch/market.txt

a=0

while [ $a -lt 999 ]
do
        market=$(jq ".[$a].symbol" /usr/local/minerLocalScript/ETH_ETC_switch/markets.txt)
        market=$(echo $market | sed 's/[^A-Z]*//g')
        if [ "$market" = null ]
        then
                index=$a
                a=1000 
       else
                echo "$market">>/usr/local/minerLocalScript/ETH_ETC_switch/market.txt
                a=`expr $a + 1`
        fi;
done

echo "$index">/usr/local/minerLocalScript/ETH_ETC_switch/binance_market_number.txt
