## Some Example Commands for DialogFlow / GoogleHome Interface
Once setup and configured you can use your Google Home or Google Assistant to issue voice commands to the LMS squeeze players.  The commands can be issued as explicit or implicit intents. 
## Explicit Intents
Explicit intents are the commands given to the app once it's been called up and is active on your Google device.  It's characterized by the startup phrase:  **"Hey google talk to LMS Controls"**.  This calls up the Welcome intent (**"How can I help?"**) of the app at wich time you are free to issue your voice commands.  Once all commands are issued you say **"Goodbye"** (or after 10 seconds of no requests) the App closes and returns control to the Google environment.
## Implicit Intents
Implicit intents is a voice command given to the google environment directly as part of the app start-up command.  It quickly asksk for something to get done without having to step through several prompts.  It's characterized by the phrase **"Hey google ask LMS Controls to ...**.  This calls up the app, skips the Welcome intent and goes directly to the command issued after the phrase **"ask LMS Controls to...**.  The command is executed and in the LMS application, there is a 10 second pause that allows you to issue further follow-up commands directly (explicit intents) like **"set volume to 40"** or **"set shuffle on"** without having to re-issue the startup phrase.  After 10 seconds of no requests, the app exits and returns control to the google environment.
## Example Explicit Intent Commands
**Start-Up Phrases:** are used to call up the app for Google Home or Google Assistant and prepare for explicit intents.
  - "Hey google, talk to LMS Controls"
  - "Hey google, LMS Controls"
  - "OK google, ask for LMS Controls"

**Explicit Intents:** After the start-up phrase above, the LMS Controls apps is called up and the Welcome intent is played **"How can I help?"**. Now you are ready to issue the explicit intents (voice commands) to your players. Some example phrases are listed below by category.
- **Play** intents are structured as follows:  "Play [artist, album, song, playlist, radio] [name / title] using player [player name] with shuffle [on/off]".  The phrase "using player" can be substituted with "in the" for simplicity though accuracy may suffer a bit.  The "Play" command clears the existing queue of the player, loads the request and starts playing.
  - "Play artist Pink Floyd" or "Play artist Pink Floyd in the kitchen" or "Play artist Pink Floyd with shuffle on" or "Play artist Pink Floyd in the kitchen with shuffle on"
  - "Play album Breakfast in America" or "Play album Crime of the Century by Supertramp" or "Play ablum Pieces of Eight by Supertramp in the mediaroom with shuffle on"
  - "Play song Centerfold using player kitchen" or "Play song Dog and Butterfly by Heart".
  - "Play playlist Smooth Jazz" or "Play playlist classic rock in the garage with shuffle on"
  - "Play radio station Q92" or "Play radio station CBC in the bedroom"
- **Add** intents are structure exactly the same as the play intents. "Add [artist, album, song or playlist] [name / title] using player [player name] with shuffle [on/off]".  The "Add" command adds the request to the existing queue of the player.  If the player is idle, it will remain idle even though items will be added ot the queue.
  - "Add artist Don Henley" or "Add album Ripcord by Keith Urban in the mediaroom with shuffle on"
- **Pause** intent, pauses the named player.
  - "Pause player" or "Pause the mediaroom" or "Pause the kitchen"
- **Re-start** intent, starts or re-starts a paused player.
  - "Re-start player" or "Start the mediaroom"
- **Next track** intent, skips to the next track of the named player.
  - "Next track" or "Next track in the mediaroom"
- **Pause** intent, pauses the named player.
  - "Pause player" or "Pause the mediaroom" or "Pause the kitchen"
- **Set** intents are structured as follows:  "Set [volume, sleep timer, shuffle, repeat, player, source] to [value, time, on / off, player name, music source]". The set command values get stored in HA and are used as defaults unless specified directly in the intent.
  - "Set volume to 30" or "Set volume to 50 in the kitchen" - Volume range is 0 to 100
  - "Set sleep timer to 30 minutes" or "Set sleep timer to 45 minutes in the bedroom" - Timer range is 0 to 60 minutes
  - "Set shuffle on" or "Set shuffle off in the kitchen"
  - "Set repeat on" or "Set repeat off in the mediaroom"
  - "Set player to the garage"
  - "Set music source to lms" or "Set music source to Spotify" or "set music source to local" - Sources local and lms are the same
- **Sync or Link** intent, provides the ability to synchronize squeezebox players.  The command is structured as follows:  "Sync [player name] to [master player name]". If the [master player name] is ommitted, the player will be synced with the current default master player in HA.  Examples include: .
  - "Sync the garage to the kitchen" or "Sync the garage"
  - "Link the garage to the kitchen" or "Link the garage"
- **Sync All or Link All** intent, provides the ability to synchronize all squeezebox players to the same master.  The command is structured as follows:  "Sync all players to [master player name]". If the [master player name] is ommitted, the players will be synced with the current default master player in HA.  Examples include: .
  - "Sync all players to the garage" or "Sync all players"
  - "Link all players to the garage" or "Link all players"
- **Unsync or Unlink** intent, provides the ability to unsynchronize squeezebox players.  The command is structured as follows:  "Unsync [player name]". Examples include: .
  - "Unsync the garage" or "Unlink the garage"
- **Unsync All** intent, provides the ability to unsynchronize all squeezebox players.  The command is structured as follows:  "Unsync [player name]". Examples include: .
  - "Unsync all players" or "Unlink all players"
- **Help** intent, gives basic help for the LMS Controls app.
  - "Help"
- **Sample commands** intent, gives a detailed list of sample commands.
  - "Sample commands"
- **Version** intent, gives the DialogFlow verison number for the LMS Conrol app.
  - "Version"
- **Get player status** intent, returns the current player's status including volume, shuffle, repeat and track's title, artist name and album to Google.
  - "Get player status?" or "Get kitchen player status"
- **What's playing** intent, returns the current track's title, artist name and album to Google.
  - "What's playing?" or "What's playing in the kitchen"
- **Follow Up?** Google will prompt you to follow up on any queries you submit.  Answering "Yes" will return audio feedback of the results of your query (lms_query_result).  "No" or silence will abort this action.
- **Finished** intent, is the exit intent.  It ends the conversation, closes the app and returns control to google.  You can quit the app at anytime by saying:
  - "Goodbye" or "Cancel"

**Note:**  When items are left out of the command (ie: player name, music source, etc..) LMS Controls uses the current value in the HA GUI as the default to fill in.  If the item is critical, LMS Controls will prompt for it.

## Example Implicit Intent Commands
**Start-Up Phrase:** is used to call up the app for Google Home or Google Assistant and send the intent command all in one sentence. The startup phrase is:

  - "Hey google, ask to LMS Controls to [insert explicit intent here]"

Provided your implicit intent was understood google will call up the LMS Controls app and issue your intent directly without asking "How can I help?". If the intent was not understood you will get the "How can I help?" prompt and be returned to explicit mode.

After your command has been issued, you have up to 10 seconds to issue any other follow-up explicit intents before the app closes automatically.

Some implcit intent examples are:
  - "Hey google ask LMS Controls to play album 2112 by Rush in the mediaroom with shuffle on"
  - "Hey google ask LMS Controls to set the volume to 50"
  - "Hey google ask LMS Controls to pause player"

## Here Are Some Example Conversations Using LMS Controls
- Example #1: Implicit intent followed by several explicit intents

      USER	hey google ask LMS Controls to play artist Diana Krall in the media room
      AGENT	Playing artist Diana Krall in the mediaroom
      USER	add artist Norah Jones
      AGENT	Adding artist Norah Jones to the current queue
      USER	set volume to 40
      AGENT	What volume (between 1 and 100)
      USER	40
      AGENT	Setting the volume to 40 for the current player
      USER	set sleep timer to 30 minutes
      AGENT	Setting sleep timer to 30 minutes for the current player
      USER	set shuffle on
      AGENT	Setting shuffle on on the current player
      USER	actions_intent_CANCEL
      AGENT	Goodbye, returning control to google

- Example #2: Implicit intent with no follow up (10 seconds of silence then Goodbye)

      USER	hey google ask LMS Controls to play artist Triumph in the media room
      AGENT	Playing artist Triumph in the mediaroom
      USER	actions_intent_CANCEL
      AGENT	Goodbye, returning control to google

- Example #3: Explicit intents only

      USER	Hey google talk to LMS Controls
      AGENT	How can I help?
      USER	set music source to spotify
      AGENT	Setting music source to spotify
      USER	play artist rush
      AGENT	Playing artist rush using the current player
      USER	actions_intent_CANCEL
      AGENT	Goodbye
  
