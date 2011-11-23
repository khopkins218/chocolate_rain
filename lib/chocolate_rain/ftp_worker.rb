require 'net/ftp'
require 'fileutils'

module ChocolateRain
  class FtpWorker < ActionMailer::Base
    def self.do_work
      @@ftp_creds = YAML.load(File.open("config/fms_config.yml"))["#{Rails.env}"]

      @local_files = []

      ftp = Net::FTP.new
      ftp.passive = true

      puts "Connection"
      ftp.connect(@@ftp_creds["url"], 21)
      ftp.login(@@ftp_creds["username"], @@ftp_creds["password"])
      puts "logged in"

      ftp.chdir(@@ftp_creds["directory"])
      puts "chdir"
      filenames = ftp.nlst("*.#{@@ftp_creds["format"]}")
      puts "got files"
      # loop by index
      filenames.each_index do |i|
        begin
          f = File.open("#{Rails.root}/tmp/#{i}.#{@@ftp_creds["format"]}")
          ftp.getbinaryfile(filenames[i], f)
          v = ChocolateRain::YVideo.new()
          v.filename = i 
          v.file_object = f
          v.title = i
          @local_files << "#{i}.#{@@ftp_creds["format"]}"
        rescue Exception => e
          puts "Error in FTP: #{e.message}"
        end
      end

      filenames.each do |filename|
        # ftp.delete("#{filename}")
      end

      @local_files.each do |f|
        begin 
          v.save
        rescue Exception => e
          puts "Exception: #{e.message}"
        end
      end
    end
  end
end