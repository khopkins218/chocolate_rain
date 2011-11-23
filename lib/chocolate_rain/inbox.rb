require 'net/pop'
require 'mail'
include Daemon
include ChocolateRain

class MailFetcher < Daemon::Base
  def self.start
    loop do
      pop = Net::POP3.new('mail.hasflavor.com')
      pop.start("app@hasflavor.com", "oi890po")

      if !pop.mails.empty?
        pop.each_mail do |m|
          ChocolateRain::MailHandler.receive(m.pop)
          # m.delete
        end
      end
      pop.finish
      sleep(30)
    end
  end
  
  def self.stop
    puts "Stopping Mail Fetcher Daemon"
  end
end