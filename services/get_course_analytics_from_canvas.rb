# Service Object that gets course analytics from Canvas API
# Depends on what info is request, this covers a number of API calls
class GetCourseAnalyticsFromCanvas
  def initialize(data_for_api)
    @url = data_for_api.canvas_api + 'courses/' + data_for_api.course_id +
           "/analytics/#{data_for_api.data}"
    @canvas_token = data_for_api.canvas_token
  end

  def call
    visit_canvas = VisitCanvasAPI.new(@url, @canvas_token)
    visit_canvas.call
  end
end
