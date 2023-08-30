#!/bin/bash

red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

cur_dir=$(pwd)

# check root
[[ $EUID -ne 0 ]] && echo -e "${red}အမှား：${plain} ဤ script ကို root အသုံးပြုသူအဖြစ် run ရပါမည်။！\n" && exit 1

# check os
if [[ -f /etc/redhat-release ]]; then
    release="centos"
elif cat /etc/issue | grep -Eqi "debian"; then
    release="debian"
elif cat /etc/issue | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /etc/issue | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
elif cat /proc/version | grep -Eqi "debian"; then
    release="debian"
elif cat /proc/version | grep -Eqi "ubuntu"; then
    release="ubuntu"
elif cat /proc/version | grep -Eqi "centos|red hat|redhat"; then
    release="centos"
else
    echo -e "${red}စနစ်ဗားရှင်းကို ရှာမတွေ့ပါ၊ ကျေးဇူးပြု၍ 404 ကို ဆက်သွယ်ပါ။！${plain}\n" && exit 1
fi

arch=$(arch)

if [[ $arch == "x86_64" || $arch == "x64" || $arch == "amd64" ]]; then
    arch="amd64"
elif [[ $arch == "aarch64" || $arch == "arm64" ]]; then
    arch="arm64"
elif [[ $arch == "s390x" ]]; then
    arch="s390x"
else
    arch="amd64"
    echo -e "${red}ဗိသုကာလက်ရာကို ရှာမတွေ့ပါ၊ မူရင်းဗိသုကာကို သုံးပါ။: ${arch}${plain}"
fi

echo "ဗိသုကာပညာ: ${arch}"

if [ $(getconf WORD_BIT) != '32' ] && [ $(getconf LONG_BIT) != '64' ]; then
    echo "ဤဆော့ဖ်ဝဲသည် 32-bit စနစ်များကို မပံ့ပိုးပါ။(x86)，ကျေးဇူးပြု၍ 64-bit စနစ် (x86_64) ကိုသုံးပါ။ ထောက်လှမ်းမှု မမှန်ကန်ပါက စာရေးသူထံ ဆက်သွယ်ပါ။"
    exit -1
fi

os_version=""

# os version
if [[ -f /etc/os-release ]]; then
    os_version=$(awk -F'[= ."]' '/VERSION_ID/{print $3}' /etc/os-release)
fi
if [[ -z "$os_version" && -f /etc/lsb-release ]]; then
    os_version=$(awk -F'[= ."]+' '/DISTRIB_RELEASE/{print $2}' /etc/lsb-release)
fi

if [[ x"${release}" == x"centos" ]]; then
    if [[ ${os_version} -le 6 ]]; then
        echo -e "${red}请使用 CentOS 7 或更高版本的系统！${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"ubuntu" ]]; then
    if [[ ${os_version} -lt 16 ]]; then
        echo -e "${red}ကျေးဇူးပြု၍ သုံးပါ။ Ubuntu 16 သို့မဟုတ် နောက်ပိုင်းစနစ်！${plain}\n" && exit 1
    fi
elif [[ x"${release}" == x"debian" ]]; then
    if [[ ${os_version} -lt 8 ]]; then
        echo -e "${red}ကျေးဇူးပြု၍ သုံးပါ။ Debian 8 သို့မဟုတ် နောက်ပိုင်းစနစ်！${plain}\n" && exit 1
    fi
fi

install_base() {
    if [[ x"${release}" == x"centos" ]]; then
        yum install wget curl tar -y
    else
        apt install wget curl tar -y
    fi
}

#This function will be called when user installed x-ui out of sercurity
config_after_install() {
    echo -e "${yellow}လုံခြုံရေးအကြောင်းပြချက်အတွက်၊ တပ်ဆင်ခြင်း/အပ်ဒိတ် ပြီးစီးပြီးနောက် သင်သည် ဆိပ်ကမ်းနှင့် အကောင့်စကားဝှက်ကို အတင်းအကျပ်ပြောင်းရန် လိုအပ်သည်။${plain}"
    read -p "ဆက်ရန်ရှိမရှိ အတည်ပြုပါ.?[y/n]": config_confirm
    if [[ x"${config_confirm}" == x"y" || x"${config_confirm}" == x"Y" ]]; then
        read -p "သင့်အကောင့်အမည်ကို သတ်မှတ်ပေးပါ။:" config_account
        echo -e "${yellow}သင့်အကောင့်အမည်ကို သတ်မှတ်ပေးပါသည်။:${config_account}${plain}"
        read -p "သင့်အကောင့်စကားဝှက်ကို သတ်မှတ်ပေးပါ။:" config_password
        echo -e "${yellow}သင့်အကောင့် စကားဝှက်ကို သတ်မှတ်ပေးပါသည်။:${config_password}${plain}"
        read -p "အကန့်ဝင်ရောက်ခွင့် Portကို ကျေးဇူးပြု၍ သတ်မှတ်ပါ။:" config_port
        echo -e "${yellow}သင့်အကန့်၏ ဝင်ရောက်ခွင့် Portကို သတ်မှတ်ထားပါသည်။:${config_port}${plain}"
        echo -e "${yellow}ဆက်တင်များ၊ ဆက်တင်များကို အတည်ပြုပါ။${plain}"
        /usr/local/x-ui/x-ui setting -username ${config_account} -password ${config_password}
        echo -e "${yellow}အကောင့် စကားဝှက် ဆက်တင်ကို ပြီးပါပြီ။${plain}"
        /usr/local/x-ui/x-ui setting -port ${config_port}
        echo -e "${yellow}အကန့် ဆိပ်ကမ်း ဆက်တင် ပြီးပါပြီ။${plain}"
    else
        echo -e "${red}ပယ်ဖျက်လိုက်သည်၊ ဆက်တင်အရာအားလုံးသည် မူရင်းဆက်တင်များဖြစ်သည်၊ ကျေးဇူးပြု၍ အချိန်မီပြင်ဆင်ပါ။${plain}"
    fi
}

install_x-ui() {
    systemctl stop x-ui
    cd /usr/local/

    if [ $# == 0 ]; then
        last_version=$(curl -Ls "https://api.github.com/repos/vaxilu/x-ui/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
        if [[ ! -n "$last_version" ]]; then
            echo -e "${red}x-ui ဗားရှင်းကို ရှာမတွေ့နိုင်ခဲ့ပါ၊ ၎င်းသည် Github API ၏ ကန့်သတ်ချက်ထက် ကျော်လွန်နေနိုင်သည်၊ ကျေးဇူးပြု၍ နောက်မှ ထပ်မံကြိုးစားပါ၊ သို့မဟုတ် ထည့်သွင်းရန် x-ui ဗားရှင်းကို ကိုယ်တိုင်သတ်မှတ်ပါ။${plain}"
            exit 1
        fi
        echo -e "x-ui ၏ နောက်ဆုံးဗားရှင်းကို ရှာဖွေတွေ့ရှိခဲ့သည်။：${last_version}，စတင်တပ်ဆင်ပါ။"
        wget -N --no-check-certificate -O /usr/local/x-ui-linux-${arch}.tar.gz https://github.com/vaxilu/x-ui/releases/download/${last_version}/x-ui-linux-${arch}.tar.gz
        if [[ $? -ne 0 ]]; then
            echo -e "${red}x-ui ကို ဒေါင်းလုဒ်လုပ်ရန် မအောင်မြင်ပါ၊ သင့်ဆာဗာသည် Github ဖိုင်များကို ဒေါင်းလုဒ်လုပ်နိုင်ကြောင်း သေချာပါစေ။${plain}"
            exit 1
        fi
    else
        last_version=$1
        url="https://github.com/vaxilu/x-ui/releases/download/${last_version}/x-ui-linux-${arch}.tar.gz"
        echo -e "စတင်တပ်ဆင်ပါ။ x-ui v$1"
        wget -N --no-check-certificate -O /usr/local/x-ui-linux-${arch}.tar.gz ${url}
        if [[ $? -ne 0 ]]; then
            echo -e "${red}ဒေါင်းလုဒ်လုပ်ပါ။ x-ui v$1 မအောင်မြင်ပါ၊ ဤဗားရှင်းရှိနေကြောင်း သေချာပါစေ။${plain}"
            exit 1
        fi
    fi

    if [[ -e /usr/local/x-ui/ ]]; then
        rm /usr/local/x-ui/ -rf
    fi

    tar zxvf x-ui-linux-${arch}.tar.gz
    rm x-ui-linux-${arch}.tar.gz -f
    cd x-ui
    chmod +x x-ui bin/xray-linux-${arch}
    cp -f x-ui.service /etc/systemd/system/
    wget --no-check-certificate -O /usr/bin/x-ui https://raw.githubusercontent.com/vaxilu/x-ui/main/x-ui.sh
    chmod +x /usr/local/x-ui/x-ui.sh
    chmod +x /usr/bin/x-ui
    config_after_install
    #echo -e "如果是全新安装，默认网页端口为 ${green}54321${plain}，用户名和密码默认都是 ${green}admin${plain}"
    #echo -e "请自行确保此端口没有被其他程序占用，${yellow}并且确保 54321 端口已放行${plain}"
    #    echo -e "若想将 54321 修改为其它端口，输入 x-ui 命令进行修改，同样也要确保你修改的端口也是放行的"
    #echo -e ""
    #echo -e "如果是更新面板，则按你之前的方式访问面板"
    #echo -e ""
    systemctl daemon-reload
    systemctl enable x-ui
    systemctl start x-ui
    echo -e "${green}x-ui v${last_version}${plain} တပ်ဆင်မှုပြီးမြောက်ပြီး အကန့်ကို စဖွင့်ပါပြီ။，"
    echo -e ""
    echo -e "💛💛အသုံးပြုခြင်းအတွက် ကျေးဇူးတင်ပါသည်။💛💛 "
    echo -e "----------------------------------------------"
    echo -e "\nProudly developed by ...${yellow}
     _  __         _ _ __                         
    | |/ /        |  |/ /                  /|    _____      /|
    | ' /  __ _   |  ' /   —— —           / |   |     |    / |
    |  <  |    |  |   <   |    |         /  |   |     |   /  |
    | . \ |    |  |  . \  |    |        ——————— |     |  ————————
    |_|\_\|____|  |_|\__\ |____| ________   |    —————       |    _____${plain}(ɔ◔‿◔)ɔ ${red}♥${yellow}
                                                           
                  ${green}https://t.me/nkka404${plain}
"
    echo -e "----------------------------------------------"
}

echo -e "${green}စတင်တပ်ဆင်ပါ။${plain}"
install_base
install_x-ui $1
