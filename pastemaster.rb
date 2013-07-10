$:.unshift File.dirname(__FILE__)

require 'securerandom'
require 'base64'

require 'bundler/setup'
require 'sinatra'
require 'sequel'
require 'encryptor'
require 'slim'
require 'coffee_script'
require 'stylus'
require 'stylus/tilt'
require 'pygments'

require 'lib/error_pages'
require 'lib/assets'
require 'app/config'
require 'app/database'
require 'app/paste'

class Pastemaster < Sinatra::Application
  set :server, 'unicorn'
  set :public_folder, 'public'

  set :slim, pretty: true

  use ErrorPages
  helpers ErrorPages::Forbidden
  use CoffeeAssets
  use StylusAssets

  get '/' do
    slim :form, layout: :default
  end

  post '/' do
    paste = Paste.new(params[:contents])
    id = paste.save

    redirect "/#{id}/#{paste.key}"
  end

  get '/:id/:key' do
    @paste = Paste.find(params[:id])
    return not_found unless @paste

    begin
      @paste.decrypt(params[:key])

      slim :show, layout: :default
    rescue OpenSSL::Cipher::CipherError
      forbidden
    end
  end
end
