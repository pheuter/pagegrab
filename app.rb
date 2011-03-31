require 'sinatra'
require 'digest/sha2'
require 'redis'
require 'pony'

configure do
  enable :sessions
  REDIS = Redis.new
end

get '/' do
  @user = Marshal.load session[:user] if session[:user]
  erb @user ? :member : :index
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

post '/submitwebsites' do
  if session[:user]
    user = Marshal.load session[:user]
    user[:websites] = params[:websites][0..9]
    REDIS.set user[:email], Marshal.dump(user)
    session[:user] = Marshal.dump user
    "Added #{params[:websites][0..9].length} websites !"
  else
    "Not logged in !"
  end
end