$:.unshift File.dirname(__FILE__)
require 'pastemaster'

use Rack::ShowExceptions

run Pastemaster.new
