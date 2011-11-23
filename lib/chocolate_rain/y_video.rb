require 'youtube_it'
require 'aws/s3'

module ChocolateRain
  class YVideo
    attr_accessor :filename, :file_object, :title, :description, :category, :keywords, :list, :comments, :rate, :commentVote, :videoRespond, :embed, :syndicate
    
    @@y_creds = {}
    YAML.load(File.open("config/youtube_config.yml"))[(Rails.env)].each{|key, val|  @@y_creds[key.to_sym] = val}
    @@y_conn = YouTubeIt::Client.new(:username => @@y_creds[:username] , :password => @@y_creds[:password] , :dev_key => @@y_creds[:dev_key])
    @@s3_creds = YAML.load(File.open("config/s3.yml"))
    AWS::S3::Base.establish_connection!(
      :access_key_id => @@s3_creds[(Rails.env)]["access_key_id"],
      :secret_access_key => @@s3_creds[(Rails.env)]["secret_access_key"]
    )
    
    begin
      @@bucket = AWS::S3::Bucket.find(@@s3_creds[(Rails.env)]["bucket"])
    rescue 
      @@bucket = AWS::S3::Bucket.create(@@s3_creds[(Rails.env)]["bucket"]) 
    end
  
    def initialize
      @filename = nil
      @title = ""
      @description = "Testimonial Video"
      @category = "Entertainment"
      @keywords = %w[herman cain whyhermancain republican politics testimonal donate donation]
      @list = "denied"
      @comments = "denied"
      @rate = "denied"
      @commentVote = "denied"
      @videoRespond = "denied"
      @embed = "denied"
      @syndicate = "denied"
      @private = true
    end
    
    def to_hash
      self.instance_variables.inject({}) { |hash,var| hash[var.to_s.delete("@").to_sym] = self.instance_variable_get(var); hash } 
    end
    
    def to_upload_options_hash
      self.instance_variables.inject({}) { |hash,var| (hash[var.to_s.delete("@").to_sym] = self.instance_variable_get(var) unless (["filename", "file_object"].include?(var.to_s.delete("@")))); hash } 
    end
    
    def upload
      resp = @@y_conn.video_upload(self.file_object, self.to_upload_options_hash
      )
      puts "Response: #{resp.inspect}"
      puts "***"
      puts "ID: #{resp.video_id.split(":").last}"
      return true
    end
  
    def save
      begin
        AWS::S3::S3Object.store(self.filename, self.file_object, @@s3_creds[(Rails.env)]["bucket"], :access => :public_read)
        begin 
          self.upload
          return true
        rescue Exception => e
          puts "Upload Failed. #{e.message}"
        end
      rescue Exception => e
        puts "Could not complete save. #{e.message}"
        return false
      end
    end
  end
end