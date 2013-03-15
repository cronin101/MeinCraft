class RINETD
  LOCAL_IP = '198.211.120.146'
  LOCAL_PORT = 88
  SLAVE_PORT = 8008

  def self.redirect_port_to(ip_address)
    File.open('/etc/rinetd.conf', 'w') do |f|
      f.puts "#{LOCAL_IP} #{LOCAL_PORT} #{ip_address} #{SLAVE_PORT}"
      f.puts 'logfile /var/log/rinetd.log'
    end
  end

  def self.restart
    puts `sudo /etc/init.d/rinetd restart`
  end

end
