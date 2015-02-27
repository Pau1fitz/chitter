require 'sinatra/base'
require 'data_mapper'

env = ENV['RACK_ENV'] || 'development'

DataMapper.setup(:default, "postgres://localhost/chitter_#{env}")

require './lib/user'
require './lib/cheet'

DataMapper.finalize
DataMapper.auto_upgrade!

class Chitter < Sinatra::Base

  get '/' do
    @cheets = Cheet.all
    erb :index
  end

  post('/cheets') do
    text = params["text"]
    Cheet.create(:text=> text)
    redirect to('/')
  end
  # start the server if ruby file executed directly
  run! if app_file == $0
end
