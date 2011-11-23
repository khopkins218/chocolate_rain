require 'mail'
require 'stringio'
require 'y_video'

class MailHandler < ActionMailer::Base
  def resend(sender, recipient, subject, body)
    mail(:from => sender,
         :to => recipient,
         :subject => subject,
         :body => body)
    puts "Mail sent to #{recipient}"
  end
    
  def receive(email)
    to_email = "apx05eq15zgx@m.youtube.com"
    resend_multipart(email)
  end
  
  def resend_multipart(email)
    email.attachments.each do |att|
      fn = att.filename
      v = YVideo.new()
      begin
        f = StringIO.new(att.body.decoded)
        v.filename = fn 
        v.file_object = f 
        v.title = fn
        begin 
          v.save
          puts "Saving to S3 succeeded"
        rescue Exception => e
          puts "S3 Failed miserably: #{e.message}"
        end
      rescue Exception => e
        puts "Unable to save data for #{fn} because of #{e.message}"
      end
    end
    
    text_body = email.parts.select{|p| p.content_type.include? "text/plain" }.first.body.to_s
      puts "Email subject: #{email.subject}"
      begin
        resent = MailHandler.resend(["whyhermancain@gmail.com"], ["support@wearefound.com"], "[CAIN] Successful Upload", "A new testimonial video has been uploaded via email to s3.  Its url is http://s3.amazonaws.com/whyHermanCain/#{v.filename}")
        resent.deliver
        puts "sent"
      rescue
        return
      end
  end
  
  def upload(f)
    puts "completed #{f}"
  end
end