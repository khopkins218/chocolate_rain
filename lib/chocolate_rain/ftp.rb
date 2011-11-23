require 'net/ftp'
require 'fileutils'
include Daemon
include ChocolateRain

module ChocolateRain
  class FtpMachine
    def self.start
      ChocolateRain::FtpWorker.do_work
    end
  end
end