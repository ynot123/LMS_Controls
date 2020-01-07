###  qry_player_stat.sh - Queries LMS server for status of player based on player_id field
###
###  Dec 30, 2018 -  Implemented source file for all common environment variables required (user, pass, client keys, tokens, etc..)
###  Jan  7, 2019 -  Updated script to handle both secured and unsecured LMS queries using socat and nc respectively for maximum compatibility
###                  socat is not supported in Synology NAS and QNAP NAS
###  Jan 21, 2019 -  Updated curl posts to HA to remove stray quote / double quote
###
### Next section pulls the environment variables for the script
#!/bin/bash
source /config/shell/env_var.sh
###  removing any trailing \r if they exist
HA_Token=$(echo $HA_Token | sed -e 's/\r//g')
my_domain=$(echo $my_domain | sed -e 's/\r//g')
lms_ip=$(echo $lms_ip | sed -e 's/\r//g')
lms_cli_port=$(echo $lms_cli_port | sed -e 's/\r//g')
lms_username=$(echo $lms_username | sed -e 's/\r//g')
lms_password=$(echo $lms_password | sed -e 's/\r//g')
echo lms_username is: $lms_username
if [ $lms_username == 'null' ]
then 
    lms_secure=0 
    login_str="not required"
else 
    lms_secure=1 
    login_str='login '"$lms_username"' '"$lms_password"'\n'
fi
echo login is: $login_str and lms_secure is: $lms_secure
echo HA Token is: $HA_Token
echo My Domain is: $my_domain
echo My lms_ip: $lms_ip
echo My lms_cli_port: $lms_cli_port
echo 
if [ $lms_secure = 1 ]
then 
    query=$(printf "$login_str $1 status \n" | socat stdio tcp:"$lms_ip":"$lms_cli_port",shut-none )
else 
    query=$(printf "$1 status \nexit\n" | nc "$lms_ip" "$lms_cli_port" )
fi
echo Query is: $query
raw_volume=${query#*volume%3A}
raw_volume=${raw_volume%% *}
raw_shuffle=${query#*shuffle%3A}
raw_shuffle=${raw_shuffle%% playlist%20mode*}
if [ $raw_shuffle == 0 ] 
    then raw_shuffle=Off
    else raw_shuffle=On
    fi
raw_repeat=${query#*repeat%3A}
raw_repeat=${raw_repeat%% playlist%20shuffle*}
if [ $raw_repeat == 0 ]
    then raw_repeat=Off 
    else raw_repeat=On 
    fi
raw_sleep=${query#*sleep%3A}
raw_sleep=${raw_sleep%% will_sleep*}
if [ ${#raw_sleep} -gt 8 ]
    then
        echo "No Sleep Parameter Found - setting to 0"
        raw_sleep="0"
    fi
echo "volume:$raw_volume"
echo "shuffle:$raw_shuffle"
echo "repeat:$raw_repeat"
echo "sleep:$raw_sleep"
curl -X POST -d '{"state":"'"${raw_volume}"'"}' https://${my_domain}/api/states/sensor.raw_volume? -H "Authorization: Bearer $HA_Token"
echo
curl -X POST -d '{"state":"'"${raw_shuffle}"'"}' https://${my_domain}/api/states/sensor.raw_shuffle? -H "Authorization: Bearer $HA_Token"
echo
curl -X POST -d '{"state":"'"${raw_repeat}"'"}' https://${my_domain}/api/states/sensor.raw_repeat? -H "Authorization: Bearer $HA_Token"
echo
curl -X POST -d '{"state":"'"${raw_sleep}"'"}' https://${my_domain}/api/states/sensor.raw_sleep? -H "Authorization: Bearer $HA_Token"
echo
