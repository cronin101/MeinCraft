# MeinCraft
### Minecraft in the cloud, for mein convenience.

MeinCraft uses the *DigitalOcean* API to spawn a droplet for hosting a minecraft server.
All authorisation requires that you add your slavemaster's `id_rsa.pub` into the slave's `authorized_keys` file in the slave droplet image used.

After setting up keys, simply tar a folder called 'server' containing minecraft_server.jar as server.tar.bz2.

### Comands

#### Deploying a Slave Droplet
```bash
$ ./meincraft.rb deploy

#Waiting for slave creation...
#............................................................
#Closing all java and active screen sessions
#ssh minecraft@198.211.126.128 'killall java'
#ssh minecraft@198.211.126.128 'screen -ls | grep "Detached" | awk "{print $1}" | xargs -i screen -X -S {} quit'
#Clearing snapshot data...
#ssh minecraft@198.211.126.128 'rm -r ~/server'
#Restoring from latest backup...
#scp ./server.tar.bz2 minecraft@198.211.126.128:~
#Extracting...
#ssh minecraft@198.211.126.128 'tar -jxvf /home/minecraft/server.tar.bz2'
#Creating screen session with minecraft server...
#ssh minecraft@198.211.126.128 'cd ~/server; screen -dmS minecraft java -Xms1500M -Xmx1500M -jar minecraft_server.jar nogui'
```

#### Destroying Slave Droplet
```bash
$ ./meincraft.rb destroy

#Closing all java and active screen sessions
#ssh minecraft@198.211.126.128 'killall java'
#ssh minecraft@198.211.126.128 'screen -ls | grep "Detached" | awk "{print $1}" | xargs -i screen -X -S {} quit'
#Compressing state into backup...
#ssh minecraft@198.211.126.128 'rm -r ~/server.tar.bz2'
#ssh minecraft@198.211.126.128 'tar -jcvf ~/server.tar.bz2 -C ~ server'
#Archiving existing backup...
#Saving backup from slave...
#scp minecraft@198.211.126.128:server.tar.bz2 ./
#{"status"=>"OK", "event_id"=>988755}
```
