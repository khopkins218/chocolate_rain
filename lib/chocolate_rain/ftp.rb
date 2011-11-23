require 'net/ftp'
require 'fileutils'
include Daemon
include ChocolateRain

class FtpMachine < Daemon::Base
  def self.start
    loop do
      ChocolateRain::FtpWorker.do_work
      sleep(30)
    end
  end

  def self.stop
    put "Stopping FtpMachine"
  end
end
