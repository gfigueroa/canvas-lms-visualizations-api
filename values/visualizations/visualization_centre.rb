UNDERSCORE = '_'
NAME = 'View'

# Traffic routing object for Visualizations
class VisualizationTraffic
  def initialize(route, data)
    @data = JSON.parse(data, quirks_mode: true)
    object = route.split(UNDERSCORE).map(&:capitalize).join
    @object = Object.const_get("#{object}#{NAME}").new(@data)
  end

  def call
    @object.call
  end
end
