#####################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
#####################################################

source /etc/functions.sh
source /etc/multipool.conf

if [ -f "$STORAGE_ROOT/yiimp/.wireguard_public.conf" ]; then
  source "$STORAGE_ROOT/yiimp/.wireguard_public.conf"
else
  wireguard='false'
fi

dialog --title "Using Sub-Domain" \
--yesno "Are you using a sub-domain for the main website domain? Example pool.example.com?" 7 60
response=$?
  case $response in
     0) UsingSubDomain=yes;;
     1) UsingSubDomain=no;;
     255) echo "[ESC] key pressed.";;
esac

if [ -z "${DomainName:-}" ]; then
DEFAULT_DomainName=example.com
input_box "Domain Name" \
"Enter your domain name. If using a subdomain enter the full domain as in pool.example.com
\n\nDo not add www. to the domain name.
\n\nDomain Name:" \
$DEFAULT_DomainName \
DomainName

if [ -z "$DomainName" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "${StratumURL:-}" ]; then
DEFAULT_StratumURL=stratum.$DomainName
input_box "Stratum URL" \
"Enter your stratum URL. It is recommended to use another subdomain such as stratum.$DomainName
\n\nDo not add www. to the domain name.
\n\nStratum URL:" \
$DEFAULT_StratumURL \
StratumURL

if [ -z "$StratumURL" ]; then
# user hit ESC/cancel
exit
fi
fi

dialog --title "Install SSL" \
--yesno "Would you like the system to install SSL automatically?" 7 60
response=$?
  case $response in
     0) InstallSSL=yes;;
     1) InstallSSL=no;;
     255) echo "[ESC] key pressed.";;
esac

if [ -z "${SupportEmail:-}" ]; then
DEFAULT_SupportEmail=root@localhost
input_box "System Email" \
"Enter an email address for the system to send alerts and other important messages.
\n\nSystem Email:" \
$DEFAULT_SupportEmail \
SupportEmail

if [ -z "$SupportEmail" ]; then
# user hit ESC/cancel
exit
fi
fi


# Get the IP addresses of the local network interface(s).
if [ -z "${DBInternalIP:-}" ]; then
DEFAULT_DBInternalIP='10.0.0.2'
input_box "DB Server Private IP" \
"Enter the private IP address of the DB Server, as given to you by your provider.
\n\nIf you do not have one from your provider leave the Wireguard default below.
\n\nPrivate IP address:" \
$DEFAULT_DBInternalIP \
DBInternalIP

if [ -z "$DBInternalIP" ]; then
user hit ESC/cancel
exit
fi
fi

if [ -z "${WebInternalIP:-}" ]; then
DEFAULT_WebInternalIP='10.0.0.3'
input_box "Web Server Private IP" \
"Enter the private IP address of the Web Server, as given to you by your provider.
\n\nIf you do not have one from your provider leave the Wireguard default below.
\n\nPrivate IP address:" \
$DEFAULT_WebInternalIP \
WebInternalIP

if [ -z "$WebInternalIP" ]; then
user hit ESC/cancel
exit
fi
fi

if [ -z "${WebUser:-}" ]; then
DEFAULT_WebUser='yiimpadmin'
input_box "Web Server User Name" \
"Enter the user name of the Web Server.
\n\nThis is required for setup to complete.
\n\nWeb Server User Name:" \
$DEFAULT_WebUser \
WebUser

if [ -z "$WebUser" ]; then
user hit ESC/cancel
exit
fi
fi

if [ -z "${WebPass:-}" ]; then
DEFAULT_WebPass='password'
input_box "Web Server User Password" \
"Enter the user password of the Web Server.
\n\nThis is required for setup to complete.
\n\nWhen pasting your password CTRL+V does NOT work, you must either SHIFT+RightMouseClick or SHIFT+INSERT!!
\n\nWeb Server User Password:" \
$DEFAULT_WebPass \
WebPass

if [ -z "$WebPass" ]; then
user hit ESC/cancel
exit
fi
fi

if [ -z "${StratumInternalIP:-}" ]; then
DEFAULT_StratumInternalIP='10.0.0.4'
input_box "Stratum Server Private IP" \
"Enter the private IP address of the Stratum Server, as given to you by your provider.
\n\nIf you do not have one from your provider leave the Wireguard default below.
\n\nPrivate IP address:" \
$DEFAULT_StratumInternalIP \
StratumInternalIP

if [ -z "$StratumInternalIP" ]; then
user hit ESC/cancel
exit
fi
fi

if [ -z "${StratumUser:-}" ]; then
DEFAULT_StratumUser='yiimpadmin'
input_box "Stratum Server User Name" \
"Enter the user name of the Stratum Server.
\n\nThis is required for setup to complete.
\n\nStratum Server User Name:" \
$DEFAULT_StratumUser \
StratumUser

if [ -z "$StratumUser" ]; then
user hit ESC/cancel
exit
fi
fi

if [ -z "${StratumPass:-}" ]; then
DEFAULT_StratumPass='password'
input_box "Stratum Server User Password" \
"Enter the user password of the Stratum Server.
\n\nThis is required for setup to complete.
\n\nWhen pasting your password CTRL+V does NOT work, you must either SHIFT+RightMouseClick or SHIFT+INSERT!!
\n\nStratum Server User Password:" \
$DEFAULT_StratumPass \
StratumPass

if [ -z "$StratumPass" ]; then
user hit ESC/cancel
exit
fi
fi

if [ -z "${DaemonInternalIP:-}" ]; then
DEFAULT_DaemonInternalIP='10.0.0.5'
input_box "Daemon Server Private IP" \
"Enter the private IP address of the Daemon Server, as given to you by your provider.
\n\nIf you do not have one from your provider leave the Wireguard default below.
\n\nPrivate IP address:" \
$DEFAULT_DaemonInternalIP \
DaemonInternalIP

if [ -z "$DaemonInternalIP" ]; then
user hit ESC/cancel
exit
fi
fi

if [ -z "${DaemonUser:-}" ]; then
DEFAULT_DaemonUser='yiimpadmin'
input_box "Daemon Server User Name" \
"Enter the user name of the Daemon Server.
\n\nThis is required for setup to complete.
\n\nDaemon Server User Name:" \
$DEFAULT_DaemonUser \
DaemonUser

if [ -z "$DaemonUser" ]; then
user hit ESC/cancel
exit
fi
fi

if [ -z "${DaemonPass:-}" ]; then
DEFAULT_DaemonPass='password'
input_box "Daemon Server User Password" \
"Enter the user password of the Daemon Server.
\n\nThis is required for setup to complete.
\n\nWhen pasting your password CTRL+V does NOT work, you must either SHIFT+RightMouseClick or SHIFT+INSERT!!
\n\nDaemon Server User Password:" \
$DEFAULT_DaemonPass \
DaemonPass

if [ -z "$DaemonPass" ]; then
user hit ESC/cancel
exit
fi
fi

dialog --title "Use AutoExchange" \
--yesno "Would you like the stratum to be built with autoexchange enabled?" 7 60
response=$?
case $response in
   0) AutoExchange=yes;;
   1) AutoExchange=no;;
   255) echo "[ESC] key pressed.";;
esac

dialog --title "Use Dedicated Coin Ports" \
--yesno "Would you like YiiMP to be built with dedicated coin ports?" 7 60
response=$?
case $response in
   0) CoinPort=yes;;
   1) CoinPort=no;;
   255) echo "[ESC] key pressed.";;
esac

if [ -z "${PublicIP:-}" ]; then
  if pstree -p | egrep --quiet --extended-regexp ".*sshd.*\($$\)"; then
    DEFAULT_PublicIP=$(echo $SSH_CLIENT | awk '{ print $1}')
    else
    DEFAULT_PublicIP=192.168.0.1
fi
input_box "Your Public IP" \
"Enter your public IP from the remote system you will access your admin panel from.
\n\nWe have guessed your public IP from the IP used to access this system.
\n\nGo to whatsmyip.org if you are unsure this is your public IP.
\n\nYour Public IP:" \
$DEFAULT_PublicIP \
PublicIP

if [ -z "$PublicIP" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "${DBRootPassword:-}" ]; then
DEFAULT_DBRootPassword=$(openssl rand -base64 29 | tr -d "=+/")
input_box "Database Root Password" \
"Enter your desired database root password.
\n\nYou may use the system generated password shown.
\n\nDesired Database Password:" \
$DEFAULT_DBRootPassword \
DBRootPassword

if [ -z "$DBRootPassword" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "${PanelUserDBPassword:-}" ]; then
DEFAULT_PanelUserDBPassword=$(openssl rand -base64 29 | tr -d "=+/")
input_box "Database Panel Password" \
"Enter your desired database panel password.
\n\nYou may use the system generated password shown.
\n\nDesired Database Password:" \
$DEFAULT_PanelUserDBPassword \
PanelUserDBPassword

if [ -z "$PanelUserDBPassword" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "${StratumUserDBPassword:-}" ]; then
DEFAULT_StratumUserDBPassword=$(openssl rand -base64 29 | tr -d "=+/")
input_box "Database Stratum Password" \
"Enter your desired database stratum password.
\n\nYou may use the system generated password shown.
\n\nDesired Database Password:" \
$DEFAULT_StratumUserDBPassword \
StratumUserDBPassword

if [ -z "$StratumUserDBPassword" ]; then
# user hit ESC/cancel
exit
fi
fi

if [ -z "${AdminPanel:-}" ]; then
DEFAULT_AdminPanel=AdminPortal
input_box "Admin Panel Location" \
"Enter your desired location name for admin access..
\n\nOnce set you will access the YiiMP admin at $DomainName/site/AdminPortal
\n\nDesired Admin Panel Location:" \
$DEFAULT_AdminPanel \
AdminPanel

if [ -z "$AdminPanel" ]; then
# user hit ESC/cancel
exit
fi
fi

clear

dialog --title "Verify Your Responses" \
--yesno "Please verify your answers to continue setup:

Using Sub-Domain : ${UsingSubDomain}
Domain Name      : ${DomainName}
Stratum URL      : ${StratumURL}
Install SSL      : ${InstallSSL}
System Email     : ${SupportEmail}
Admin Location   : ${AdminPanel}
Dedicated Coin Ports : ${CoinPort}
AutoExchange : ${AutoExchange}
Your Public IP   : ${PublicIP}
Web User : ${WebUser}
Web Password : ${WebPass}
WEB Internal IP  : ${WebInternalIP}
Stratum User : ${StratumUser}
Stratum Password : ${StratumPass}
Stratum Internal IP : ${StratumInternalIP}
Daemon User : ${DaemonUser}
Daemon Password : ${DaemonPass}
DB Internal IP   : ${DBInternalIP}
Daemon Internal IP : ${DaemonInternalIP}" 25 60


# Get exit status
# 0 means user hit [yes] button.
# 1 means user hit [no] button.
# 255 means user hit [Esc] key.
response=$?
case $response in

0)

#Generate random conf file name, random StratumDBUser and StratumDBPassword
# To increase security we are now randonly generating the yiimpfrontend DB name, panel, and stratum user names. So each installation is more secure.
# We do it here to save the variables in the global .yiimp.conf file
generate=$(openssl rand -base64 9 | tr -d "=+/")
YiiMPDBName=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
StratumDBUser=Stratum$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')
YiiMPPanelName=Panel$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 13 ; echo '')

# Save the global options in $STORAGE_ROOT/yiimp/.yiimp.conf so that standalone
# tools know where to look for data.
echo 'STORAGE_USER='"${STORAGE_USER}"'
STORAGE_ROOT='"${STORAGE_ROOT}"'
PRIMARY_HOSTNAME='"${DomainName}"'

DomainName='"${DomainName}"'
UsingSubDomain='"${UsingSubDomain}"'
StratumURL='"${StratumURL}"'
InstallSSL='"${InstallSSL}"'
SupportEmail='"${SupportEmail}"'

AdminPanel='"${AdminPanel}"'
PublicIP='"${PublicIP}"'
CoinPort='"${CoinPort}"'
AutoExchange='"${AutoExchange}"'

DBInternalIP='"${DBInternalIP}"'
WebInternalIP='"${WebInternalIP}"'
StratumInternalIP='"${StratumInternalIP}"'
DaemonInternalIP='"${DaemonInternalIP}"'

WebUser='"${WebUser}"'
WebPass='"'"''"${WebPass}"''"'"'
StratumUser='"${StratumUser}"'
StratumPass='"'"''"${StratumPass}"''"'"'
DaemonUser='"${DaemonUser}"'
DaemonPass='"'"''"${DaemonPass}"''"'"'

YiiMPDBName='"${YiiMPDBName}"'
DBRootPassword='"'"''"${DBRootPassword}"''"'"'
YiiMPPanelName='"${YiiMPPanelName}"'
PanelUserDBPassword='"'"''"${PanelUserDBPassword}"''"'"'
StratumDBUser='"${StratumDBUser}"'
StratumUserDBPassword='"'"''"${StratumUserDBPassword}"''"'"'

wireguard='"${wireguard}"'

# Unless you do some serious modifications this installer will not work with any other repo of yiimp!
YiiMPRepo='https://github.com/cryptopool-builders/yiimp.git'
' | sudo -E tee $STORAGE_ROOT/yiimp/.yiimp.conf >/dev/null 2>&1 ;;

1)

clear
bash $(basename $0) && exit;;

255)
clear
echo "User canceled installation"
exit 0
;;
esac

cd $HOME/multipool/yiimp_multi
