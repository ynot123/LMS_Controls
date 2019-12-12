## LATEST CHANGES ....
#### Dec. 12, 2019 Breaking Change - Upgrade of HA to version 0.103 requires Squeezebox service syntax change

Please note, with the upgrade of HA to Version 0.103 the syntax has change for Squeezebox service calls.  In the script `lmscontrols.yaml` the command `media_player.squeezebox_call_method` needs to be changed to `squeezebox.call_method`.  This commands appears 41 times in the `.yaml` file.  


#### Upgrade of HA from 0.99 to 0.101 required re-creation of Long Lived Tokens

Please note, with the upgrade of HA from 0.99 to 0.101 I had to re-create my long lived tokens for the shell scripts (stored in env_var.sh) and in the fulfillment section of Dialogflow project to ensure proper authentication with Home Assistant.

#### LMS Controls Project Updated - Dialogflow Support for V2 API - October 24, 2019

Dialogflow V1 api will be deprecated on October 23, 2019. If you are still using the V1 API, it is recommended to change your settings in Dialogflow to use the V2 API. No changes to your intents yaml configuration need to take place after upgrading to the V2 API. 

To update the dialogflow project, in Dialogflow console, simply press the gear icon and change from V1 to V2. Give it a try.

#### LMS Controls Project Updated - January 27, 2019

Updated Spotify query shell script **config/shell/spot_playlist.sh** to randomly pick 1 of the top 10 playlists returned from the query.  This way you get a bit more variety when asking for a Spotify playlist rather than always getting the top playlist returned.  

#### LMS Controls Project Updated - January 24, 2019

Updated package file lmscontrols.yaml changing **platform: time** to **platform: time_pattern** due to breaking change in Home Assistant 0.86+



## LMS Controls:
Control your Logitech / Squeezeserver players (LMS) from Home Assistant (HA) and Google Home (GH). A little [audio demo](https://github.com/ynot123/LMS_Controls/blob/master/LMS%20Controls%20Demo.mp3) is available.  Also see the Home Assistant GUI below.

Some [example](https://github.com/ynot123/LMS_Controls/blob/master/example_commands.md) commands include:
- "Hey google ask LMS Controls to play album Dog and Butterfly by Heart in the kitchen with shuffle on"
- "Set volume to 50" or "Set sleep timer to 30 minutes" or "Set shuffle on"
- "Link the garage with the mediaroom"
## What Can It Do:
Allows voice control for your Logitech Media Server (LMS) from Google Home (GH) or Google Assistant (GA) with Home Assistant (HA) acting as the middle man.  Using these tools, you can do the following:

- Perform queries for songs, albums, artists and playlists from the LMS server or from the music source Spotify
- Functionality includes:
	- Play queried items
	- Add to current playlist
	- Set music source (local LMS database or Spotify (using spotty)
	- Set volume
	- Set sleep timer
	- Set shuffle on / off
	- Set repeat on / off
	- Next track
	- Pause and re-start players
	- Sync / Link squeeze players
	- Provide audio feedback of player status and query results
- A HA GUI front-end for the query tool is also included for use inside Home Assistant
- Using HA you can further enhance the LMS tools to create home automation scenes (ie: play your favorite radio station when you get home, turn down the lights when listening to music

See the following link for some examples of the voice commands available: [example_commands.md](https://github.com/ynot123/LMS_Controls/blob/master/example_commands.md)



## Basic Concepts and Data Flow:

The following outlines how the LMS Controls project works, the systems involved and the data flow:​	

- Voice Intents are handled by Dialogflow (DF) where you define the following:
	- LMS command you want (set volume, play artist, etc..)
	- Set the details of the query (artist name, song title, etc.)
	- Set the player name and any additional parameters like shuffle on, etc..
	- DF then sends a web hook to HA software containing all the information outlined above
- HA receives the web hook from DF and:
	- Determines the values sent from DF
	- If this is music query function:
		- Performs required queries against either LMS DB or Spotify using shell scripts
		- Shell scripts return the desired link(s) based on the above query parameters by posting the results in sensors or input entities
		- The returned links are then queued to the proper player using HA's Logitech Squeezebox component
	- If this a set function (volume, shuffle, repeat) Home Assistant simply sets the value using the Media Control or Logitech Squeezebox component as required
	- The HA package also contains a Lovelace and Traditional GUI front-end to perform the same functions as the GH voice system provides
	- In addition, HA allows automation routine extensions to the LMS system.  These can include:
		- Synchronize squeeze players
		- Launch favorite audio when you get home
		- Automatic setting of scenes when players start playing (ie: dim the lights, switch on certain outlets)
		- Paging / general announcements throughout the home 

## Prerequisites:
To make this work, you need the following:
- Logitech Media Server
- Hass.io or Home Assistant - open source home automation package.
- Google Home (or google assistant)
- Developer account for Dialogflow for the voice activation part
- Optional Spotify account with Client_ID and Client_Secret to allow processing of Spotify music source

## Installation:	
Before starting the installation, please ensure the following:

- You have a working version Logitech Media Server with some players defined

Follow the details included in the [Installation Instructions.md](https://github.com/ynot123/LMS_Controls/blob/master/Installation%20Instructions.md) file.

## Home Assistant GUIs for LMS Player Controls Tool:

**Lovelace GUI**:

![LoveLace GUI](https://github.com/ynot123/LMS_Controls/blob/master/LoveLace_GUI.jpg)

**Traditional HA GUI**:

![Traditional GUI](https://github.com/ynot123/LMS_Controls/blob/master/Traditonal_GUI.jpg)

## Troubleshooting:

See the following link for some useful troubleshooting tips [troubleshooting.md](https://github.com/ynot123/LMS_Controls/blob/master/troubleshooting.md)
## Some Useful Links:
[Logitech Squeezebox Server](https://mysqueezebox.com/index/Home):
Wonderful full featured media server supporting tons of features, almost all protocols, most music sources, allowing you to listening to what you want, where you want throughout your home on one or many players at the same time.

[Home Assistant](https://www.home-assistant.io/):
Home Assistant is an open source home automation platform running on Python 3. It is able to track and control all devices at home and offers a platform for automating control.

[Dialogflow](https://dialogflow.com/):
Dialogflow is a conversational platform that gives users new ways to interact with their products by building engaging voice and text-based conversational interfaces, such as voice apps and chatbots, powered by AI. It features an easy-to-use front-end, natural language understanding (NLU), machine learning, and more.

[Spotify Developer](https://developer.spotify.com/):
Where music meets code. Exposes powerful APIs, SDKs and widgets for integration of simple and advanced applications. 

## Our Support Communities:
[Squeezebox Community Forums](https://forums.slimdevices.com/):
Anything you need to know about your LMS server is here.   

[Home Assistant Community Forums](https://community.home-assistant.io/):
All about Home Assistant.  Lots of development and support going on here.  

[Dialogflow Support](https://productforums.google.com/forum/#!forum/dialogflow):
Helpful if trying to publish your tools to a wider audience.  

