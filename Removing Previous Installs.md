## LMS Controls Project - Removing a Previous Installation
I assume if you've installed this already, you must be pretty familiar by now with Hass.io or Home Assistant.  The instructions below require modification of your configuration files.  Please remember to make a backup before proceeding.

To remove the previous installation of LMS Controls project (for the installation of a new version), only the Hass.io or Home Assistant configuration files need to be edited to remove the previously made modifications.  

Please note, on the GitHub there is an [archive folder](https://github.com/ynot123/LMS_Controls/tree/master/Archives) containing previously released versions of this project.  You can refer to these files to see what changes were made in your configuration files for that specific version.

The configuration files needing to be edited are as follows:

- **configuration.yaml**:
  - Remove the merged entries from the old project **configuration.yaml** file.
- **automations.yaml**:
  - Remove the merged entries from the old project **automations.yaml** file.
- **customization.yaml**:
  - Remove the merged entries from the old project **customization.yaml** file.
- **groups.yaml**:
  - Remove the merged entries from the old project **groups.yaml** file.
- **ui-lovelace.yaml**:
  - If installed, remove the merged entries from the old project **ui-lovelace.yaml** file.
- **intent.yaml**:
  - Remove the merged entries from the old project **intent.yaml** file.
- **scripts** sub-directory or **scripts.yaml** file: 
  - If you have a scripts sub-directory then delete the file **script_lms_controls.yaml** otherwise;
  - Remove the merged entries from the old project **scripts.yaml** file.
- **shell** sub-directory:
  - Delete **all shell files (.sh)** that were copied over from the old project shell files.

Using the HA Configuration Validation tool, check your config and once it's valid, restart Home Assistant server.  That should do it. 

