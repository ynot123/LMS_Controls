###  Scripts set environment variables for other shell scripts
###		Dec 28, 2018 - Initial scripts
###
###  Update values below to reflect your installation.
###  If using a secure version of LMS which requires you to login, set lms_username and lms_password
#!/bin/bash  
my_domain=yourdomain.duckdns.org
HA_Token=your_HA_long_lived_access_token
spot_client_id=your_spotify_client_id
spot_client_secret=your_spotify_client_secret
lms_ip=your_lms_server_ip_address
###  lms_cli_port 9090 is the default, if you've changed it, enter the new port in the line below
lms_cli_port=9090
###
###  Only change the username and password fields below if using secure version of LMS
###  The LMS username and password should be the same as set in the configuration.yaml entry for LMS
###
###  An entry of null indicates the use of unsecured version of LMS
###
lms_username=null
lms_password=null
