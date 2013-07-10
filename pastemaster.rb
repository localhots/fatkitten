$:.unshift File.dirname(__FILE__)

require 'securerandom'
require 'base64'
require 'yaml'

require 'bundler/setup'
require 'sinatra'
require 'sequel'
require 'encryptor'
require 'slim'
require 'coffee_script'
require 'stylus'
require 'stylus/tilt'
require 'pygments'

require 'app/models/configuration'
require 'app/models/paste'
require 'config/initializers/configuration'
require 'config/initializers/database'
require 'lib/error_pages'
require 'lib/assets'

class Pastemaster < Sinatra::Application
  set :server, 'unicorn'
  set :public_folder, 'public'

  set :slim, pretty: true

  use ErrorPages
  helpers ErrorPages::Forbidden
  use CoffeeAssets
  use StylusAssets

  get '/' do
    @lexers = CONFIG.syntaxes_map

    slim :form, layout: :default
  end

  post '/' do
    paste = Paste.new(params[:contents], params[:type])
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
