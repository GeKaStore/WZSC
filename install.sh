#!/bin/bash

sysctl -w net.ipv6.conf.all.disable_ipv6=1 >/dev/null 2>&1
sysctl -w net.ipv6.conf.default.disable_ipv6=1 >/dev/null 2>&1
REPO="https://raw.githubusercontent.com/GeKaStore/WZSC/main/"
clear

apt update -y && apt upgrade -y && apt dist-upgrade -y
clear

red='\e[1;31m'
green='\e[0;32m'
yell='\e[1;33m'
BIBlue='\033[1;94m'
BGCOLOR='\e[1;97;101m'
tyblue='\e[1;36m'
NC='\e[0m'
purple() { echo -e "\\033[35;1m${*}\\033[0m"; }
tyblue() { echo -e "\\033[36;1m${*}\\033[0m"; }
yellow() { echo -e "\\033[33;1m${*}\\033[0m"; }
green() { echo -e "\\033[32;1m${*}\\033[0m"; }
red() { echo -e "\\033[31;1m${*}\\033[0m"; }

cd /root
if [ "${EUID}" -ne 0 ]; then
echo "You need to run this script as root"
exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
echo "OpenVZ is not supported"
exit 1
fi
localip=$(hostname -I | cut -d\  -f1)
hst=( `hostname` )
dart=$(cat /etc/hosts | grep -w `hostname` | awk '{print $2}')
if [[ "2" != "2" ]]; then
echo "$localip $(hostname)" >> /etc/hosts
fi

if [[ ! -f /root/.isp ]]; then
curl -sS ipinfo.io/org?token=44ae7fd0b5d0d5 > /root/.isp
fi
if [[ ! -f /root/.city ]]; then
curl -sS ipinfo.io/city?token=44ae7fd0b5d0d5 > /root/.city
fi
if [[ ! -f /root/.myip ]]; then
curl -sS ipv4.icanhazip.com > /root/.myip
fi

export MYIP=$(cat /root/.myip);
export ISP=$(cat /root/.isp);
export CITY=$(cat /root/.city);
source /etc/os-release

function lane_atas() {
echo -e "${BIBlue}┌──────────────────────────────────────────┐${NC}"
}
function lane_bawah() {
echo -e "${BIBlue}└──────────────────────────────────────────┘${NC}"
}

data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
url_izin="https://raw.githubusercontent.com/GeKaStore/vps_access/main/ip"
client=$(curl -sS $url_izin | grep $MYIP | awk '{print $2}')
exp=$(curl -sS $url_izin | grep $MYIP | awk '{print $3}')
today=`date -d "0 days" +"%Y-%m-%d"`
time=$(printf '%(%H:%M:%S)T')
date=$(date +'%d-%m-%Y')
d1=$(date -d "$exp" +%s)
d2=$(date -d "$today" +%s)
certifacate=$(((d1 - d2) / 86400))
checking_sc() {
  useexp=$(curl -s $url_izin | grep $MYIP | awk '{print $3}')
  if [[ $date_list < $useexp ]]; then
    echo -ne
  else
    clear
    echo -e "\033[96m============================================\033[0m"
    echo -e "\033[44;37m           NotAllowed Autoscript         \033[0m"    
    echo -e "\033[96m============================================\033[0m"
    echo -e "\e[95;1m buy / sewa AutoScript installer VPS \e[0m"
    echo -e "\033[96m============================================\033[0m"    
    echo -e "\e[96;1m   1 IP        : Rp.10.000   \e[0m"
    echo -e "\e[96;1m   2 IP        : Rp.15.000   \e[0m"   
    echo -e "\e[96;1m   7 IP        : Rp.40.000   \e[0m"
    echo -e "\e[96;1m   Unli IP     : Rp.150.000  \e[0m"
    echo -e "\e[97;1m   open source : Rp.400.000  \e[0m"       
    echo -e ""
    echo -e "\033[34m Contack WA/TLP: 087760204418     \033[0m"
    echo -e "\033[34m Telegram user : t.me/WuzzSTORE \033[0m"    
    echo -e "\033[96m============================================\033[0m"
    echo -e ""
  fi
}
checking_sc
clear

function ARCHITECTURE() {
if [[ "$( uname -m | awk '{print $1}' )" == "x86_64" ]]; then
    echo -ne
else
    echo -e "${r} Your Architecture Is Not Supported ( ${y}$( uname -m )${NC} )"
    exit 1
fi

if [[ ${ID} == "ubuntu" || ${ID} == "debian" ]]; then
    echo -ne
else
    echo -e " ${r}This Script only Support for OS ubuntu 20.04 & debian 10"
    exit 0
fi
}
ARCHITECTURE
clear

clear
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}             MASUKKAN NAMA KAMU         ${NC}${BIBlue} │${NC}"
lane_bawah
echo " "
until [[ $name =~ ^[a-zA-Z0-9_.-]+$ ]]; do
read -rp "Masukan Nama Kamu Disini ( tanpa spasi ): " -e name
done
mkdir -p /etc/xray
echo "$name" > /etc/xray/username
echo ""
clear
author=$(cat /etc/xray/username)
echo ""
echo ""


lane_atas
echo -e  "${BIBlue}│              \033[1;37mSETUP DOMAIN                ${BIBlue}│${NC}"
lane_bawah
echo " "
until [[ $dnss =~ ^[a-zA-Z0-9_.-]+$ ]]; do 
read -rp "Masukan domain kamu Disini : " -e dnss
done
rm -rf /etc/v2ray
rm -rf /etc/nsdomain
rm -rf /etc/per
mkdir -p /etc/v2ray
mkdir -p /etc/nsdomain
touch /etc/xray/domain
touch /etc/v2ray/domain
touch /etc/xray/slwdomain
touch /etc/v2ray/scdomain
echo "$dnss" > /root/domain
echo "$dnss" > /root/scdomain
echo "$dnss" > /etc/xray/scdomain
echo "$dnss" > /etc/v2ray/scdomain
echo "$dnss" > /etc/xray/domain
echo "$dnss" > /etc/v2ray/domain
echo "IP=$dnss" > /var/lib/ipvps.conf
echo ""
clear

function instalasi(){
ins_tools(){
wget ${REPO}tools.sh >/dev/null 2>&1
chmod +x tools.sh && bash tools.sh >/dev/null 2>&1
start=$(date +%s)
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime
apt install git curl -y >/dev/null 2>&1
apt install python -y >/dev/null 2>&1
}

ins_ssh_sshws(){
wget ${REPO}install/ssh-vpn.sh >/dev/null 2>&1
chmod +x ssh-vpn.sh && ./ssh-vpn.sh >/dev/null 2>&1
wget ${REPO}sshws/insshws.sh >/dev/null 2>&1
chmod +x insshws.sh && ./insshws.sh >/dev/null 2>&1
}

ins_xray() {
wget ${REPO}install/ins-xray.sh >/dev/null 2>&1
chmod +x ins-xray.sh && ./ins-xray.sh >/dev/null 2>&1
}

ins_backup() {
wget ${REPO}install/set-br.sh >/dev/null 2>&1
chmod +x set-br.sh && ./set-br.sh >/dev/null 2>&1
}

ins_ohp() {
wget ${REPO}sshws/ohp.sh >/dev/null 2>&1
chmod +x ohp.sh && ./ohp.sh >/dev/null 2>&1
}

ins_menu() {
wget ${REPO}menu/update.sh >/dev/null 2>&1
chmod +x update.sh && ./update.sh >/dev/null 2>&1
}

ins_slowdns() {
wget ${REPO}slowdns/installsl.sh >/dev/null 2>&1
chmod +x installsl.sh && bash installsl.sh >/dev/null 2>&1
}

ins_udp() {
wget ${REPO}install/udp-custom.sh >/dev/null 2>&1
chmod +x udp-custom.sh && bash udp-custom.sh >/dev/null 2>&1
}
if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
echo -e "${green} Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${NC}"
start_instalasi
elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
echo -e "${green} Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${NC}"
start_instalasi
else
echo -e " Your OS Is Not Supported ( ${YELLOW}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${FONT} )"
fi

}

function start_instalasi(){
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}         PROCCESS INSTALL TOOLS         ${NC}${BIBlue} │${NC}"
lane_bawah
ins_tools
echo ""
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}     PROCCESS INSTALL SSH & OVPN        ${NC}${BIBlue} │${NC}"
lane_bawah
ins_ssh_sshws
echo ""
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}         PROCCESS INSTALL XRAY          ${NC}${BIBlue} │${NC}"
lane_bawah
ins_xray
echo ""
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}      PROCCESS INSTALL BACKUP MENU      ${NC}${BIBlue} │${NC}"
lane_bawah
ins_backup
echo ""
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}          PROCCESS INSTALL OHP          ${NC}${BIBlue} │${NC}"
lane_bawah
ins_ohp
echo ""
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}      PROCCESS INSTALL EXTRA MENU       ${NC}${BIBlue} │${NC}"
lane_bawah
ins_menu
echo ""
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}       PROCCESS INSTALL SLOW DNS        ${NC}${BIBlue} │${NC}"
lane_bawah
ins_slowdns
echo ""
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}      PROCCESS INSTALL UDP CUSTOM       ${NC}${BIBlue} │${NC}"
lane_bawah
ins_udp
}

function iinfo(){
domain=$(cat /etc/xray/domain)
TIMES="10"
CHATID="6686272246"
KEY="7958041819:AAEQiOtnCyWLps_QNf7qiGGHqOASmM2Klf4"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TIME=$(date +'%Y-%m-%d %H:%M:%S')
RAMMS=$(free -m | awk 'NR==2 {print $2}')
MODEL2=$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')
IZIN=$(curl -sS https://raw.githubusercontent.com/GeKaStore/vps_access/main/ip | grep $MYIP | awk '{print $3}' )
d1=$(date -d "$IZIN" +%s)
d2=$(date -d "$today" +%s)
EXP=$(( (d1 - d2) / 86400 ))

TEXT="
<code>━━━━━━━━━━━━━━━━━━━━</code>
<code>⚠️ AUTOSCRIPT PREMIUM ⚠️</code>
<code>━━━━━━━━━━━━━━━━━━━━</code>
<code>NAME : </code><code>${author}</code>
<code>TIME : </code><code>${TIME} WIB</code>
<code>DOMAIN : </code><code>${domain}</code>
<code>IP : </code><code>${MYIP}</code>
<code>ISP : </code><code>${ISP} ${CITY}</code>
<code>OS LINUX : </code><code>${MODEL2}</code>
<code>RAM : </code><code>${RAMMS} MB</code>
<code>EXP SCRIPT : </code><code>$EXP Days</code>
<code>━━━━━━━━━━━━━━━━━━━━</code>
<i> Notifikasi Installer Script...</i>
"'&reply_markup={"inline_keyboard":[[{"text":"🔥ᴏʀᴅᴇʀ","url":"https://t.me/WuzzSTORE"},{"text":"🔥WA","url":"https://wa.me/6287760204418"}]]}'
curl -s --max-time $TIMES -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
clear
}

# Tentukan nilai baru yang diinginkan untuk fs.file-max
NEW_FILE_MAX=65535  # Ubah sesuai kebutuhan Anda

# Nilai tambahan untuk konfigurasi netfilter
NF_CONNTRACK_MAX="net.netfilter.nf_conntrack_max=262144"
NF_CONNTRACK_TIMEOUT="net.netfilter.nf_conntrack_tcp_timeout_time_wait=30"

# File yang akan diedit
SYSCTL_CONF="/etc/sysctl.conf"

# Ambil nilai fs.file-max saat ini
CURRENT_FILE_MAX=$(grep "^fs.file-max" "$SYSCTL_CONF" | awk '{print $3}' 2>/dev/null)

# Cek apakah nilai fs.file-max sudah sesuai
if [ "$CURRENT_FILE_MAX" != "$NEW_FILE_MAX" ]; then
    # Cek apakah fs.file-max sudah ada di file
    if grep -q "^fs.file-max" "$SYSCTL_CONF"; then
        # Jika ada, ubah nilainya
        sed -i "s/^fs.file-max.*/fs.file-max = $NEW_FILE_MAX/" "$SYSCTL_CONF" >/dev/null 2>&1
    else
        # Jika tidak ada, tambahkan baris baru
        echo "fs.file-max = $NEW_FILE_MAX" >> "$SYSCTL_CONF" 2>/dev/null
    fi
fi

# Cek apakah net.netfilter.nf_conntrack_max sudah ada
if ! grep -q "^net.netfilter.nf_conntrack_max" "$SYSCTL_CONF"; then
    echo "$NF_CONNTRACK_MAX" >> "$SYSCTL_CONF" 2>/dev/null
fi

# Cek apakah net.netfilter.nf_conntrack_tcp_timeout_time_wait sudah ada
if ! grep -q "^net.netfilter.nf_conntrack_tcp_timeout_time_wait" "$SYSCTL_CONF"; then
    echo "$NF_CONNTRACK_TIMEOUT" >> "$SYSCTL_CONF" 2>/dev/null
fi

sysctl -p >/dev/null 2>&1
instalasi

sudo systemctl disable systemd-resolved
sudo systemctl stop systemd-resolved
sudo rm /etc/resolv.config
echo -e "nameserver 8.8.8.8\nnameserver 8.8.4.4" | sudo tee /etc/resolv.conf
sudo chattr +i /etc/resolv.conf
sudo systemctl start systemd-resolved
sudo systemctl enable systemd-resolved
cat> /etc/xray/usernamee << END
if [ "$BASH" ]; then
if [ -f ~/.bashrc ]; then
. ~/.bashrc
fi
fi
mesg n || true
clear
welcome
END
chmod 644 /etc/xray/usernamee
if [ -f "/root/log-install.txt" ]; then
rm /root/log-install.txt > /dev/null 2>&1
fi
if [ -f "/etc/afak.conf" ]; then
rm /etc/afak.conf > /dev/null 2>&1
fi
history -c
serverV=$( curl -sS ${REPO}versi  )
echo $serverV > /opt/.ver
echo "00" > /home/daily_reboot
aureb=$(cat /home/daily_reboot)
b=11
if [ $aureb -gt $b ]
then
gg="PM"
else
gg="AM"
fi
cd

rm /root/tools.sh >/dev/null 2>&1
rm /root/setup.sh >/dev/null 2>&1
rm /root/pointing.sh >/dev/null 2>&1
rm /root/ssh-vpn.sh >/dev/null 2>&1
rm /root/ins-xray.sh >/dev/null 2>&1
rm /root/insshws.sh >/dev/null 2>&1
rm /root/set-br.sh >/dev/null 2>&1
rm /root/ohp.sh >/dev/null 2>&1
rm /root/update.sh >/dev/null 2>&1
rm /root/installsl.sh >/dev/null 2>&1
rm /root/udp-custom.sh >/dev/null 2>&1
secs_to_human "$(($(date +%s) - ${start}))" | tee -a log-install.txt
sleep 3
echo  ""
cd
iinfo
clear
echo -e ""
lane_atas
echo -e "${BIBlue}│ ${BGCOLOR}            INSTALASI SELESAI           ${NC}${BIBlue} │${NC}"
lane_bawah
echo -e ""
sleep 3

reboot
