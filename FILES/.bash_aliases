alias sc='screen -RD'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get dist-upgrade' 
alias upgrade_dry='sudo apt-get dist-upgrade --dry-run | grep ^Inst | cut -d" " -f2' 
alias outdated='sudo apt-show-versions -u' 

alias temp='cat /sys/class/thermal/thermal_zone0/temp | awk '\''{print "Pis temperature: " $1/1000 " °C"}'\'''
alias freq='cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq | awk '\''{print "Pis frequency: " $1/1000 " Mhz"}'\'''
