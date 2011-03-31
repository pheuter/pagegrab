require 'redis'
require 'pony'

r = Redis.new

r.keys.each do |user|
  Marshal.load(r.get(user))[:websites].each do |website|
    time = Time.now
    name = "/home/ubuntu/images/#{website[/(http:\/\/|www\.)(.+)/,2]}_#{time.to_i}.png"
    name ||= "/home/ubuntu/images/#{website}_#{time.to_i}.png"
    `xvfb-run phantomjs rasterize.js #{website} #{name}`
  end
end