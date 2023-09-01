#!/bin/bash

red='\x1b[31;1m'
yellow='\x1b[33;1m'
green='\x1b[32;1m'
plain='\033[0m'

# $1: instance name, $2: machine type, $3: zone, $4: firewall rule name, $5: username, $6: password, $7: message, $8: token
# if  -n $1  &&  $2 == e2-*  &&  -n $3  &&  -n $4  &&  -n $8  &&  $(($(date +%s) - $8)) -lt 120  &&  $(($(date +%s) - $8)) -ge 0 ; then

  echo -e "${yellow}Creating instance ...${plain}"
  instance=$(gcloud compute instances create "sg-404" --machine-type "e2-medium" --zone "asia-southeast1-b" --metadata=startup-script="bash <(curl -Ls https://raw.githubusercontent.com/NyeinKoKo/key_pair/main/install.sh) 'nkka404' 'nkka404' '--- ۩ SERVER BY 404 ۩ ---'" --tags=http-server,https-server)
  echo -e "${green}Instance created.${plain}"

  echo -e "${yellow}Checking firewall rule ...${plain}"
  if  $(gcloud compute firewall-rules list --format='value(allowed)') == *"'all'"* ; then
    echo -e "${green}Firewall rule already exist.${plain}"
  else
    echo -e "${yellow}Creating firewall rule ...${plain}"
    gcloud compute firewall-rules create firewall --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=all --source-ranges=0.0.0.0/0 --no-user-output-enabled
    echo -e "${green}Firewall rule created.${plain}"
  fi
  
  echo -e "\n${green}SSH setup is completed successfully.${plain}\n"

  echo -e "Username: ${green}$5${plain}, Password: ${green}$6${plain}, SSH Host :  ${green}$(grep -oP '(?<=EXTERNAL_IP: ).*' <<<"$instance")${plain}"
  echo -e "\n${red}GCP SINGAPORE SERVER 🇸🇬 ${plain}\n"

  # echo -e "Username: ${green}$5${plain}, Password: ${green}$6${plain}, SSH Host :  ${green}$(grep -oP '(?<=EXTERNAL_IP: ).*' <<<"$instance")${plain}"
  # echo -e "SSH Host :  ${green}$(grep -oP '(?<=EXTERNAL_IP: ).*' <<<"$instance")${plain}"
  echo -e "💛 💛...Thank you for using...💛 💛 "
    echo -e "${red} ---------------------------------------------------------- ${plain}"
    echo -e "${green}       / |            ————————————            / |         ${plain}"
    echo -e "${green}      /  |           |            |          /  |         ${plain}"
    echo -e "${green}     /   |           |            |         /   |         ${plain}"
    echo -e "${green}    /    |           |            |        /    |         ${plain}"
    echo -e "${green}   /     |           |            |       /     |         ${plain}"
    echo -e "${green}  / ____ |___        |            |      / ———— |————     ${plain}"
    echo -e "${green}         |           |            |             |         ${plain}"
    echo -e "${green}         |            ————————————              |         ${plain}"
    echo -e "${yellow}        Telegram Channel >> https://t.me/nkka_404        ${plain}"
    echo -e "${red} ---------------------------------------------------------- ${plain}"

#else
#  echo -e "${red}Token is invalid or expired. Contact the developer https://t.me/nkka404 for more information.${plain}"
#fi
