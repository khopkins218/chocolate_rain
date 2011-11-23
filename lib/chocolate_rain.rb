require 'logger'
%w( 
  version
  daemon
  y_video
  mail_handler
  inbox
  ftp
  ftp_worker
).each{|m| require File.dirname(__FILE__) + '/chocolate_rain/' + m }

module ChocolateRain
  puts "Starting MailFetcher"
  MailFetcher.start
  puts "Starting FtpMachine"
  FtpMachine.start
  puts "All started"
end