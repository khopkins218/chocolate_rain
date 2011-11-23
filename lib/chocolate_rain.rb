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
class Loader

  def self.do
    puts "Starting MailFetcher"
    ChocolateRain::MailFetcher.start
    puts "Starting FtpMachine"
    ChocolateRain::FtpMachine.start
    puts "All started"
  end
  
end
end