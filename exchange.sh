#!/bin/bash
base_url="https://api.binance.com"

account_info="/api/v3/account"
sell_req="/api/v3/order"


url="${base_url}${account_info}"
url_sell="${base_url}${sell_req}"


secret="APIKEY"

apikey="SECRET"

current_time=$(date +%s)

echo  $current_time
current_time=$(echo "($current_time+130) * 1000" | bc)
echo $current_time

queryString="recvWindow=60000&timestamp=$current_time" #$(python3 binance_time.py) must sync
requestBody=""



signature="$(echo -n "${queryString}${requestBody}" | openssl dgst -sha256 -hmac $secret)"

signature="$(echo $signature | cut -f2 -d" ")"


req=$(curl -H "X-MBX-APIKEY: $apikey" -X GET "$url?$queryString&signature=$signature")
echo $req>/usr/local/minerLocalScript/ETH_ETC_switch/req.txt

crypto=$(jq '.balances' /usr/local/minerLocalScript/ETH_ETC_switch/req.txt)
a=0
while [ $a -lt 200 ]
do
	cr=$(jq ".balances[$a].asset" /usr/local/minerLocalScript/ETH_ETC_switch/req.txt)
	if [ "$cr" =  '"ETC"' ];
	then
		index=$a
		a=301

	else
		a=`expr $a + 1`
	fi;
done

etc_free=$(jq ".balances[$index].free" /usr/local/minerLocalScript/ETH_ETC_switch/req.txt)

echo $etc_free | sed 's/[^0-9.]*//g'>/usr/local/minerLocalScript/ETH_ETC_switch/ETC_free.txt

etc_free=$(echo $etc_free | sed 's/[^0-9.]*//g')
etc_free=$(echo "$etc_free - 0.005" |bc)
etc_free=$(echo $etc_free | xargs printf "%.*f\n" 2)


current_time=$(date +%s)

echo  $current_time
current_time=$(echo "($current_time+130) * 1000" | bc)


sell_query="symbol=ETCETH&side=SELL&type=MARKET&quantity=$etc_free&recvWindow=60000&timestamp=$current_time"
sell_signature="$(echo -n "${sell_query}${requestBody}" | openssl dgst -sha256 -hmac $secret)"
sell_signature="$(echo $sell_signature | cut -f2 -d" ")"
echo $etc_free
echo $sell_query

etc_comp=$(echo "$etc_free*10" |bc)
etc_comp=$(echo $etc_comp | xargs printf "%.*f\n" 0)
echo $etc_comp

if [ $etc_comp -gt 2 ];
then
	echo "Need to sell ETC to ETH"
	sell_request=$(curl -H "X-MBX-APIKEY: $apikey" -X POST "$url_sell?$sell_query&signature=$sell_signature")
	echo $sell_request
fi


