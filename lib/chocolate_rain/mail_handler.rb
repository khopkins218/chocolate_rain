require 'mail'
require 'stringio'

module ChocolateRain
  class MailHandler < ActionMailer::Base
    def resend(sender, recipient, subject, body)
      mail(:from => sender,
           :to => recipient,
           :subject => subject,
           :body => body)
    end
    
    def receive(email)
      resend_multipart(email)
    end
  
    def resend_multipart(email)
      email.attachments.each do |att|
        fn = att.filename
        v = ChocolateRain::YVideo.new()
        begin
          f = StringIO.new(att.body.decoded)
          v.filename = fn 
          v.file_object = f 
          v.title = fn
          begin 
            v.save
          rescue Exception => e
            puts "Exception: #{e.message}"
          end
        rescue Exception => e
          puts "Exception: #{e.message}"
        end
    
        begin
          resent = resend("whyhermancain@gmail.com", "support@wearefound.com", "[CAIN] Successful Upload", "A new testimonial video has been uploaded via email to s3.  Its url is http://s3.amazonaws.com/whyHermanCain/#{v.filename}")
          resent.deliver
        rescue
          return
        end
      end
    end
  end
end