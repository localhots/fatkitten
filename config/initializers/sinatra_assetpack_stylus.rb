module Sinatra::AssetPack
  class StylusEngine < Engine
    def css(str, options={})
      Tilt.new("stylus", {:style => :compressed}) { str }.render
    rescue LoadError
      nil
    end
  end

  Compressor.register :css, :stylus, StylusEngine
end
