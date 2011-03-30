require 'sinatra'
require 'digest/sha2'
require 'redis'

configure do
  enable :sessions
  REDIS = Redis.new
end

get '/' do
  erb session[:user] ? :member : :index
end

post '/register' do
  if (user = REDIS.get params[:email])
    if Marshal.load(user)[:password] == (Digest::SHA2.new << params[:password]).to_s
      session[:user] = user
      "Logged in !"
    else
      "Wrong pass"
    end
  else
    user = Marshal.dump :email => params[:email], :password => (Digest::SHA2.new << params[:password]).to_s, :websites => []
    REDIS.set params[:email], user
    session[:user] = user
    "Registered !"
  end
end