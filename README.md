# COD4 Docker dedicated server #
Runs a Call of duty 4 Modern Warfare dedicated server in a Docker container.

Update: New feature. The docker can now get the gamefiles for you.
<img align="right" src="https://raw.githubusercontent.com/henkall/cod4xServer-dockerv2/main/cod4.ico">

[![](https://images.microbadger.com/badges/version/henkallsn/docker-cod4.svg)](https://microbadger.com/images/henkallsn/docker-cod4 "Image Version")
[![](https://images.microbadger.com/badges/image/henkallsn/docker-cod4.svg)](https://microbadger.com/images/henkallsn/docker-cod4 "Image Size")
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/paypalme/henkallsn)
- Based on:
    - [Cod4x](https://cod4x.ovh/) server program
- You should go get the Windows client from https://cod4x.ovh/
    - It is a patch to Call of Duty 4 Modern Warfare so you are able to se the server.
- Works with custom mods and usermaps
- You can find a sample file to a "server.cfg" file on github.
~~~
https://github.com/henkall/cod4xServer-dockerv2
~~~

## Here is a example to get going with a server using compose. ##
~~~
---
services:
  cod4server:
    image: henkallsn/cod4xwebguidash:beta
    # Change the name if you want to.
    #container_name: newcod4xwebgui
    ports: 
      - 8100:80
      # Lav flere hvis mere end en server. (Todo WIP)
      - 0.0.0.0:28960:28960/udp
    environment:
      - EXECFILE=server.cfg
      - SERVERTYPE=1
      - PORT=28960
      - MAP=+map_rotate
      - EXTRA=+set sv_authorizemode -1
      # Remember to change (Same as MYSQL_ROOT_PASSWORD).
	  - SQLPASSWORD=password
    volumes:
      # Remember to change this
      # Place for the gamefiles to be placed
      - <path/to/appdata>/coddash:/root/gamefiles
      # Place for the webgui
      - <path/to/appdata>/coddash:/var/www/html

# --------------------------------------------------------------------
  mariadb:
    image: mariadb
    volumes:
      # Remember to change.
      - <path/to/appdata>/coddash/database:/var/lib/mysql
      - <path/to/appdata>/coddash/dbinitfile:/docker-entrypoint-initdb.d
    ports:
      - 3307:3306
    environment:
      # Remember to change.
      MYSQL_ROOT_PASSWORD: password
# --------------------------------------------------------------------
  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    ports:
      - 8101:80
    environment:
      PMA_HOST: mariadb
    depends_on:
      - mariadb
# --------------------------------------------------------------------
~~~

Note the following.

The server.cfg file should be located in the main folder. 

If you are running with a mod then the server.cfg file for that mod has to be in the same folder as the mod.

| **Folders** | **Description** |
| --- | --- |
| Mods | I keep any mods I want to use on the server in here |
| usermaps | I keep my custom maps in here |

Important:

The docker uses "EXECFILE", "PORT", "MAP", "MODNAME" and "EXTRA" enviroment variable to pass commands to the servers startup.
It also uses the "READY" enviroment variable just to check if you want to do this. :) If Empty it won't start.
Here is a list of commands that I use:

| ** Variable name ** | **Description** | **Value** |
|---|---|---|
| READY | Checking if you are Ready. Server don't start if this is empty | YES |
| EXECFILE | The name of the config file that should be used. Placed in the "main" folder if you are not using mods. When mods is used you can place the file on the same folder as the mod. | server.cfg |
| SERVERTYPE | 2 Is for Internet. 1 Is for LAN. If 2 is used you have to use: set sv_authtoken "mytokenhere" in the server.cfg file. You can read about it [HERE]. |  1 |
| PORT | Set what port the server should run on. If left empty this defaults to 28960 | 28960 |
| MAP | Starts the server with the defined rotate sequens in server.cfg file. | +map_rotate |
| MODNAME | Defines what mod you whant to use. Write the name of the folder that you mod is in. For example modernpaintball. | $MODNAME$ |
| EXTRA | 1 only allows players with legal copies to join, 0 allows cracked players, and -1 allows both types of players while the Activison authentication server is down. | +set sv_authorizemode -1 |
| GETGAMEFILES | Tells the server to get gamefiles or not. 1 is to get files. 0 is not to get files. | 1 |


[HERE]: https://cod4x.me/index.php?/forums/topic/2814-new-requirement-for-cod4-x-servers-to-get-listed-on-masterserver/
## Testing

1. Run a COD4 client and try to connect to `yourhostIPaddress:28960`

OBS: If you can't see the server in the game then try to add the server ip to the favorites in Call of Duty server list. Remember the portnumber. Also check your filter so you allow it to show moded servers.

If you are running version 1.7 of the game then get the patch from https://cod4x.ovh/ (The Windows client download). This can be removed again if you don't want to use it anymore.
