require 'net/ftp'
require 'fileutils'
require 'youtube_it'

module YouTuber
# Youtube Creds
  def upload(f)
    YT_CLIENT ||= YouTubeIt::Client.new(:username => "whyhermancain" , :password => "999m3@nsj0bs" , :dev_key => "AI39si79BSRx1X9AtG5zNxo-wk5YGiIHa-FAt5BNvb2poO7AVdNJEYoCgxg-JilsgHbNr0IUFk8j490v_LOZ8iPKueOUea6DdQ")

    YT_CLIENT.video_upload(File.open("#{Rails.root.to_s}/public/videos/#{f}"), :title => "#{f}", :description => "Testimonial Video", :category => "Entertainment", :keywords => %w[herman cain whyhermancain republican politics testimonal donate donation], :list => "denied", :comments => "denied", :rate => "denied", :commentVote => "denied", :videoRespond => "denied", :embed => "denied", :syndicate => "denied")
    puts "completed #{f}"
  end
end

# FTP creds
URL = "fx0j7sls.rtmphost.com"
USERNAME = "fx0j7sls"
PASSWORD = "oi890_{PO"
DIRECTORY = "/fx0j7sls_apps/VideoGallery/streams/_definst_"
FORMAT = "flv"

@local_files = []

ftp = Net::FTP.new
ftp.connect(URL, 21)
ftp.login(USERNAME, PASSWORD)


ftp.chdir(DIRECTORY)
filenames = ftp.nlst("*.#{FORMAT}") # comes back as array

# loop by index
filenames.each_index do |i|
  puts "working with index: #{i}"
  localfile = "#{Rails.root.to_s}/public/videos/#{i}.#{FORMAT}"
  ftp.getbinaryfile(filenames[i], localfile)
  puts "got #{i}.#{FORMAT}"
  @local_files << "#{i}.#{FORMAT}"
  puts "*** \n"
end

filenames.each do |filename|
  puts "Deleting #{filename}"
  ftp.delete("#{filename}") # deleting from server so we don't re-download
  puts "complete.\n***\n"
end

puts "Starting upload stack\n...\n......"
@local_files.each do |f|
  YT_CLIENT.video_upload(File.open("#{Rails.root.to_s}/public/videos/#{f}"), :title => "#{f}", :description => "Testimonial Video", :category => "Entertainment", :keywords => %w[herman cain whyhermancain republican politics testimonal donate donation], :list => "denied", :comments => "denied", :rate => "denied", :commentVote => "denied", :videoRespond => "denied", :embed => "denied", :syndicate => "denied")
  puts "completed #{f}"
end

puts "...el fine..."