# Kasm_Linode_Install_Scripts
These are bash scripts to be used to automate the installation of Kasm on Linode servers.
You can find these already loaded into Linodes StackScript system by searching for kasm or going to 

https://cloud.linode.com/stackscripts/964873


## Kasm_Basic_Install - 
    This Script runs a basic Kasm single server installation on to an Ubuntu 20.04 LTS image 
    as outlined on the Kasm Docs...

https://kasmweb.com/docs/latest/install/single_server_install.html

    The usernames and generated passwords can be found after the installation finishes in the
    SSout.txt file in the root directory. Login to the lish console with your root password 
    and type " vi SSout.txt" then page down to the bottom of the file to find the admin@kasm.local
    and user@kasm.local passwords. (esc : q enter to quit VI) The image takes a few minutes to 
    download, do not reboot the server, you will be given a login prompt on the lish console 
    once it is ready.

## Kasm_LargeSwap_Install - THIS IS NOT DONE YET!!! PLAY WITH IT AT YOUR OWN RISK
    this Script runs the basic install scripts plus it hardens your linode server and upgrades 
    the size of the swap and sets a default sudo user outsie off the root. 

