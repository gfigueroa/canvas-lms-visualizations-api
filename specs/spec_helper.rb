require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
# require 'vcr'
# require 'webmock/minitest'
# require 'yaml'
# require 'virtus'

ENV['RACK_ENV'] = 'test'

Dir.glob('./{controllers,services,values}/*.rb').each do |file|
  require file
end

include Rack::Test::Methods

def app
  CanvasVisualizationAPI
end
