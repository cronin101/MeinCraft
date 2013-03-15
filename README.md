# MeinCraft
### Minecraft in the cloud, for mein convenience.

## Comands

### Destroying Slave Droplet
```bash
$ ./meincraft.rb destroy
Closing all java and active screen sessions
ssh minecraft@198.211.126.128 'killall java'
ssh minecraft@198.211.126.128 'screen -ls | grep "Detached" | awk "{print $1}" | xargs -i screen -X -S {} quit'
Compressing state into backup...
ssh minecraft@198.211.126.128 'rm -r ~/server.tar.bz2'
ssh minecraft@198.211.126.128 'tar -jcvf ~/server.tar.bz2 -C ~ server'
Archiving existing backup...
Saving backup from slave...
scp minecraft@198.211.126.128:server.tar.bz2 ./
{"status"=>"OK", "event_id"=>988755}
```
