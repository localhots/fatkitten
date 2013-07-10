class CoffeeAssets < Sinatra::Base
  set :views, File.expand_path('../../app/assets/javascripts', __FILE__)

  get '/assets/:name.js' do
    path = "#{settings.views}/#{params[:name]}.coffee"
    return not_found unless File.exists?(path)

    coffee params[:name].to_sym
  end
end

class StylusAssets < Sinatra::Base
  set :views, File.expand_path('../../app/assets/stylesheets', __FILE__)

  get '/assets/:name.css' do
    path = "#{settings.views}/#{params[:name]}.styl"
    return not_found unless File.exists?(path)

    stylus params[:name].to_sym
  end
end
