###  qry_playlist.sh - Queries LMS server for playlist based on submitted playlist field
###
###  Jan 10, 2019 -  Initial file creation, handles both secured and unsecured LMS queries using socat and nc respectively for maximum 
###                  compatibility.  Note: socat is not supported in Synology NAS and QNAP NAS
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
    query=$(printf "$login_str playlists 0 20 search:$1 tags:a \n" | socat stdio tcp:"$lms_ip":"$lms_cli_port",shut-none )
else 
    query=$(printf "playlists 0 20 search:$1 tags:a \nexit\n" | nc "$lms_ip" "$lms_cli_port" )
fi
zero_chk=$query
playlist_id=${query#*playlists*id%3A}
playlist_id=${playlist_id%% playlist*3A*}
zero_chk=${zero_chk##*playlist*count%3A}
echo 
echo "Playlists are:"
echo $query
echo
echo "Playlist check zero is:" $zero_chk
echo
name=${query#*playlist*playlist%3A}
name=${name%% id*3A*}
name=${name%% count*3A*}
name=$(echo -e "${name//%/\\x}")
###  Check for invalid result of playlist_id (no match found)
if [[ $zero_chk == "0" ]] 
then playlist_id=0 name="null" 
fi
echo
echo "playlist ID is:$playlist_id"
echo "Name of playlist is: $name"
echo "now Posting results"
echo
curl -X POST -d '{"state":"'"${playlist_id}"'"}' https://${my_domain}/api/states/sensor.playlist_id? -H "Authorization: Bearer $HA_Token"
echo
curl -X POST -d '{"state":"'"${name}"'"}' https://${my_domain}/api/states/input_text.lms_qry_result? -H "Authorization: Bearer $HA_Token"
echo