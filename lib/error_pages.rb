class ErrorPages < Sinatra::Base
  set :views, File.expand_path('../../app/views', __FILE__)

  not_found do
    status 404
    slim :error_404
  end

  module Forbidden
    def forbidden
      status 403
      slim :error_403
    end
  end
end
