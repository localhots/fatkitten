require 'securerandom'
require 'base64'

require 'bundler/setup'
require 'sinatra'
require 'sequel'
require 'encryptor'
require 'haml'

require 'app/config'
require 'app/database'
require 'app/paste'

class Pastemaster < Sinatra::Application
  set :public_folder, 'public'

  get '/' do
    haml :form, layout: :default
  end

  post '/' do
    paste = Paste.new(params[:contents])
    id = paste.save

    redirect "/#{id}/#{paste.key}"
  end

  get '/:id/:key' do
    @paste = Paste.find(params[:id])
    redirect '/' unless @paste

    @paste.decrypt(params[:key])
    haml :show, layout: :default
  end
end
