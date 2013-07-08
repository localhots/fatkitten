require 'securerandom'
require 'bundler/setup'
require 'sinatra'
require 'sequel'
require 'haml'

require File.expand_path('../config', __FILE__)

DB = Sequel.connect(CONFIG[:database_url])
DB.create_table :pastes do
  primary_key :id
  String :handle
  String :type
  Text :contents
end unless DB.table_exists? :pastes

set :public_folder, 'public'

get '/' do
  haml :form, layout: :default
end

post '/' do
  id = DB[:pastes].insert(handle: SecureRandom.hex, contents: params[:contents])
  record = DB[:pastes].where(id: id).first
  redirect "/#{id}/#{record[:handle]}"
end

get '/:id/:handle' do
  @record = DB[:pastes].where(id: params[:id], handle: params[:handle]).first
  haml :show, layout: :default
end
