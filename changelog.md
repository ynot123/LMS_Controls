## LMS Controls - Change Log

**January 21, 2019 - LMS Controls Project**

Minor update to the shell files and the package file was required, basic details are as follows:
- **Shell files:**
  - Fixed dangling quote / double quote in all shell files except env_var.sh. - CRITICAL this prevented proper posting of shell query results on some systems
  - Fixed hard coded URL in qry_player_stat.sh - CRITICAL

- **Package file:**
  - Fixed some duplicate alias', NON-CRITICAL

**January 18, 2019**

- Updated Home Assistant Installation as follows:
  - Use package file for the bulk of the lms_controls app which includes sections for configuration, automation, intent, scripts, groups and customize
  - New features / upgrades include:
      - Added field in HA GUI to show returned query result (input_text.lms_qry_result)
      - Use of contractions in queries no longer returns invalid query results
      - "env.sh" file where you enter your security details only once, all shell files refer to this file for security details (ie: HA_Token, client ID, IP addresses, usernames, password, etc.
      - Audio feedback available on the results of your queries, follow up, what's playing and player status
      - HA GUI current player settings are refreshed automatically from LMS server every 60 seconds to keep everything in sync if users are using LMS interface instead of HA GUI
      - More error checking on the returned query results from the shell script files.  When query result is null, lms will not be affected (won't clear the queue)
      - Used shell files for all query functions for consistency and to allow better error checking.
      - Update shell files to handle both unsecured and secure LMS installations.  **Note:** secured install requires the use of socat in shell files.  
  - Updated DialogFlow to include some new intents (what's playing, player status and follow up for all query functions)
  - Updated installation, troubleshooting and example commands documents 
  - Created HASSIO installation details for multiple platforms to help users new to HASSIO
  - Updated audio demo of LMS Controls for new features

**December 8, 2018**

- Updated DialogFlow to include:
  - Use of long lived token for HA authentication (api_password method is now deprecated)
  - Added Intent Actions in each DF intent to call proper HA Intents
  - Created new intent  "What's Playing ", which returns the artists song, name and album from the current player.  Optionally you can use "What's playing in the kitchen" to specify an alternate (not current) player   
- Updated the following Home Assistant files:
  - Added `intent.yaml` which contains the Intent Actions from DialogFlow and performs the proper actions, launches other scripts and provides feedback to Google
  - Updated `script_lms_controls.yaml` - initial script for setting values from DF has been removed to relocated to `intent.yaml`
- Updated `confguration.yaml` to include DialogFlow component and define `intent.yaml` script.  Also added support for secured versions of LMS
- Update all shell scripts to provide support for long lived tokens in HA
- Created shell scripts `qry_alb_sec.sh` and `qry_alb_song_sec.sh` to support secured versions of LMS and long lived tokens

**August 5th, 2018**

- Updated DF to include voice commands for Sync and Unsyc squeeze players
- Updated `script_lms_controls.yaml` for Sync and Unsync voice commands
- Updated `ui-lovelace.yaml` replaced turn-on with toggle as required by Lovelace upgrade

**August 2nd, 2018**
- Added Implicit Intents: "Hey Googe, Ask LMS Controls to play artist Pink Floyd in the kitchen"
- Updated HA GUI to include syncing of squeezebox players
- Streamlined DF dialog requirements
- Defaults (context) is now based on HA GUI values rather than coded in DF (ie: current player, current source)

**July 27th, 2018**
- Updated `script_lms_controls.yaml` - added filter for blank entries to prevent errors in log

**July 24th, 2018**
- Initial release

