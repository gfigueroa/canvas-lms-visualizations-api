ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'minitest/rg'
require 'rack/test'
# require 'vcr'
# require 'webmock/minitest'
# require 'yaml'
# require 'virtus'

Dir.glob('./{models,controllers,services,values}/*.rb').each do |file|
  require file
end

include Rack::Test::Methods

def app
  CanvasVisualizationAPI
end
