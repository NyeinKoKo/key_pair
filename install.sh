#!/bin/bash

red='\x1b[31;1m'
yellow='\x1b[33;1m'
green='\x1b[32;1m'
plain='\033[0m'

# $1: username, $2: password, $3: message, $4: token

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}Error: ${plain} You must use root user to run this script!\n" && exit 1

#if [[ -n $4 ]] && [[ $(($(date +%s) - $4)) -lt 120 ]] && [[ $(($(date +%s) - $4)) -ge 0 ]]; then

#else
#  echo -e "${red}Token is invalid or expired. Contact the developer https://t.me/kaungkhantx for more information.${plain}"
#fi

echo ""
echo "------------------------------------"
printf "  ERROR.... ❌ ❌ ❌ ❌"
echo "------------------------------------"
echo ""

echo -e "${yellow} ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ ${plain}"
echo -e "${GREEN}       / |            ————————————            / |                    ${plain}"
echo -e "${GREEN}      /  |           |            |          /  |                    ${plain}"
echo -e "${GREEN}     /   |           |            |         /   |                    ${plain}"
echo -e "${GREEN}    /    |           |            |        /    |                    ${plain}"
echo -e "${GREEN}   /     |           |            |       /     |                    ${plain}"
echo -e "${GREEN}  / ____ |___        |            |      / ———— |————                ${plain}"
echo -e "${GREEN}         |           |            |             |                    ${plain}"
echo -e "${GREEN}         |            ————————————              |         t.me/Pmttg ${plain}"
echo -e "${red}    Contact the developer https://t.me/nkka404 for more information    ${plain}"
echo -e "${yellow} ▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬▬ ${plain}"
