#!/bin/bash
#test modificar puertos apache
msg () {
BRAN='\033[1;37m' && VERMELHO='\e[31m' && VERDE='\e[32m' && AMARELO='\e[33m'
AZUL='\e[34m' && MAGENTA='\e[35m' && MAG='\033[1;36m' &&NEGRITO='\e[1m' && SEMCOR='\e[0m'
 case $1 in
  -ne)cor="${VERMELHO}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
  -ama)cor="${AMARELO}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verm)cor="${AMARELO}${NEGRITO}[!] ${VERMELHO}" && echo -e "${cor}${2}${SEMCOR}";;
  -azu)cor="${MAG}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -verd)cor="${VERDE}${NEGRITO}" && echo -e "${cor}${2}${SEMCOR}";;
  -bra)cor="${BRAN}${NEGRITO}" && echo -ne "${cor}${2}${SEMCOR}";;
  -bar2)cor="\e[0;31m========================================\e[0m" && echo -e "${cor}${SEMCOR}";;
  -bar)cor="\e[1;31m——————————————————————————————————————————————————————" && echo -e "${cor}${SEMCOR}";;
 esac
}

port () {
local portas
local portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
i=0
while read port; do
var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
[[ "$(echo -e ${portas}|grep -w "$var1 $var2")" ]] || {
    portas+="$var1 $var2 $portas"
    echo "$var1 $var2"
    let i++
    }
done <<< "$portas_var"
}

puertos_ver(){
local portasVAR=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
local NOREPEAT
local reQ
local Port
while read port; do
reQ=$(echo ${port}|awk '{print $1}')
Port=$(echo {$port} | awk '{print $9}' | awk -F ":" '{print $2}')
[[ $(echo -e $NOREPEAT|grep -w "$Port") ]] && continue
NOREPEAT+="$Port\n"
case ${reQ} in
apache|apache2)
[[ -z $APC ]] && local APC="\033[1;36m➫ \e[1;37mAPACHE:\033[1;32m"
APC+="$Port ";;
esac
done <<< "${portasVAR}"
[[ ! -z $APC ]]
echo -e $APC
msg -bar2
}

verify_port () {
local SERVICE="$1"
local PORTENTRY="$2"
[[ ! $(echo -e $(port|grep -v ${SERVICE})|grep -w "$PORTENTRY") ]] && return 0 || return 1
}
edit_apache () {
msg -azu "REDEFINIR PUERTOS APACHE"
msg -bar
local CONF="/etc/apache2/ports.conf"
local NEWCONF="$(cat ${CONF})"
msg -ne "Puerto Nuevo?: "
read -p "" newports
for PTS in `echo ${newports}`; do
verify_port apache "${PTS}" && echo -e "\033[1;33mPort $PTS \033[1;32mOK" || {
echo -e "\033[1;33mPort $PTS \033[1;31mFAIL"
return 1
}
done
rm ${CONF}
while read varline; do
if [[ $(echo ${varline}|grep -w "Listen") ]]; then
 if [[ -z ${END} ]]; then
 echo -e "Listen ${newports}" >> ${CONF}
 END="True"
 else
 echo -e "${varline}" >> ${CONF}
 fi
else
echo -e "${varline}" >> ${CONF}
fi
done <<< "${NEWCONF}"
msg -azu "AGUARDE"
service apache2 restart &>/dev/null
sleep 1s
msg -bar
msg -azu "PUERTOS REDEFINIDOS"
msg -bar
}
main_fun () {
clear
msg -bar2
msg -ama "                EDITAR PUERTOS ACTIVOS"
msg -bar2
puertos_ver
unset newports
i=0
while read line; do
let i++
          case $line in
          
          apache|apache2)apache=$i;; 
          
          esac
done <<< "$(port|cut -d' ' -f1|sort -u)"
for((a=1; a<=$i; a++)); do
[[ $apache = $a ]] && echo -ne "\033[1;32m [$apache] > " && msg -azu "MODIFICAR PUERTO APACHE"
done
echo -ne "$(msg -bar)\n\033[1;32m [0] > " && msg -azu "\e[97m\033[1;41m VOLVER \033[1;37m"
msg -bar
while true; do
echo -ne "\033[1;37mSeleccione: " && read selection
tput cuu1 && tput dl1
[[ ! -z $apache ]] && [[ $apache = $selection ]] && edit_apache && break
[[ "0" = $selection ]] && break
done
#exit 0
}
main_fun
