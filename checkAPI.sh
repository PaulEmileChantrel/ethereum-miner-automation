#!/bin/bash

curl -o /usr/local/minerLocalScript/ETH_ETC_switch/ETH.json https://whattomine.com/coins/151.json
curl -o /usr/local/minerLocalScript/ETH_ETC_switch/ETC.json https://whattomine.com/coins/162.json


eth_diff=$(jq '.difficulty' /usr/local/minerLocalScript/ETH_ETC_switch/ETH.json)
etc_diff=$(jq '.difficulty' /usr/local/minerLocalScript/ETH_ETC_switch/ETC.json)

eth_rate=$(jq '.exchange_rate' /usr/local/minerLocalScript/ETH_ETC_switch/ETH.json)
etc_rate=$(jq '.exchange_rate' /usr/local/minerLocalScript/ETH_ETC_switch/ETC.json)

eth_block_reward=$(jq '.block_reward' /usr/local/minerLocalScript/ETH_ETC_switch/ETH.json)
etc_block_reward=$(jq '.block_reward' /usr/local/minerLocalScript/ETH_ETC_switch/ETC.json)


echo "$eth_block_reward">>/usr/local/minerLocalScript/ETH_ETC_switch/eth_block_reward.txt
echo "$etc_block_reward">>/usr/local/minerLocalScript/ETH_ETC_switch/etc_block_reward.txt

echo "$eth_diff">>/usr/local/minerLocalScript/ETH_ETC_switch/eth_diff.txt
echo "$etc_diff">>/usr/local/minerLocalScript/ETH_ETC_switch/etc_diff.txt

echo "$eth_rate">>/usr/local/minerLocalScript/ETH_ETC_switch/eth_rate.txt
echo "$etc_rate">>/usr/local/minerLocalScript/ETH_ETC_switch/etc_rate.txt

current=$(< /usr/local/minerLocalScript/ETH_ETC_switch/current.txt)
current_time=$(< /usr/local/minerLocalScript/ETH_ETC_switch/current_time.txt)
current_run_time=$(< /usr/local/minerLocalScript/ETH_ETC_switch/current_run_time.txt)

eth=$(echo "120000000000000000000 / $eth_diff * $eth_rate * $eth_block_reward * 3600 * 24" | bc)
etc=$(echo "120000000000000000000 / $etc_diff * $etc_rate * $etc_block_reward * 3600 * 24" | bc)

eth=$(echo $eth | xargs printf "%.*f\n" 0)
etc=$(echo $etc | xargs printf "%.*f\n" 0)

echo "$eth"
echo "$etc"
echo "$current"
echo "$current_time"

if [ $eth -gt $etc ]
then
	 echo "this is working (ETH; $eth) at $(date)">>/usr/local/minerLocalScript/ETH_ETC_switch/this_is_working.txt
	if [ "$current" = "etc" -o "$current_time" != "$current_run_time" ]
	then
		cp /usr/local/minerLocalScript/ETH_ETC_switch/eth_txt.txt /usr/local/minerLocalScript/ETH_ETC_switch/current.txt
		if [[ "$current_time" == "day" ]]
		then
			/bin/bash /usr/local/minerLocalScript/scriptDWETH.sh
			echo "Switching to eth day..."
			echo day>/usr/local/minerLocalScript/ETH_ETC_switch/current_run_time.txt
		else
			/bin/bash /usr/local/minerLocalScript/scriptNWETH.sh
			echo 'Switching to eth night...'
			echo night>/usr/local/minerLocalScript/ETH_ETC_switch/current_run_time.txt

		fi
	fi
else
	 echo "this is working (ETC; $etc) at $(date)">>/usr/local/minerLocalScript/ETH_ETC_switch/this_is_working.txt
	if [ "$current" = "eth" -o "$current_time" != "$current_run_time" ]
	then
		cp /usr/local/minerLocalScript/ETH_ETC_switch/etc_txt.txt /usr/local/minerLocalScript/ETH_ETC_switch/current.txt
                if [[ "$current_time" == "day" ]]
                then
			/bin/bash /usr/local/minerLocalScript/scriptDWETC.sh
			echo 'Switching to etc day...'
			echo day>/usr/local/minerLocalScript/ETH_ETC_switch/current_run_time.txt
		else
			/bin/bash /usr/local/minerLocalScript/scriptNWETC.sh
			echo 'Switching to etc night...'
			echo night>/usr/local/minerLocalScript/ETH_ETC_switch/current_run_time.txt

		fi
	fi
fi
