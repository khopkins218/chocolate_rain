require 'net/pop'
require 'mail'
require 'daemon'
require 'y_video'
require 'mail_handler'

class MailFetcher < Daemon::Base
  def self.start
    loop do
      puts "Running Mail Importer..." 
      pop = Net::POP3.new('mail.hasflavor.com')

      pop.start("app@hasflavor.com", "oi890po")

      if pop.mails.empty?
        puts "NO MAIL" 
      else
        i = 0
        puts "receiving mail..." 
        pop.each_mail do |m|
          MailHandler.receive(m.pop)
          m.delete
          i += 1
        end
        puts "#{pop.mails.size} mails popped"
      end
      pop.finish
      puts "Finished Mail Importer."
      
      sleep(10)
    end
  end
  
  def self.stop
    puts "Stopping Mail Fetcher Daemon"
  end
end

MailFetcher.start
