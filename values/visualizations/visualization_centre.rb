UNDERSCORE = '_'
NAME = 'View'

# Traffic routing object for Visualizations
class VisualizationTraffic
  def initialize(route, data)
    @data = JSON.parse(data, quirks_mode: true)
    @object =
    if route.include? UNDERSCORE
      object = route.split(UNDERSCORE).map(&:capitalize).join
      Object.const_get "#{object}#{NAME}"
    else Object.const_get "#{route.capitalize}#{NAME}"
    end.new(@data)
  end

  def call
    @object.call
  end
end
