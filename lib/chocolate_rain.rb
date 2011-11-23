require 'logger'
%w( 
  version
  daemon
  y_video
  mail_rain/mail_handler
  mail_rain/inbox
).each{|m| require File.dirname(__FILE__) + '/chocolate_rain/' + m }

class ChocolateRain
  
  # Base error class for the extension
  class Error < RuntimeError
  end
  
  # URL-escape a string. Stolen from Camping (wonder how many Ruby libs in the wild can say the same)
  def self.esc(s) #:nodoc:
    s.to_s.gsub(/[^ \w.-]+/n){'%'+($&.unpack('H2'*$&.size)*'%').upcase}.tr(' ', '+')
  end
  
  # Set the logger for the library
  def self.logger=(any_logger)
    @logger = any_logger
  end

  # Get the logger for the library (by default will log to STDOUT). TODO: this is where we grab the Rails logger too
  def self.logger
    @logger ||= create_default_logger
  end
  
  # Gets mixed into the classes to provide the logger method
  module Logging #:nodoc:
    
    # Return the base logger set for the library
    def logger
      YouTubeIt.logger
    end
  end
    
  private
    def self.create_default_logger
      logger = Logger.new(STDOUT)
      logger.level = Logger::DEBUG
      logger
    end
end