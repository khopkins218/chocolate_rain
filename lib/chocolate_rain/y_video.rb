require 'youtube_it'
require 'aws/s3'

class YVideo
  attr_accessor :filename, :file_object, :title, :description, :category, :keywords, :list, :comments, :rate, :commentVote, :videoRespond, :embed, :syndicate
  
  @@YCONN = YouTubeIt::Client.new(:username => "whyhermancain" , :password => "999m3@nsj0bs" , :dev_key => "AI39si79BSRx1X9AtG5zNxo-wk5YGiIHa-FAt5BNvb2poO7AVdNJEYoCgxg-JilsgHbNr0IUFk8j490v_LOZ8iPKueOUea6DdQ")
  @@y = YAML.load(File.open("#{Rails.root.to_s}/config/s3.yml"))
  AWS::S3::Base.establish_connection!(
    :access_key_id => @@y[(Rails.env)]["access_key_id"],
    :secret_access_key => @@y[(Rails.env)]["secret_access_key"]
  )
  
  def initialize
    @filename = nil
    @description = nil
    @category = nil
    @keywords = []
    @list = "denied"
    @comments = "denied"
    @rate = "denied"
    @commentVote = "denied"
    @videoRespond = "denied"
    @embed = "denied"
    @syndicate = "denied"
  end
  
  def to_hash
    self.instance_variables.inject({}) { |hash,var| hash[var.to_s.delete("@")] = self.instance_variable_get(var); hash } 
  end
  
  def upload
    @@YCONN.video_upload(File.open("#{Rails.root.to_s}/public/videos/#{f}"), :title => "#{f}", :description => "Testimonial Video", :category => "Entertainment", :keywords => %w[herman cain whyhermancain republican politics testimonal donate donation], :list => "denied", :comments => "denied", :rate => "denied", :commentVote => "denied", :videoRespond => "denied", :embed => "denied", :syndicate => "denied")
  end
  
  def save
    puts "in save"
    begin
      bucket = AWS::S3::Bucket.find(@@y[(Rails.env)]["bucket"])
    rescue 
      bucket = AWS::S3::Bucket.create(@@y[(Rails.env)]["bucket"]) 
    end
    if AWS::S3::S3Object.store(self.filename, self.file_object, @@y[(Rails.env)]["bucket"], :access => :public_read)
      return true
    else
      return false
    end
  end
end