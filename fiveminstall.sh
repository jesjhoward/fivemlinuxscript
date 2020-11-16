#!/bin/bash
sudo error

sudo apt update
sudo apt upgrade -y

sudo apt install mariadb-server -y

sudo mkdir /home/$USER/FXServer
sudo mkdir /home/$USER/FXServer/server
cd /home/$USER/FXServer/server
sudo wget https://runtime.fivem.net/artifacts/fivem/build_proot_linux/master/3184-6123f9196eb8cd2a987a1dd7ff7b36907a787962/fx.tar.xz
sudo tar xf fx.tar.xz
cd ..
sudo git clone https://github.com/citizenfx/cfx-server-data.git /home/$USER/FXServer/server-data
cd server-data
sudo cat <<EOF >server.cfg
# Only change the IP if you're using a server with multiple network interfaces, otherwise change the port only.
endpoint_add_tcp "0.0.0.0:30120"
endpoint_add_udp "0.0.0.0:30120"

# These resources will start by default.
ensure mapmanager
ensure chat
ensure spawnmanager
ensure sessionmanager
ensure fivem
ensure hardcap
ensure rconlog
ensure scoreboard

# This allows players to use scripthook-based plugins such as the legacy Lambda Menu.
# Set this to 1 to allow scripthook. Do note that this does _not_ guarantee players won't be able to use external plugins.
sv_scriptHookAllowed 0

# Uncomment this and set a password to enable RCON. Make sure to change the password - it should look like rcon_password "YOURPASSWORD"
#rcon_password ""

# A comma-separated list of tags for your server.
# For example:
# - sets tags "drifting, cars, racing"
# Or:
# - sets tags "roleplay, military, tanks"
sets tags "default"

# A valid locale identifier for your server's primary language.
# For example "en-US", "fr-CA", "nl-NL", "de-DE", "en-GB", "pt-BR"
sets locale "root-AQ" 
# please DO replace root-AQ on the line ABOVE with a real language! :)

# Set an optional server info and connecting banner image url.
# Size doesn't matter, any banner sized image will be fine.
#sets banner_detail "https://url.to/image.png"
#sets banner_connecting "https://url.to/image.png"

# Set your server's hostname
sv_hostname "FXServer, but unconfigured"

# Nested configs!
#exec server_internal.cfg

# Loading a server icon (96x96 PNG file)
#load_server_icon myLogo.png

# convars which can be used in scripts
set temp_convar "hey world!"

# Uncomment this line if you do not want your server to be listed in the server browser.
# Do not edit it if you *do* want your server listed.
#sv_master1 ""

# Add system admins
add_ace group.admin command allow # allow all commands
add_ace group.admin command.quit deny # but don't allow quit
add_principal identifier.fivem:1 group.admin # add the admin to the group

# Hide player endpoints in external log output.
sv_endpointprivacy true

# enable OneSync with default configuration (required for server-side state awareness)
onesync_enabled true

# Server player slot limit (must be between 1 and 32, unless using OneSync)
sv_maxclients 32

# Steam Web API key, if you want to use Steam authentication (https://steamcommunity.com/dev/apikey)
# -> replace "" with the key
set steam_webApiKey ""

# License key for your server (https://keymaster.fivem.net)
sv_licenseKey uhcuhys91h56dw3yusa7ck06q5jglzem
EOF

cd ~
cat <<EOF >gtastart.sh
#!/bin/bash
sudo systemctl stop mysql
sudo mysqld --skip-grant-tables &

cd /home/$USER/FXServer/server-data
sudo bash /home/$USER/FXServer/server/run.sh +exec server.cfg
EOF
sudo chmod +x gtastart.sh
sudo chmod -R 777 FXServer

sudo mysql_secure_installation
