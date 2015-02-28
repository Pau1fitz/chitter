require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'

env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, "postgres://localhost/chitter_#{env}")

require './lib/user'
require './lib/cheet'

DataMapper.finalize
DataMapper.auto_upgrade!

class Chitter < Sinatra::Base

  enable :sessions
  set :session_secret, 'super secret'
  use Rack::Flash

  get '/' do
    @cheets = Cheet.all
    erb :index
  end

  post('/cheets') do
    text = params["text"]
    Cheet.create(:text=> text)
    redirect to('/')
  end

  get('/users/new') do
    @user = User.new
    erb :"users/new"
  end

  post('/users') do
    @user = User.create(:name => params[:name],
                :password => params[:password],
                :password_confirmation => params[:password_confirmation],
                :username => params[:username],
                :email => params[:email])
    if @user.save
    session[:user_id] = @user.id
    redirect('/')
  else
    flash.now[:errors] = @user.errors.full_messages
    erb :"users/new"
  end
end

  helpers do

    def current_user
      @current_user ||=User.get(session[:user_id]) if session[:user_id]
    end
  end
  # start the server if ruby file executed directly
  run! if app_file == $0
end
