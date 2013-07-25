$:.unshift File.dirname(__FILE__)

require 'securerandom'
require 'base64'
require 'yaml'

require 'bundler/setup'
require 'sinatra'
require 'sinatra/assetpack'
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

class Pastekitten < Sinatra::Application
  set :root, File.dirname(__FILE__)
  set :server, 'unicorn'
  set :public_folder, 'public'
  set :views, File.expand_path('../app/views', __FILE__)
  set :slim, pretty: true

  register Sinatra::AssetPack
  use ErrorPages
  helpers ErrorPages::Forbidden

  assets do
    serve '/assets/js', from: 'app/assets/js'
    serve '/assets/css', from: 'app/assets/css'
    serve '/assets/img', from: 'app/assets/img'

    css :application, '/assets/css/application.css', [
      '/assets/css/pastekitten.css',
      '/assets/css/dropdown.css',
      '/assets/css/pygments_solarized_modified.css'
    ]
    js :application, '/assets/js/application.js', [
      '/assets/js/pastekitten.js',
      '/assets/js/dropdown.js'
    ]

    js_compression :jsmin
    css_compression :simple
  end

  before do
    correct_domain_name
  end

  get '/' do
    @syntaxes = CONFIG.syntaxes_map

    slim :form, layout: :default
  end

  post '/' do
    redirect '/' if params[:contents].nil? || params[:contents].strip.empty?

    paste = Paste.new(params[:contents], params[:syntax])
    id = paste.save

    redirect "/#{id}/#{paste.key}"
  end

  get '/:id/:key' do
    @paste = Paste.find(params[:id].to_i)
    return not_found unless @paste

    begin
      @paste.decrypt(params[:key])

      slim :show, layout: :default
    rescue OpenSSL::Cipher::CipherError
      forbidden
    end
  end

  def correct_domain_name
    if %w[ www.pastekitten.com pm.localhots.xxx ].include?(request.host)
      redirect 'http://pastekitten.com' + request.fullpath
    end
  end
end
