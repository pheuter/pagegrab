require 'redis'
require 'pony'

r = Redis.new

r.keys.each do |user|
  Marshal.load(r.get(user))[:websites].each do |website|
    time = Time.now
    name = "/home/ubuntu/images/#{website[/(http:\/\/|www\.)(.+)/,2]}_#{time.to_i}.png"
    name ||= "/home/ubuntu/images/#{website}_#{time.to_i}.png"
    `xvfb-run -a phantomjs /home/ubuntu/pagegrab/scripts/rasterize.js #{website} #{name}`
    Pony.mail :to => user, :from => 'page@pagegrab.it', :subject => "PageGrab | #{website} (#{time.strftime('%a %b %d, %I:%M %P')})", :body => "Attached is a 1680x1050 screenshot of #{website} taken at #{time.strftime('%a %b %d, %I:%M %P')}", :attachments => {"#{website}.png" => File.read(name)}
    puts "Sent to #{user} on #{time.strftime('%a %b %d, %I:%M %P')} the file located at #{name}"
  end
end
