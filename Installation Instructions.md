## **LMS Controls - Installation Guidelines** - January 18, 2019

------

The following document outlines the steps required to install and configure all the software tools required to create a functional voice control system for your LMS server.  A troubleshooting guide is also available [here](https://github.com/ynot123/LMS_Controls/blob/master/troubleshooting.md) should you run into issues making this work.

The **basic installation order** and functionality requirements are as follows:

1. LMS Server with at least one working player:
   - LMS web gui is accessible and functional
2. Hass.io or Home Assistant installed on your preferred platform.  Hass.io is recommended in particular for new users as it's easier to configure and provides access to pre-built add-ons (Configurator, DuckDNS, Let's Encrypt, etc..) to ease the learning curve.  
   - Hass.io must be accessible from the internet using https://yourdomain.duckdns.org or similar secure link.
   - Install and test all LMS Controls functionality from within Hass.io or HA **before** proceeding to the DialogFlow (voice control) portion of the project.
   - Hass.io or Home Assistant must support the following commands in order for the shell commands to work:
     - curl, jq, nc, socat (for secure LMS only).  **Note:** if your system doesn't support nc, netcat can be used but the shell files will need to be modified to reflect this change.
3. DialogFlow agent created in the DialogFlow console online.  This allows voice control of LMS by sending the intents to HA, HA interprets the intent and sends the information to LMS server to queue.  
   - Begin testing controls by typing commands into DIalogFlow **Try it now** window.
   - Proceed to testing using Google Assistant (typing or voice commands)
   - Complete testing using Google Home voice commands using "Talk to LMS Controls" or whatever your invocation becomes.

During the process, you will likely run into a few issues and can consult the troubleshooting guide (an ever expanding document) for tips and tests to help determine any issues.  



#### Section A - LMS Server Requirements:

1. Ensure you have a running LMS server that is accessible from your HA (Hass.io / Home Assistant) server.

2. To provide consistency in naming conventions between LMS and HA, ensure all your lms player names do not have a space in them, use "_" instead or preferably all one word (ie: livingroom or living_room).

3. Make a list of all your lms player names and their mac addresses.  This will be required in HA and DialogFlow installation sections.

4. Make note of the IP address of your lms server and the CLI port number (9090 is the default).

5. If using "secure" version of LMS server, make note of username and password required for access to the LMS web GUI. 

6. Some additional notes regarding the LMS server installation details, playlist and radio station naming conventions and Spotify requirements are available at https://github.com/ynot123/LMS_Controls/blob/master/LMS/README.md. 

   

#### Section B - HASS.IO - Dedicated Raspberry PI Installation Instructions

The following instructions will go through the basic installation of **Hass.io** on a dedicated Raspberry PI using a pre-configured image.  It makes use of DuckDNS / Lets encrypt add-ons to allow outside access over the internet to your Hass.io installation.  **For other systems** see Hass.io - Home Assistant Installation document for multiple platforms see file: **Hass.io_HA_Platform_Installs.md**

If you already have a fully configured and running version of Hass.io or Home Assistant which is accessible over the internet using https://yourdomain.duckdns.org you can skip directly to **HA LMS Controls** installation section.

1. Download a copy of Hass.io install from here:  https://www.home-assistant.io/hassio/installation/

2. If using an image file (raspberry PI, Odroid, Intel-NUC), install Etcher from here:  https://www.balena.io/etcher/ and write the image file to your SD card (32GB or larger recommended)

3. Install and boot PI and let it do it's thing (updates, install, etc..) for up to 20 minutes.  You can monitor progress of the installation using the PI's IP address link http://xxx.xxx.xxx.xxx:8123.  It can take 10 minutes before this link is available.

4. Once installation completes, you will see the Home Assistant logo and be prompted for your name, username and password.  Enter these, and press **Create Account**.

5. Login using the previous username and password

6. Install the following components from the Hass.io Add-on Store (http://xxx.xxx.xxx.xxx:8123/hassio/store):

   - Install **Configurator** Add-on:  Browser-based configuration file editor for Home Assistant
      - When the configuration screen is displayed, edit the username and password.  ***Note*** both username and password must be enclosed in quotes.  Press the **Save** button.
      - Press the **Start** button to start the add-on and ensure it started.
      - Review the **log** at then bottom of the page to ensure startup of the addon was successful
   - **DuckDNS** Add-on:  Free Dynamic DNS (DynDNS or DDNS) service with Let's Encrypt support.
      - Before proceeding to this step, create an account (free) on DuckDNS (http://www.duckdns.org/) and define your domain.  This will allow you to access your Hass.io installation using https://yourdomain.duckdns.org/ .  Take note of your **DuckDNS Token**.
      - Install DuckDNS add-on and when the configuration screen is displayed, edit the Config file and make the following changes:
        - Set "accept_terms": true
        - Set  "token": "your_duckDNS_token"
        - In the "domains" section replace null with **"yourdomain.duckdsn.org"**
        - Press the **Save** button
        - Press the **Start** button to start the add-on and ensure it started.
        - Review the **log** section at the end of the page to ensure the key is generated and start-up is successful.  Click refresh to see any new messages.  Complete start-up of this add-on can take a minute or two.

7. Add the following entry to the port forwarding section on your router to allow outside access to your Hass.io installation:

   - **forward external_port:443 to internal_port:8123 of "your_Hass.io_ip_address for UDP & TCP**

8. Using the configuration file editor (http://xxx.xxx.x.xx:3218) make the following changes:

   - Call up the **configuration.yaml** file and find the **http:** section and make the following changes:
   ```
   http:
     base_url: yourdomain.duckdns.org
     ssl_certificate: /ssl/fullchain.pem
     ssl_key: /ssl/privkey.pem
     trusted_networks:
       xxx.xxx.xxx.0/24 
   ```
   - Replace xxx.xxx.xxx with the first 3 octets of your ip network for HA.
   - **Save** your changes.

9. Check your configuration using http://xxx.xxx.x.xx:8123/config/core.  Once the configuration is valid,  **restart** Hass.io.  **Note** On the raspberry PI, a reboot can take several minutes.

10. Once Hass.io returns, you will now access it via the internet using the secure link:  https://yourdomain.duckdns.org/states which will be accessible in and out of your local network

    

#### Section C - HA - LMS Controls Installation / Configuration Instructions

The following section details the installation of the LMS Controls files for Hass.io or Home Assistant and outlines the modifications required to various files.  Here you will enter the required ID's, usernames, passwords, ip addresses, player names and MAC addresses and other pertinent information required to configure the system. 

1. Webhook Integration (Webhook_ID):

   - From the HA configuration menu, press **integrations** (https://yourdomain.duckdns.org/config/integrations/dashboard) 

   - Press the **configure** button adjacent to the DialogFlow item, then press the **submit** button on the pop-up window
   - Copy and save the **URL entry** for later use in the DialogFlow portion of this project

2. Long Lived Access Token (HA_Token):

   - Call up the Profile section by pressing on your **username initials** in the HA GUI or go here: https://yyourdomain.duckdns.org/profile  
   - Scroll down to the Long Live Access Tokens section in the GUI
   - Press the **Create token** button and give it a name "lmscontrols_token"
   - Copy and save this token for later use in DialogFlow and for the shell files

3. Go to the LMS Controls GitHub https://github.com/ynot123/LMS_Controls and download the latest copy of the project.

4. Merge the contents of the LMS project file **/HomeAssistant/config/configuration.yaml** into your current **configuration.yaml** file using the configuration file editor (http://your_hassio_ip:3218/).   Take care to ensure your entries are pasted into their proper sections of the yaml file (ie:  **packages** entry belongs in the **homeassistant:** section of the file).

   - In the **media_player** section, revise the entries for host, username and password as per the commented instructions in the file.
   - Check your configuration using https://yourdomain.duckdns.org/config/core.  Once the configuration is valid,  restart HA.
   - Upon successful restart, you should now be able to see your LMS players in the HA GUI front-end when you press the Overview button in the HA GUI.
   - You can review the player names and status using the following link https://yourdomain.duckdns.org/dev-state

5. If your **automations.yaml** is empty, merge the contents of the LMS project **automation.yaml** file into your current automations.yaml file.  **Note** automations.yaml is not allowed to be empty when using package files. 

6. Using the configuration file editor, navigate to the **/config** folder (where configuration.yaml file is stored).  While in the /config folder:

   - Create a folder called **packages**
   - Create a folder called **shell**

7. Navigate into the shell folder and upload the ***.sh** project files contained in the /HomeAssistant/config/shell/ project folder.  There are a **total of 10 shell files**.

8. Modify the **env_var.sh** file as outlined in the comments in the file.  Entries include: domain, long lived token (see step 2), spotify client ID and secret (from your Spotify Developer's account), LMS server IP address, CLI port number and if using the secure version of LMS server, the username and password (if not leave these as **null**).

9. Save the modified **env_var.sh** file. 

10. Navigate into the packages folder and upload the LMS project file **lmscontrols.yaml**

11. Modify the **lmscontrols.yaml** file as per the commented sections in the file.  **TIP:**  Search the file for text "To be updated as required" for areas requiring changes.  Sections to be modified are outlined below:

    - In the **customize section**, update the **media_player.entity_id_name** and the **name** and the **player_id** fields to suit your LMS server player details.  Up to 10 media_players can be defined.
    - In the **shell_command section**, review the defined path to the shell files to ensure it's consistent with your installations path (typically **/config/shell/**)
    - In the **input_boolean section**, update the lms_media_player1_sync **name** field to the same media_player **entity_id_name** defined in the customize section above.  Update up to **lms_media_player10_sync names**.  Leave any unused players defined as **unassigned**.
    - In the **input_select section**:
      - Update the **options** field for the **lms_source** entity to remove any sources you don't plan to use.  At this time only **lms** and **spotify** are supported.
      - Update the **options** field for the **lms_player** entity to reflect the **entity_id_names** of your lms players.  Up to 10 players are supported.
      - Update the **options** field for the **lms_sync_master** to reflect the **entity_id_names** of your lms players.  Up to 10 players are supported.
       - In the **group section**:
            - Update the **lms_sync_players entities** list to add or remove the comment (#) symbol to reflect your number of lms players (up to 10 players) that should be shown in the traditional GUI for synchronization.
            -  Update the **all_lms_players entities** list to reflect the entity_id names of the players you want to have show up in the traditional GUI.

   12. Check your configuration using https://yourdomain.duckdns.org/config/core.  Once the configuration is valid,  restart HA.

   13. Once HA returns, you should now have a GUI with an LMS Controls tab and controls.  Test the basic controls as follows:

          - Start an LMS player using the LMS server web interface.  You should see this player playing in your HA GUI for the media player.
          - In the HA LMS Controls GUI and:
               - Set the media player name to the currently playing player
               - Set music source to lms
               - Test pause function, play and next track
               - Test volume, sleep timer, shuffle and repeat
               - Type in an artist name and then select LMS command:  **play artist**.  The command should remain active for 1 second and then return to -----------------.  This should queue the selected artist to the selected media player.  The query result will be posted in the Query Result field at the bottom of the LMS Sync Controls card.  If the result is **null**, the query returned an empty or invalid result.  If you believe the query should be valid, you may have issues with the data entered for the shell script (HA token, mydomain, etc..).  Please see the troubleshooting guide for further error checking.
               - Test the rest of the functions to ensure proper operation of the LMS Controls system.

   14. Updating the Lovelace GUI.  A somewhat sleeker GUI is available when using the specialized Lovelace cards available for HA.  If using **ui-lovelace.yaml** file or the Lovelace Raw config editor, merge the contents of the LMS project **ui-lovelace.yaml** file into your current file.  For more details on the HA Lovelace interface and its use, see https://www.home-assistant.io/lovelace/.

       

#### Section D - DialogFlow - Agent Creation and Configuration Instructions

1.	Call up the DialogFlow console from here https://console.dialogflow.com/api-client/#/login . Sign in using your google account.
2.	Create a New Agent, call it what you wish. Select your default language and time zone and finally click Create
3.	Under the DF Sidebar, click on the **gear icon** to call up your Agent settings
4.	Click on **Export and Import** and **restore** the LMS Project ZIP file **/DialogFlow/LMS_Control_Agent - Sanitized.zip**.  This will import the pre-defined entities and intents to be used by Google Home or Google Assistant.  **Note**:  Any existing intents and entities will be over written.
5.	Under the **General Tab** ensure API Version is set to **V1 API**.  Press save button
6.	Webhooks setup:
      - Enable Webhooks under the fulfillment section of DF.
      - Fill in the **URL** field with https://homeassistant.duckdns.org/api/webhook/insert_your_webhook_id_here replacing:
         - **homeassistant** with your **yourdomain** and;
         - **insert_your_webhook_id_here** with your **Webhook_ID** as generated by the HA DialogFlow integration component from step 1 of the HA - LMS Controls Install / Config section above.
      - In the **Headers** section:
         - Replace **insert_your_long_lived_token_here** with your **long lived access token ID** generated by Home Assistant in step 2 of the HA - LMS Controls Install / Config section.
      - Scroll to the bottom of the page and **save** your changes.
7.	Entities updates:
      - Under the DF sidebar, select Entities and choose **@mediaplayers**.  Update the names and synonyms to reflect your media_player **entity_id_names** and any synonyms you may have for them.  The media_player **entity_id_names** is the part after the **media_player.** of your existing LMS media player entities in HA.  As an example for the HA entity **media_player.kitchen** the name would be **kitchen**
      - Choose **@source** and update the music source entity if required.  At this time, only LMS (local) and Spotify are supported.
8.	Your are now ready to test your DialogFlow application using the "Try it now" window.  Type a few commands like:  Set volume to 30 in the kitchen;  Play artist Supertramp in the living room.  Test your commands to ensure they are working properly.
9.	Once your commands are functional in DialogFlow press the "See how it works in Google Assistant" link to test your app in Google Assistant and GoogleHome. 
10.	In Google Assistant test your basic functions be either typing in the commands or using voice control with the Assistant.  If the account you used to develop this app is already registered to your GoogleHome then you should be good to go.   Assuming your invocation is set to "LMS Controls", you can call your up using GoogleHome by saying, "Hey Google, talk to LMS Controls"
11.	If you want to get rid of the annoying test message, you need to publish (release) your application as Alpha or greater.  You can get further details on this here:  https://developers.google.com/actions/deploy/release-environments.  **Note:** After publishing the app, it will take about 8 hours for it to be useable the first time.  Subsequent changes are nearly immediate.     

