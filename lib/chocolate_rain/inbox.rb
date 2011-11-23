require 'net/pop'
require 'mail'
include ChocolateRain

module ChocolateRain
  class MailFetcher
    def self.start
      puts "in start"
      pop = Net::POP3.new('mail.hasflavor.com')
      pop.start("app@hasflavor.com", "oi890po")

      if !pop.mails.empty?
        pop.each_mail do |m|
          puts "new mail"
          ChocolateRain::MailHandler.receive(m.pop)
          m.delete
        end
      end
      puts 'done poppin'
      pop.finish
    end
  end
end