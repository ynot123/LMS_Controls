###  qry_alb.sh - Queries LMS server for album based on submitted artist and album fields
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
    query=$(printf "$login_str artists 0 20 search:$1 tags:a \n" | socat stdio tcp:"$lms_ip":"$lms_cli_port",shut-none )
else 
    query=$(printf "artists 0 20 search:$1 tags:a \nexit\n" | nc "$lms_ip" "$lms_cli_port" )
fi
zero_chk=$query
art_id=${query#*artists*id%3A}
art_id=${art_id%% artist*3A*}
zero_chk=${zero_chk##*artist*count%3A}
echo 
echo "Artists are:"
echo $query
echo
echo "Artist check zero is:" $zero_chk
echo
if [ $zero_chk == 0 ]
then
    echo
    echo "Artists not found so set art_id = 0 and query only alb"
    art_id="0"
    echo
    echo "Artist found so moving on to albums...."
    if [ $lms_secure = 1 ]
    then 
        query=$(printf "$login_str albums 0 20 search:$2 tags:al \n" | socat stdio tcp:"$lms_ip":"$lms_cli_port",shut-none )
    else 
        query=$(printf "albums 0 20 search:$2 tags:al \nexit\n" | nc "$lms_ip" "$lms_cli_port" )
    fi
    zero_chk=$query
    alb_id=${query#*album*tags*id%3A}
    alb_id=${alb_id%% album*3A*}
    zero_chk=${zero_chk##*album*count%3A}
    echo 
    echo "Album check zero is:" $zero_chk
    echo
    echo
    echo "Albums are:"
    echo $query
    if [ $zero_chk == 0 ]
    then
        echo
        echo "no album match setting ID to 0"
        alb_id="0"
    fi
    echo "There's no complete match:"
else
    echo
    echo "Artist found so moving on to albums...."
    if [ $lms_secure = 1 ]
    then 
        query=$(printf "$login_str albums 0 20 artist_id:$art_id search:$2 tags:al \n" | socat stdio tcp:"$lms_ip":"$lms_cli_port",shut-none )
    else 
        query=$(printf "albums 0 20 artist_id:$art_id search:$2 tags:al \nexit\n" | nc "$lms_ip" "$lms_cli_port" )
    fi
    zero_chk=$query
    alb_id=${query#*album*tags*id%3A}
    alb_id=${alb_id%% album*3A*}
    zero_chk=${zero_chk##*album*count%3A}
    echo 
    echo "Album check zero is:" $zero_chk
    echo
    echo
    echo "Albums are:"
    echo $query
    if [ $zero_chk == 0 ]
    then
        echo
        echo "no album match setting ID to 0"
        alb_id="0"
    fi
fi
name=${query#*album*album%3A}
name=${name%% artist*3A*}
name=$(echo -e "${name//%/\\x}")
if [[ $zero_chk == "0" ]] 
then alb_id=0 name="null" 
fi
echo
echo "Artist ID is:$art_id"
echo "Album ID is: $alb_id"
echo "Name is: $name"
echo "now Posting results"
echo
curl -X POST -d '{"state":"'"${art_id}"'"}' https://${my_domain}/api/states/sensor.art_id? -H "Authorization: Bearer $HA_Token"
echo
curl -X POST -d '{"state":"'"${alb_id}"'"}' https://${my_domain}/api/states/sensor.alb_id? -H "Authorization: Bearer $HA_Token"
echo
curl -X POST -d '{"state":"'"${name}"'"}' https://${my_domain}/api/states/input_text.lms_qry_result? -H "Authorization: Bearer $HA_Token"
echo