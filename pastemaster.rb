require 'securerandom'

require 'bundler/setup'
require 'sinatra'
require 'sequel'
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
    record = Paste.add(handle: SecureRandom.hex, contents: params[:contents])
    redirect record ? "/#{id}/#{record[:handle]}" : ''
  end

  get '/:id/:handle' do
    @record = Paste.get(id: params[:id], handle: params[:handle])
    haml :show, layout: :default
  end
end
