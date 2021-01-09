#!/bin/bash

mac_address=$(ifconfig en0 | grep ether)
mac_address="${mac_address##	ether }"

printf '\e[36m%s\e[0m' "What is the mac address you would like to spoof? "
read spoof_address

valid_mac_test=$(echo "$spoof_address" | grep -E '^([0-9a-fA-F]{2}:){5}[0-9a-fA-F]{2}$')
while [ "$valid_mac_test" == "" ]
do
		printf '\e[31m%s\e[0m' "Bad MAC Address. Please try again: "
		read spoof_address
		valid_mac_test=$(echo "$spoof_address" | grep -E '^([[:alnum:]]{2}:){5}[[:alnum:]]{2}$')
done

sudo ifconfig en0 ether $spoof_address

echo "$mac_address" >> old_mac_address.txt
printf "$mac_address" | pbcopy

printf '\n\e[32m%s \e[0m' "Your previous mac address has been saved to \"old_mac_address.txt\" and copied to your clipboard. Now log in to the wifi network you want to connect your spoofed device."
printf '\n\e[36m%s \e[0m' "Let me know when you have connected to the wifi network (y):"
read logged_in

while [ "$logged_in" != "y" ]
do
		printf '\e[31m%s\e[0m' "Type the letter y and press enter when you have logged into the wifi network you wish to connect your device to: "
		read logged_in
done

sudo ifconfig en0 ether $mac_address

printf '\e[32m%s \e[0m' "Success! Your computer's mac address has been restored."
