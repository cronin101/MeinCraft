class SlaveDriver < Struct.new(:username, :ip, :mc_ram)
  def perform_command_on_slave(command)
    action = "ssh #{username}@#{ip} '#{command}'"
    puts action
    `#{action}`
  end

  def transfer_file_to_slave(file)
    command = "scp #{file} #{username}@#{ip}:~"
    puts command
    `#{command}`
  end

  def transfer_file_from_slave(file)
    command = "scp #{username}@#{ip}:#{file} ./"
    puts command
    `#{command}`
  end

  def kill_sessions
    puts 'Closing all java and active screen sessions'
    perform_command_on_slave 'killall java'
    perform_command_on_slave 'screen -ls | grep "Detached" | awk "{print $1}" | xargs -i screen -X -S {} quit'
  end

  def reset_from_master
    kill_sessions

    puts 'Clearing snapshot data...'
    perform_command_on_slave 'rm -r ~/server'

    puts 'Restoring from latest backup...'
    transfer_file_to_slave './server.tar.bz2'

    puts 'Extracting...'
    perform_command_on_slave "tar -jxvf /home/#{username}/server.tar.bz2"
    puts 'Creating screen session with minecraft server...'
    perform_command_on_slave "cd ~/server; screen -dmS minecraft java -Xms#{mc_ram} -Xmx#{mc_ram} -jar minecraft_server.jar nogui"
  end

  def clone_from_slave
    puts 'Compressing state into backup...'
    perform_command_on_slave 'rm -r ~/server.tar.bz2'
    perform_command_on_slave 'tar -jcvf ~/server.tar.bz2 -C ~ server'

    puts 'Archiving existing backup...'
    `mv ./server.tar.bz2 ./backups/#{Time.now.to_i}-server.tar.bz2`

    puts 'Saving backup from slave...'
    transfer_file_from_slave 'server.tar.bz2'
  end
end
