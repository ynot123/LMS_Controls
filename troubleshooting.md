## Here are some basic troubleshooting steps if you run into trouble
**_Home Assistant:_**

Once the HA files are installed you can test the basic installation using the GUI front-end thus avoiding any potential Google Voice command issues:
  - From the LMS Controls GUI, select an **LMS player** and test the following functions and confirm they are received (using the LMS interface) on the selected player.  Test the following functions:  **pause, play, next track, volume, shuffle and repeat.**  
  - If that works then fill out the **music source** and **artist** fields and select the **play artist** function and ensure it gets queued to your selected player and starts playing.  After the command launches the command window returns to **"_______________________________"** command.  You can view the results of the music query by checking the **Query Result** on the HA GUI at the bottom of the LMS Sync Controls card.  If the Query Result is "null", then your query returned an empty string.
  - If you got this far, sounds like the HA components are working properly.
  - If the queuing functions are not functioning for either the LMS or Spotify sources (or both), confirm the shell scripts are operating properly (see troubleshooting shell commands).



**_Shell Commands:_**

The query functions for both LMS and Spotify music sources are handled by calling a shell scripts.  These can be run on their own in a shell environment or their results can be logged by turning on the recorder function in the configuration.yaml file.  

For the stand alone testing, open a shell into your HA machine and go to the /config/.shell directory where the files are stored.  If your HA is run in a Docker container, you can open a shell into the container by typing the following command:  `docker exec -it homeassistant bash`.  At this point, go to the /config/shell directory. 

The general format for running the commands is: `bash command.sh $1 $2 $3` where command is the shell command name, $1 is the first parameter to pass (ie: artist) $2 is the second parameter (ie: album) and $3 is the third parameter (ie: song).  Below are some of the commands and expected results which then get returned to HA.

A typical query against the LMS database is shown below (notice spaces are replaced with _ for LMS queries):

```bash-4.4# bash qry_alb.sh _supertramp _breakfast_in_america```

Results in:
```Artists are:
Artists are:                                                                                                                          
artists 0 20 search%3A_supertramp tags%3Aa id%3A1234 artist%3ASupertramp count%3A1     

Artist check zero is: 1                                                                                                                
Artist found so moving on to albums....                                              
Album check zero is: 3

Albums are:                                                                                                                           
albums 0 20 artist_id%3A1234 search%3A_breakfast_in_america tags%3Aal id%3A1685 album%3ABreakfast%20in%20America artist%3ASupertramp i
d%3A1689 album%3AThe%20Very%20Best%20Of%20Supertramp artist%3ASupertramp id%3A1692 album%3ARetrospectacle%3A%20The%20Supertramp%20Anth
ology artist%3ASupertramp count%3A3                                                                                                    

Artist ID is:1234                                                                                                                     
Album ID is: 1685                                                                                                                     
Name is: Breakfast in America 

now Posting results                                                                                                                    

{"attributes": {}, "context": {"id": "c1ad5767bb6f4426a6a86b6778e2a6cd", "user_id": "571cb282ced34b30a068a73986b1c576"}, "entity_id": 
"sensor.art_id", "last_changed": "2019-01-21T03:00:04.447645+00:00", "last_updated": "2019-01-21T03:00:04.447645+00:00", "state": "123
4"}

{"attributes": {}, "context": {"id": "e28b385417c44014a3e07e5400f34706", "user_id": "571cb282ced34b30a068a73986b1c576"}, "entity_id": 
"sensor.alb_id", "last_changed": "2019-01-21T03:00:04.514917+00:00", "last_updated": "2019-01-21T03:00:04.514917+00:00", "state": "168
5"}

{"attributes": {}, "context": {"id": "d41788e99643455584fbd3add7960b6f", "user_id": "571cb282ced34b30a068a73986b1c576"}, "entity_id": 
"input_text.lms_qry_result", "last_changed": "2019-01-21T03:00:04.584616+00:00", "last_updated": "2019-01-21T03:00:04.584616+00:00", "
state": "Breakfast in America"}    
```
In this case it picked out **Artists ID: 1234**, **Album ID: 1685** and **Name: Breakfast in America** and posted these results to HA entities sensor.art_id,  sensor.alb_id and input_text.lms_qry_result respectively.  These values will later be used in the add or play LMS album script.


A typical query against the Spotify music source is shown below (notice spaces are replaced with + for Spotify queries):

```bash-4.4# bash spot_art_alb.sh supertramp breakfast+in+america```

Results in:

```  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   182  100   153  100    29    692    131 --:--:-- --:--:-- --:--:--   823
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  9057  100  9057    0     0  45974      0 --:--:-- --:--:-- --:--:-- 45974

the results are: { "albums" : { "href" : "https://api.spotify.com/v1/search?query=supertramp+breakfast+in+america&type=album&offset=0&
limit=5", "items" : [ { "album_type" : "album", "artists" : [ { "external_urls" : { "spotify" : "https://open.spotify.com/artist/3JsMj
0DEzyWc0VDlHuy9Bx" }, "href" : "https://api.spotify.com/v1/artists/3JsMj0DEzyWc0VDlHuy9Bx", "id" : "3JsMj0DEzyWc0VDlHuy9Bx", "name" : 
"Supertramp", "type" : "artist", "uri" : "spotify:artist:3JsMj0DEzyWc0VDlHuy9Bx" } ], "available_markets" : [ "AD", "AE", "AR", "AT", 
"AU", "BG", "BH", "BO", "BR", "CA", "CH", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "DZ", "EC", "EE", "EG", "ES", "FI", "FR", "G
B", "GT", "HK", "HN", "HU", "ID", "IE", "IL", "IS", "IT", "JO", "JP", "KW", "LB", "LI", "LT", "LV", "MA", "MC", "MT", "MX", "MY", "NI"
, "NL", "NO", "OM", "PA", "PE", "PH", "PL", "PS", "PT", "PY", "QA", "RO", "SA", "SE", "SG", "SK", "SV", "TH", "TN", "TW", "US", "UY", 
"ZA" ], "external_urls" : { "spotify" : "https://open.spotify.com/album/1zcm3UvHNHpseYOUfd0pna" }, "href" : "https://api.spotify.com/v
1/albums/1zcm3UvHNHpseYOUfd0pna", "id" : "1zcm3UvHNHpseYOUfd0pna", "images" : [ { "height" : 637, "url" : "https://i.scdn.co/image/241
0cabd97f92d9fee6112181d57568df7476aae", "width" : 640 }, { "height" : 299, "url" : "https://i.scdn.co/image/3688105a4087383eff61cf2ddc
202b1134a0356b", "width" : 300 }, { "height" : 64, "url" : "https://i.scdn.co/image/0ba603d6c46fa527bf6457685deb16f8a554708a", "width"
 : 64 } ], "name" : "Breakfast In America (Deluxe Edition)", "release_date" : "1979-03-29", "release_date_precision" : "day", "total_t
racks" : 22, "type" : "album", "uri" : "spotify:album:1zcm3UvHNHpseYOUfd0pna" }, { "album_type" : "album", "artists" : [ { "external_u
rls" : { "spotify" : "https://open.spotify.com/artist/3JsMj0DEzyWc0VDlHuy9Bx" }, "href" : "https://api.spotify.com/v1/artists/3JsMj0DE
zyWc0VDlHuy9Bx", "id" : "3JsMj0DEzyWc0VDlHuy9Bx", "name" : "Supertramp", "type" : "artist", "uri" : "spotify:artist:3JsMj0DEzyWc0VDlHu
y9Bx" } ], "available_markets" : [ "CA", "MX", "US" ], "external_urls" : { "spotify" : "https://open.spotify.com/album/7i75GRwJbhDDiLi
2uQHTtZ" }, "href" : "https://api.spotify.com/v1/albums/7i75GRwJbhDDiLi2uQHTtZ", "id" : "7i75GRwJbhDDiLi2uQHTtZ", "images" : [ { "heig
ht" : 640, "url" : "https://i.scdn.co/image/13a7be12b4696c88261dcc315f76c1af84067cb4", "width" : 640 }, { "height" : 300, "url" : "htt
ps://i.scdn.co/image/e2b521a5b6f66cfcb51d17496d712a917a7e5b02", "width" : 300 }, { "height" : 64, "url" : "https://i.scdn.co/image/a5a
e0d75612bc9aa40d5bd505e570fa086b92b5f", "width" : 64 } ], "name" : "Breakfast In America", "release_date" : "1979-03-29", "release_dat
e_precision" : "day", "total_tracks" : 10, "type" : "album", "uri" : "spotify:album:7i75GRwJbhDDiLi2uQHTtZ" }, { "album_type" : "album
", "artists" : [ { "external_urls" : { "spotify" : "https://open.spotify.com/artist/3JsMj0DEzyWc0VDlHuy9Bx" }, "href" : "https://api.s
potify.com/v1/artists/3JsMj0DEzyWc0VDlHuy9Bx", "id" : "3JsMj0DEzyWc0VDlHuy9Bx", "name" : "Supertramp", "type" : "artist", "uri" : "spo
tify:artist:3JsMj0DEzyWc0VDlHuy9Bx" } ], "available_markets" : [ "AD", "AE", "AR", "AT", "AU", "BE", "BG", "BH", "BO", "BR", "CA", "CH
", "CL", "CO", "CR", "CY", "CZ", "DE", "DK", "DO", "DZ", "EC", "EE", "EG", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "ID",
 "IE", "IL", "IS", "IT", "JO", "JP", "KW", "LB", "LI", "LT", "LU", "LV", "MA", "MC", "MT", "MX", "MY", "NI", "NL", "NO", "NZ", "OM", "
PA", "PE", "PH", "PL", "PS", "PT", "PY", "QA", "RO", "SA", "SE", "SG", "SK", "SV", "TH", "TN", "TR", "TW", "US", "UY", "VN", "ZA" ], "
external_urls" : { "spotify" : "https://open.spotify.com/album/1G40QqbxYWEeelWqf4hpbI" }, "href" : "https://api.spotify.com/v1/albums/
1G40QqbxYWEeelWqf4hpbI", "id" : "1G40QqbxYWEeelWqf4hpbI", "images" : [ { "height" : 637, "url" : "https://i.scdn.co/image/c70086e01866
6b8da3fdcaf25fb3c34b2306f4be", "width" : 640 }, { "height" : 299, "url" : "https://i.scdn.co/image/0bd2e0fa69b3177c3596b8aa209f62e16c8
cde2b", "width" : 300 }, { "height" : 64, "url" : "https://i.scdn.co/image/d265b064aa07a4b3a5258492fa20a6abc69d01b7", "width" : 64 } ]
, "name" : "Breakfast In America (Remastered)", "release_date" : "1979-03-29", "release_date_precision" : "day", "total_tracks" : 10, 
"type" : "album", "uri" : "spotify:album:1G40QqbxYWEeelWqf4hpbI" }, { "album_type" : "single", "artists" : [ { "external_urls" : { "sp
otify" : "https://open.spotify.com/artist/7a2AgzWfEyFkgSAXjLe4T3" }, "href" : "https://api.spotify.com/v1/artists/7a2AgzWfEyFkgSAXjLe4
T3", "id" : "7a2AgzWfEyFkgSAXjLe4T3", "name" : "Karaoke Universe", "type" : "artist", "uri" : "spotify:artist:7a2AgzWfEyFkgSAXjLe4T3" 
} ], "available_markets" : [ "AD", "AE", "AR", "AT", "AU", "BE", "BG", "BH", "BO", "BR", "CA", "CH", "CL", "CO", "CR", "CY", "CZ", "DE
", "DK", "DO", "DZ", "EC", "EE", "EG", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "ID", "IE", "IL", "IS", "IT", "JO", "JP",
 "KW", "LB", "LI", "LT", "LU", "LV", "MA", "MC", "MT", "MX", "MY", "NI", "NL", "NO", "NZ", "OM", "PA", "PE", "PH", "PL", "PS", "PT", "
PY", "QA", "RO", "SA", "SE", "SG", "SK", "SV", "TH", "TN", "TR", "TW", "US", "UY", "VN", "ZA" ], "external_urls" : { "spotify" : "http
s://open.spotify.com/album/6x22RM6z0nUhLX3te5eTyN" }, "href" : "https://api.spotify.com/v1/albums/6x22RM6z0nUhLX3te5eTyN", "id" : "6x2
2RM6z0nUhLX3te5eTyN", "images" : [ { "height" : 640, "url" : "https://i.scdn.co/image/ae67f5a47be8ed7fdac8403d1b540ee667a5acfb", "widt
h" : 640 }, { "height" : 300, "url" : "https://i.scdn.co/image/e70e390ed859dceda521d6c53ddf4e35de5a57da", "width" : 300 }, { "height" 
: 64, "url" : "https://i.scdn.co/image/5a3b0b55fe026ea206c26b3d5403951cc7bdff0a", "width" : 64 } ], "name" : "Breakfast In America (Ka
raoke Version) [In the Style of Supertramp]", "release_date" : "2013-10-04", "release_date_precision" : "day", "total_tracks" : 1, "ty
pe" : "album", "uri" : "spotify:album:6x22RM6z0nUhLX3te5eTyN" }, { "album_type" : "single", "artists" : [ { "external_urls" : { "spoti
fy" : "https://open.spotify.com/artist/5Jvi2TK5LJUqq31thj2xGZ" }, "href" : "https://api.spotify.com/v1/artists/5Jvi2TK5LJUqq31thj2xGZ"
, "id" : "5Jvi2TK5LJUqq31thj2xGZ", "name" : "Sing Strike Karaoke", "type" : "artist", "uri" : "spotify:artist:5Jvi2TK5LJUqq31thj2xGZ" 
} ], "available_markets" : [ "AD", "AE", "AR", "AT", "AU", "BE", "BG", "BH", "BO", "BR", "CA", "CH", "CL", "CO", "CR", "CY", "CZ", "DE
", "DK", "DO", "DZ", "EC", "EE", "EG", "ES", "FI", "FR", "GB", "GR", "GT", "HK", "HN", "HU", "ID", "IE", "IL", "IS", "IT", "JO", "JP",
 "KW", "LB", "LI", "LT", "LU", "LV", "MA", "MC", "MT", "MX", "MY", "NI", "NL", "NO", "NZ", "OM", "PA", "PE", "PH", "PL", "PS", "PT", "
PY", "QA", "RO", "SA", "SE", "SG", "SK", "SV", "TH", "TN", "TR", "TW", "US", "UY", "VN", "ZA" ], "external_urls" : { "spotify" : "http
s://open.spotify.com/album/5Vcp14cV398QbMeFIJl6o7" }, "href" : "https://api.spotify.com/v1/albums/5Vcp14cV398QbMeFIJl6o7", "id" : "5Vc
p14cV398QbMeFIJl6o7", "images" : [ { "height" : 640, "url" : "https://i.scdn.co/image/384f112249e5cc7f48ff03c4568f9ad7b78bb733", "widt
h" : 640 }, { "height" : 300, "url" : "https://i.scdn.co/image/1640182ab229d9f17325866d326ae3111da8b3a0", "width" : 300 }, { "height" 
: 64, "url" : "https://i.scdn.co/image/838203c5b5804ab7f77a7486b93b6bb495fc6c3d", "width" : 64 } ], "name" : "Breakfast in America (Ka
raoke Version) (Originally Performed By Supertramp)", "release_date" : "2015-03-02", "release_date_precision" : "day", "total_tracks" 
: 1, "type" : "album", "uri" : "spotify:album:5Vcp14cV398QbMeFIJl6o7" } ], "limit" : 5, "next" : "https://api.spotify.com/v1/search?qu
ery=supertramp+breakfast+in+america&type=album&offset=5&limit=5", "offset" : 0, "previous" : null, "total" : 8 } }  


uri is: spotify:album:1zcm3UvHNHpseYOUfd0pna;    Name is: Breakfast In America (Deluxe Edition) 


{"attributes": {}, "context": {"id": "2439a1eb4ad942ec82a0d3665954a489", "user_id": "571cb282ced34b30a068a73986b1c576"}, "entity_id": 
"sensor.spotify_uri", "last_changed": "2019-01-21T03:12:09.816901+00:00", "last_updated": "2019-01-21T03:12:09.816901+00:00", "state":
 "spotify:album:1zcm3UvHNHpseYOUfd0pna"}
 
{"attributes": {}, "context": {"id": "aa9db32d605a4f388586a18e7526c03c", "user_id": "571cb282ced34b30a068a73986b1c576"}, "entity_id": 
"input_text.lms_qry_result", "last_changed": "2019-01-21T03:12:09.888521+00:00", "last_updated": "2019-01-21T03:12:09.888521+00:00", "
state": "Breakfast In America (Deluxe Edition)"} 
```
In this case, the query returned the album **uri link: spotify:album:1zcm3UvHNHpseYOUfd0pna** and **Name: Breakfast in America (Deluxe Edition)**.  The results were then posted to HA entities sensor.spotify_uri and input_text.lms_qry_result for later use in the add or play spotify album scripts.

Reviewing these results will provide significant insight into any issues running the shell scripts.  The most common cause of shell command issues are:

- Proper settings in the env.sh file which contains the security settings, ip addresses and port. 
- Path to the shell files defined improperly in lmscontrols.yaml package file
- Lack of support for shell commands: curl, jq, nc and socat



**_DialogFlow:_**

Here's a few tips and things to check in the DialogFlow portion of this project.
- Under the DF Sidebar, click on the **gear icon** to call up your Agent settings
- Select the **General Tab** and ensure API Version is set to **V1 API**
- Use the HA GUI to see how your commands are being interpreted.  This is especially useful when querying items with numbers, etc..  Here you get to see how google home interpreted your voice commands.
