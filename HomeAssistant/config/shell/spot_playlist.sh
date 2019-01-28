###  spot_playlist.sh - Queries Spotify database for playlist based on submitted playlist field
###
###  Jan 26, 2019 -  Added random function to pick 1 (at random) of top 10 returned playlists
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
range=10 
max_RANDOM=$(( 2**15/$range*$range ))
r=$RANDOM
until [ $r -lt $max_RANDOM ]; do
r=$RANDOM
done
num=$((r % $range))
auth="$spot_client_id"':'"$spot_client_secret"
b64=`echo -n "$auth"|base64`
b64=$(echo $b64 | tr -d ' ')
RESULTS=$(curl -X "POST" -H "Authorization: Basic $b64" -d grant_type=client_credentials https://accounts.spotify.com/api/token) 
token=$(echo $RESULTS | jq -r '.access_token')
RESULTS=$(curl -X GET "https://api.spotify.com/v1/search?q=%22$1%22&type=playlist&limit=$range" -H "Authorization: Bearer $token")
echo
echo the results are: $RESULTS
echo
echo
uri=$(echo $RESULTS | jq -r '.playlists.items['$num'].uri')
name=$(echo $RESULTS | jq -r '.playlists.items['$num'].name')
echo
echo Random selection is: $num
echo 'uri is: '$uri';  Name is: '$name
echo
curl -X POST -d '{"state":"'"${uri}"'"}' https://${my_domain}/api/states/sensor.spotify_uri? -H "Authorization: Bearer $HA_Token"
echo
curl -X POST -d '{"state":"'"${name}"'"}' https://${my_domain}/api/states/input_text.lms_qry_result? -H "Authorization: Bearer $HA_Token"
echo