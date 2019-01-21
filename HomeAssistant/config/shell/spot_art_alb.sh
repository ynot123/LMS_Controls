###  spot_art_alb.sh - Queries Spotify database for album based on submitted artist and album fields
###
###  Dec 30, 2018 -  Implemented source file for all common environment variables required (user, pass, clinet keys, tokens, etc..)
###  Jan 21, 2019 -  Updated curl posts to HA to remove stray quote / double quote
###
### Next section pulls the environment variables for the script
#!/bin/bash
source /config/shell/env_var.sh
###  removing any trailing \r if they exist
HA_Token=$(echo $HA_Token | sed -e 's/\r//g')
my_domain=$(echo $my_domain | sed -e 's/\r//g')
spot_client_id=$(echo $spot_client_id | sed -e 's/\r//g')
spot_client_secret=$(echo $spot_client_secret | sed -e 's/\r//g')
echo HA Token is: $HA_Token
echo My Domain is: $my_domain
echo Spotify Client ID: $spot_client_id
echo Spotify Client Secret: $spot_client_secret
echo 
auth="$spot_client_id"':'"$spot_client_secret"
b64=`echo -n "$auth"|base64`
b64=$(echo $b64 | tr -d ' ')
RESULTS=$(curl -X "POST" -H "Authorization: Basic $b64" -d grant_type=client_credentials https://accounts.spotify.com/api/token) 
token=$(echo $RESULTS | jq -r '.access_token')
RESULTS=$(curl -X GET "https://api.spotify.com/v1/search?q=$1+$2&type=album&limit=5" -H "Authorization: Bearer $token")
echo
echo the results are: $RESULTS
echo
echo
uri=$(echo $RESULTS | jq -r '.albums.items[0].uri')
name=$(echo $RESULTS | jq -r '.albums.items[0].name')
echo
echo 'uri is: '$uri';    Name is: '$name
echo
curl -X POST -d '{"state":"'"${uri}"'"}' https://${my_domain}/api/states/sensor.spotify_uri? -H "Authorization: Bearer $HA_Token"
echo
curl -X POST -d '{"state":"'"${name}"'"}' https://${my_domain}/api/states/input_text.lms_qry_result? -H "Authorization: Bearer $HA_Token"
echo