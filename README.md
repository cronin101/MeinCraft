# MeinCraft 
##### Minecraft in the cloud, for mein convenience.

## Description
With one console command you can spawn a VPS instance running Minecraft server on the latest map snapshot.

The default Minecraft port (25565) of the static 'master' server will then forward to the instance.

With one console command you can retrieve the mutated map snapshot (for future deploys) and destroy the instance.

## How?
MeinCraft uses the *DigitalOcean* API to spawn a droplet for hosting a Minecraft server.
All authorisation requires that you add your slavemaster's `id_rsa.pub` into the slave's `authorized_keys` file in the slave droplet image used.

After setting up keys, simply tar a folder called 'server' containing minecraft_server.jar as server.tar.bz2.

## Configuring
A simple YAML config file:

```yaml
creds: # Visible at https://www.digitalocean.com/api_access
  client: 'fake client'
  api: 'fake api key'

slave:
  name: 'MinecraftSlave'
  size: '2GB' # Droplet size, see: https://www.digitalocean.com/pricing
  image: 'Slave Ready' # This image must have java installed and public keys added.
  mc_ram: '1500M' # The amount of RAM to set the JVM heap as.
  region: 'Amsterdam 1'
```

## Comands

#### Deploying a Slave Droplet
```bash
$ ./meincraft.rb deploy
```
```bash
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
#Stopping internet redirection server: rinetd.
#Starting internet redirection server: rinetd.
```

#### Destroying Slave Droplet
```bash
$ ./meincraft.rb destroy
```
```bash
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
