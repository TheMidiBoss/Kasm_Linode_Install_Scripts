# Kasm_Linode_Install_Scripts
These are bash scripts to be used to automate the installation of Kasm on Linode servers.


Kasm_Basic_Install - 
 This Script runs a basic Kasm single server installation as outlined on the Kasm Docs...
 https://kasmweb.com/docs/latest/install/single_server_install.html
 The usernames and generated passwords can be found after the install finishes in the
 SSout.txt file in the root directory. Login to the lish console with your root password
 and type " vi SSout.txt" then page down to the bottom of the file to find the admin@kasm.local
 and user@kasm.local passwords. (esc : q enter to quit VI)

This installs Kasm on a clean Linode server running Ubuntu 20.04 LTS. 